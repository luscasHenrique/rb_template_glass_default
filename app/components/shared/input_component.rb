class Shared::InputComponent < ViewComponent::Base
  attr_reader :form, :field, :type, :label, :placeholder, :input_data

  def initialize(form:, field:, type: "text", variant: "default", custom_class: "", placeholder: "", label: nil, input_data: {})
    @form = form
    @field = field
    @type = type
    @variant = variant
    @custom_class = custom_class
    @placeholder = placeholder
    @label = label
    @input_data = input_data
  end

  # ==========================================
  # LÓGICA DE ESTILOS (O CSS dinâmico que tiramos da View)
  # ==========================================
  def final_classes
    base_classes = "glass-input"
    
    # Smart Sizing: Se a custom_class já tiver um padding ou tamanho, não aplica o padrão
    has_size = @custom_class.match?(/(glass-input-(sm|md|lg)|\bp-|\bpx-|\bpy-)/)
    default_size = has_size ? "" : "glass-input-md"

    variant_classes = case @variant
                      when "danger", "error" then "glass-input-error"
                      when "success"         then "glass-input-success"
                      when "warning"         then "glass-input-warning"
                      when "info"            then "glass-input-info"
                      else "glass-input-default"
                      end

    "#{base_classes} #{default_size} #{variant_classes} #{@custom_class}".squish
  end

  def label_color
    ["danger", "error"].include?(@variant) ? "text-rose-400" : "glass-label"
  end
end