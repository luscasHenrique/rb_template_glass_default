class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  
  # Gatilhos Globais de Segurança e Auditoria
  before_action :authenticate_user!
  before_action :set_paper_trail_whodunnit
  before_action :check_term_acceptance
  
  # Cache (Otimização Hotwire/Turbo)
  stale_when_importmap_changes
  
  # Trava Global de Autorização (Pundit)
  include Pundit::Authorization
  after_action :verify_authorized, unless: :devise_controller?

  # ==========================================
  # INTERCEPTADORES DE EXCEÇÕES (Mapeamento HTTP)
  # ==========================================
  # 403 - Proibido (Falha de Permissão Pundit)
  rescue_from Pundit::NotAuthorizedError, with: :handle_403_forbidden
  
  # 404 - Não Encontrado (Busca no banco que não existe)
  rescue_from ActiveRecord::RecordNotFound, with: :handle_404_not_found
  
  # 409 - Conflito (Tentativa de duplicar dados únicos no banco)
  rescue_from ActiveRecord::RecordNotUnique, with: :handle_409_conflict
  
  # 422 - Entidade Não Processável (Falha de CSRF Token / Sessão)
  rescue_from ActionController::InvalidAuthenticityToken, with: :handle_422_unprocessable_entity

  # 500 - Erro Interno (Oculto em produção)
  unless Rails.env.development?
    rescue_from StandardError, with: :handle_500_internal_server_error
  end

  # Engine de Layout e Parâmetros
  layout :layout_by_resource
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # ==========================================
  # 1. AUDITORIA (PaperTrail) - Rastreio Global
  # ==========================================
  def user_for_paper_trail
    user_signed_in? ? current_user.id : 'Guest'
  end

  # ==========================================
  # 2. DEVISE (Sanitização de Parâmetros Seguros)
  # ==========================================
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [
      profile_attributes: [ :first_name, :last_name, :phone ]
    ])
    devise_parameter_sanitizer.permit(:account_update, keys: [
      profile_attributes: [
        :id, :first_name, :last_name, :phone, :bio, :avatar_url,
        address_attributes: [ :id, :street, :number, :complement, :city, :state, :zip_code ]
      ]
    ])
  end

  private

  # ==========================================
  # 3. REGRAS DE NEGÓCIO E LAYOUT
  # ==========================================
  def check_term_acceptance
    return unless user_signed_in?
    
    # Se o usuário já estiver na tela do Devise ou na tela de Termos, permite o fluxo
    return if devise_controller? || controller_name == 'terms'

    unless current_user.accepted_current_term?
      # AQUI ENTRA O NOVO COMPORTAMENTO:
      # Bloqueia a navegação e joga o usuário obrigatoriamente para a "Sala de Espera"
      redirect_to pending_terms_path
    end
  end

  def layout_by_resource
    if devise_controller?
      if resource_name == :user && action_name.in?(%w[edit update])
        "application" # Mantém a Sidebar e Header nas configurações do usuário logado
      else
        "devise" # Usa o layout limpo para Login/Cadastro
      end
    else
      "application"
    end
  end

  # ==========================================
  # 4. MÉTODOS DE FALLBACK (Tradução e UX)
  # ==========================================
  def handle_403_forbidden
    flash[:alert] = "Acesso Proibido (403): Você não possui nível de acesso para esta funcionalidade."
    redirect_based_on_auth_status
  end

  def handle_404_not_found
    flash[:alert] = "Não Encontrado (404): O registro ou a página que você tentou acessar não existe mais."
    redirect_based_on_auth_status
  end

  def handle_409_conflict
    flash[:warning] = "Conflito (409): Os dados que você tentou salvar já existem ou estão em uso no sistema."
    redirect_based_on_auth_status
  end

  def handle_422_unprocessable_entity
    flash[:warning] = "Requisição Inválida (422): Sua sessão pode ter expirado. Por favor, recarregue a página e tente novamente."
    redirect_based_on_auth_status
  end

  def handle_500_internal_server_error(exception)
    Rails.logger.error "💥 [ERRO INTERNO 500]: #{exception.message}"
    Rails.logger.error exception.backtrace.join("\n")
    flash[:danger] = "Erro Interno do Servidor (500): Ocorreu uma instabilidade no sistema. Nossa engenharia já foi notificada."
    redirect_based_on_auth_status
  end

  def redirect_based_on_auth_status
    if user_signed_in?
      redirect_to(request.referrer || root_path)
    else
      redirect_to new_user_session_path
    end
  end
end