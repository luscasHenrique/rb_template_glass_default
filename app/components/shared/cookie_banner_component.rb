class Shared::CookieBannerComponent < ViewComponent::Base
  # Autoriza o componente a enxergar a biblioteca de ícones
  delegate :heroicon, to: :helpers
end