require 'csv'

module Admin
  class AuditsController < ApplicationController
    def index
      authorize [:admin, :audit]
      
      # 1. Base da Query
      query = PaperTrail::Version.order(created_at: :desc)
      
      # 2. Filtros Dinâmicos
      if params[:whodunnit_ids].present? && params[:whodunnit_ids].reject(&:blank?).any?
        query = query.where(whodunnit: params[:whodunnit_ids].reject(&:blank?))
      end

      if params[:item_types].present? && params[:item_types].reject(&:blank?).any?
        query = query.where(item_type: params[:item_types].reject(&:blank?))
      end

      if params[:item_id].present?
        query = query.where(item_id: params[:item_id].to_s.strip)
      end

      if params[:start_date].present?
        query = query.where("created_at >= ?", params[:start_date].to_date.beginning_of_day)
      end

      if params[:end_date].present?
        query = query.where("created_at <= ?", params[:end_date].to_date.end_of_day)
      end

      @versions = query.limit(100)
      
      # 3. Coleções dos MultiSelects
      @operators_collection = User.order(:email).pluck(:email, :id).map { |email, id| [email, id.to_s] }
      @item_types_collection = [
        ["Usuários (User)", "User"],
        ["Perfis (Profile)", "Profile"],
        ["Endereços (Address)", "Address"]
      ]

      # 4. Anti N+1 para Autores
      user_ids = @versions.pluck(:whodunnit).reject(&:blank?).uniq
      @users_map = User.where(id: user_ids).index_by { |u| u.id.to_s }

      # 5. Mapeamento de Alvos Vivos (Usuários que ainda existem no banco)
      target_user_ids = @versions.select { |v| v.item_type == 'User' }.map(&:item_id)
      target_profile_ids = @versions.select { |v| v.item_type == 'Profile' }.map(&:item_id)
      
      profiles_map = Profile.where(id: target_profile_ids).pluck(:id, :user_id).to_h
      all_target_user_ids = (target_user_ids + profiles_map.values).compact.uniq
      
      @target_users_map = User.where(id: all_target_user_ids).index_by(&:id)
      @profiles_user_map = profiles_map

      respond_to do |format|
        format.html
        format.csv { send_data generate_csv(@versions, @users_map), filename: "auditoria_global_#{Date.today}.csv" }
      end
    end

    def show
      authorize [:admin, :audit]
      @version = PaperTrail::Version.find(params[:id])
      @user = User.find_by(id: @version.whodunnit)
    end

    # ARQUITETURA LIMPA: Helper do Controller para extrair o e-mail (Vivo ou Deletado)
    helper_method :resolve_target_email
    def resolve_target_email(version)
      # 1. Tenta recuperar o registro VIVO na tabela
      if version.item_type == 'User'
        live_user = @target_users_map[version.item_id]
        return live_user.email if live_user.present?
      elsif version.item_type == 'Profile'
        user_id = @profiles_user_map[version.item_id]
        live_user = @target_users_map[user_id]
        return "#{live_user.email} (Perfil)" if live_user.present?
      end

      # 2. Se for um registro DELETADO (destroy), ressuscita do log via .reify
      reified_item = version.reify
      if reified_item.present?
        if reified_item.is_a?(User)
          return "#{reified_item.email} (Excluído)"
        elsif reified_item.is_a?(Profile)
          # Tenta buscar o e-mail do dono do perfil deletado
          user = User.find_by(id: reified_item.user_id)
          return user ? "#{user.email} (Perfil Excluído)" : "Perfil do Usuário ##{reified_item.user_id} (Excluído)"
        end
      end

      # 3. Fallback para outras entidades genéricas
      "#{version.item_type} ##{version.item_id}"
    end

    private

    def generate_csv(versions, users_map)
      CSV.generate(headers: true) do |csv|
        csv << ["ID do Log", "Data/Hora", "Ação", "Tabela Afetada", "ID do Registro", "Usuário Responsável (Whodunnit)"]
        
        versions.each do |v|
          action = case v.event
                   when 'create' then 'Criação'
                   when 'update' then 'Atualização'
                   when 'destroy' then 'Exclusão'
                   else v.event
                   end
                   
          user_info = users_map[v.whodunnit]&.email || "Sistema / ID: #{v.whodunnit}"

          csv << [
            v.id,
            v.created_at.strftime("%d/%m/%Y %H:%M:%S"),
            action,
            v.item_type,
            v.item_id,
            user_info
          ]
        end
      end
    end
  end
end