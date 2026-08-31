class Shared::BadgeComponent < ViewComponent::Base
  delegate :heroicon, to: :helpers

  def initialize(text:, variant: "grey", icon: nil, custom_class: "")
    @text = text
    @variant = variant
    @icon = icon
    @custom_class = custom_class
  end

  def final_classes
    # ARQUITETURA LIMPA:
    # 1. inline-inline-flex + items-center + justify-center: Garante alinhamento central em ambos os eixos.
    # 2. leading-none + text-xs: Zera a altura de linha sobrante para alinhar pela caixa da fonte.
    # 3. px-2.5 py-1: Mantém o padding proporcional para a pílula.
    base = "inline-flex items-center justify-center gap-1.5 px-2.5 py-1 rounded-full text-xs font-bold tracking-wider leading-none select-none cursor-default transition-all duration-300"
    
    variant_class = "glass-btn-outline-#{@variant}"

    "#{base} #{variant_class} #{@custom_class}".squish
  end
end