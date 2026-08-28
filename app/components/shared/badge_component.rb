class Shared::BadgeComponent < ViewComponent::Base
  delegate :heroicon, to: :helpers

  def initialize(text:, variant: "grey", icon: nil)
    @text = text
    @variant = variant
    @icon = icon
  end

  def final_classes
    # Base específica para Badge: formato de pílula, não clicável (cursor-default)
    base = "inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-bold tracking-wider cursor-default transition-all duration-300"
    
    # Reutiliza as classes de cores Neon que já existem no seu application.css
    variant_class = "glass-btn-outline-#{@variant}"

    "#{base} #{variant_class}".squish
  end
end