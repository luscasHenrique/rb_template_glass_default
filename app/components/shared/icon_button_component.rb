class Shared::IconButtonComponent < ViewComponent::Base
  delegate :heroicon, to: :helpers

  # Adicionado o form_id: nil
  def initialize(icon: nil, path: "#", method: :get, variant: "ghost", type: "button_to", custom_class: "", data: {}, title: nil, form_id: nil)
    @icon = icon
    @path = path
    @method = method
    @variant = variant
    @type = type
    @custom_class = custom_class
    @data = data
    @title = title
    @form_id = form_id
  end

  def final_classes
    base = "glass-icon-btn relative outline-none focus:outline-none"
  
    
    variant_class = case @variant.to_s
                    when "primary" then "glass-btn-outline-primary"
                    when "danger"  then "glass-btn-outline-danger"
                    when "success" then "glass-btn-outline-success"
                    when "warning" then "glass-btn-outline-warning"
                    when "info"    then "glass-btn-outline-info"
                    when "ghost"   then "glass-icon-btn-ghost"
                    else
                      "glass-btn-outline-#{@variant}"
                    end
                    
    "#{base} #{variant_class} #{@custom_class}".squish
  end
end