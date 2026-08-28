class Shared::IconButtonComponent < ViewComponent::Base
  delegate :heroicon, to: :helpers

  def initialize(icon: nil, path: "#", method: :get, variant: "ghost", custom_class: "", data: {}, title: nil)
    @icon = icon
    @path = path
    @method = method
    @variant = variant
    @custom_class = custom_class
    @data = data
    @title = title
  end

  def final_classes
    # Base estrutural já definida no seu CSS (p-2, rounded-xl, flex-center)
    base = "glass-icon-btn"
    
    # Mapeamento direto para as classes Outline Glow do application.css
    variant_class = case @variant.to_s
                    when "primary" then "glass-btn-outline-primary"
                    when "danger"  then "glass-btn-outline-danger"
                    when "success" then "glass-btn-outline-success"
                    when "warning" then "glass-btn-outline-warning"
                    when "info"    then "glass-btn-outline-info"
                    when "ghost"   then "glass-icon-btn-ghost"
                    else
                      # Smart Fallback: Aceita novas cores criadas no CSS sem precisar alterar o Ruby
                      "glass-btn-outline-#{@variant}"
                    end
                    
    "#{base} #{variant_class} #{@custom_class}".squish
  end
end