class Shared::CookieBannerComponent < ViewComponent::Base
  delegate :heroicon, to: :helpers

  # Injetamos o cookie do usuário e a política ativa atual
  def initialize(cookie_consent: nil, current_policy: nil)
    @cookie_consent = cookie_consent
    @current_policy = current_policy
  end

  def render?
    # Não renderiza se não houver política ativa cadastrada no sistema
    return false unless @current_policy
    
    # Renderiza o banner SE o cookie do usuário for diferente da versão ativa
    @cookie_consent != @current_policy.version
  end
end