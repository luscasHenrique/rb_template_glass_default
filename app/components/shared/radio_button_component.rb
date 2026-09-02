class Shared::RadioButtonComponent < ViewComponent::Base
  attr_reader :form, :field, :value, :label, :custom_class, :input_data

  def initialize(form:, field:, value:, label:, custom_class: "", input_data: {})
    @form = form
    @field = field
    @value = value
    @label = label
    @custom_class = custom_class
    @input_data = input_data
  end

  # ARQUITETURA LIMPA: Verifica se há erro no campo para alterar o estado visual
  def has_error?
    @form.object.present? && @form.object.errors[@field].any?
  end

  def final_classes
    "glass-radio-wrapper #{@custom_class}".squish
  end

  def radio_classes
    base = "glass-radio"
    # Adiciona anel e cor vermelha caso o preenchimento seja inválido
    has_error? ? "#{base} border-rose-500 text-rose-500 focus:ring-rose-500 bg-rose-500/10" : base
  end

  def label_color
    # Altera a cor do texto do label para vermelho
    has_error? ? "text-rose-400" : "text-white"
  end
end