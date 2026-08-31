class Shared::RadioButtonComponent < ViewComponent::Base
  attr_reader :form, :field, :value, :label, :custom_class, :input_data

  # ARQUITETURA LIMPA: Adicionado input_data para garantir extensibilidade JS (Stimulus)
  def initialize(form:, field:, value:, label:, custom_class: "", input_data: {})
    @form = form
    @field = field
    @value = value
    @label = label
    @custom_class = custom_class
    @input_data = input_data
  end

  def final_classes
    "glass-radio-wrapper #{@custom_class}".squish
  end
end