class HeaderComponent < ViewComponent::Base
  # A Correção: Esta linha delega a autorização para o componente usar a gem de ícones
  delegate :heroicon, to: :helpers

  def initialize(title: "Dashboard", user: nil)
    @title = title
    @user = user
  end
end