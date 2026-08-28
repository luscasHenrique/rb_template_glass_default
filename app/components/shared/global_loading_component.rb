class Shared::GlobalLoadingComponent < ViewComponent::Base
  def initialize(text: "Carregando...", variant: "primary")
    @text = text
    @variant = variant
  end

  def text_variant_class
    "glass-loader-text-#{@variant}"
  end
end