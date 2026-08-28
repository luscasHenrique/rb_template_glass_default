class Shared::TextareaComponent < ViewComponent::Base
  attr_reader :form, :field, :label, :placeholder, :input_data

  def initialize(form:, field:, variant: "default", custom_class: "", placeholder: "", label: nil, input_data: {})
    @form = form
    @field = field
    @variant = variant
    @custom_class = custom_class
    @placeholder = placeholder
    @label = label
    @input_data = input_data
  end

  def final_classes
    base = "glass-textarea"
    variant_class = ["danger", "error"].include?(@variant) ? "glass-textarea-error" : ""
    "#{base} #{variant_class} #{@custom_class}".squish
  end

  # Regra de negócio visual: Mantém o padrão de erro dos outros inputs
  def label_color
    ["danger", "error"].include?(@variant) ? "text-rose-400" : "glass-label"
  end
end