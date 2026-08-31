class Shared::TextareaComponent < ViewComponent::Base
  attr_reader :form, :field, :label, :placeholder, :input_data, :value

  def initialize(form:, field:, variant: "default", custom_class: "", placeholder: "", label: nil, input_data: {}, value: nil)
    @form = form
    @field = field
    @variant = variant
    @custom_class = custom_class
    @placeholder = placeholder
    @label = label
    @input_data = input_data
    @value = value
  end

  # ARQUITETURA LIMPA: Constrói as opções dinamicamente para preservar o Data Binding do Rails.
  def input_options
    opts = { class: final_classes, placeholder: @placeholder, data: @input_data }
    opts[:value] = @value unless @value.nil?
    opts
  end

  def final_classes
    base = "glass-textarea"
    variant_class = ["danger", "error"].include?(@variant) ? "glass-textarea-error" : ""
    "#{base} #{variant_class} #{@custom_class}".squish
  end

  def label_color
    ["danger", "error"].include?(@variant) ? "text-rose-400" : "glass-label"
  end
end