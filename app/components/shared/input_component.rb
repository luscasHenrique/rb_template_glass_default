class Shared::InputComponent < ViewComponent::Base
  attr_reader :form, :field, :type, :label, :placeholder, :input_data, :value

  def initialize(form:, field:, type: "text", variant: "default", custom_class: "", placeholder: "", label: nil, input_data: {}, value: nil)
    @form = form
    @field = field
    @type = type
    @variant = variant
    @custom_class = custom_class
    @placeholder = placeholder
    @label = label
    @input_data = input_data
    @value = value
  end

  # ARQUITETURA LIMPA: Constrói as opções HTML dinamicamente.
  # Delega ao Rails a responsabilidade de preencher o valor (Data Binding)
  # a menos que um valor explícito tenha sido passado via parâmetro.
  def input_options
    opts = { class: final_classes, placeholder: @placeholder, data: @input_data }
    opts[:value] = @value unless @value.nil?
    opts
  end

  def final_classes
    base_classes = "glass-input"
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