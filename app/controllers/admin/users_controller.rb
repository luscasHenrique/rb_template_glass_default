require 'csv'

module Admin
  class UsersController < ApplicationController
    before_action :set_user, only: [:edit, :update, :confirm_destroy, :destroy]

    def index
      authorize [:admin, :user]
      
      @users = User.left_joins(:profile).order(created_at: :desc)

      if params[:query].present?
        termo = "%#{params[:query]}%"
        @users = @users.where("users.email ILIKE :q OR profiles.first_name ILIKE :q OR profiles.last_name ILIKE :q", q: termo)
      end

      @users = @users.where(role: params[:role]) if params[:role].present?
      @users = @users.where("users.created_at >= ?", params[:start_date].to_date.beginning_of_day) if params[:start_date].present?
      @users = @users.where("users.created_at <= ?", params[:end_date].to_date.end_of_day) if params[:end_date].present?

      respond_to do |format|
        format.html
        format.csv { send_data generate_csv(@users), filename: "usuarios-#{Date.today}.csv" }
      end
    end

    def new
      authorize [:admin, :user]
      @user = User.new
      @user.build_profile # Instancia o perfil em memória para o fields_for renderizar os inputs
    end

    def create
      authorize [:admin, :user]
      @user = User.new(user_params)

      if @user.save
        redirect_to admin_users_path, notice: "Usuário cadastrado com sucesso."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      authorize [:admin, :user]
      @user.build_profile unless @user.profile # Fallback de segurança caso seja um registro legado sem perfil
    end

    def update
      authorize [:admin, :user]
      
      if @user.update(user_params)
        redirect_to admin_users_path, notice: "Dados atualizados com sucesso."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def confirm_destroy
      authorize [:admin, :user]
    end

    def destroy
      authorize [:admin, :user]
      @user.destroy
      redirect_to admin_users_path, notice: "Usuário excluído com sucesso."
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      # Inteligência do Devise: Se o admin não preencheu a senha na edição, removemos do payload para não quebrar a validação
      if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)
      end

      # Libera os atributos diretos e os aninhados do Profile
      params.require(:user).permit(
        :email, :role, :active, :password, :password_confirmation,
        profile_attributes: [:id, :first_name, :last_name, :phone]
      )
    end

    def generate_csv(users)
      CSV.generate(headers: true) do |csv|
        csv << ["ID", "Nome Completo", "E-mail", "Papel", "Status", "Data de Criação"]
        users.each do |u|
          csv << [
            u.id, 
            "#{u.profile&.first_name} #{u.profile&.last_name}", 
            u.email, 
            u.role.upcase, 
            u.active ? "Ativo" : "Inativo", 
            u.created_at.strftime("%d/%m/%Y")
          ]
        end
      end
    end
  end
end