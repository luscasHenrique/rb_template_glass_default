class CookiePoliciesController < ApplicationController
  # 1. Libera o acesso para visitantes não logados (Devise)
  skip_before_action :authenticate_user!, raise: false
  
  # 2. AQUI: Desliga a trava global de autorização obrigatória (Pundit)
  skip_after_action :verify_authorized
  
  def show
    @policy = CookiePolicy.current
    
    if @policy.nil?
      redirect_to root_path, warning: "Nenhuma política de cookies está ativa no momento."
    end
  end
end