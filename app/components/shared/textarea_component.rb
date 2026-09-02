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

  # ARQUITETURA LIMPA: Verifica se existe erro de validação neste campo específico
  def has_error?
    @form.object.present? && @form.object.errors[@field].any?
  end

  # Captura a primeira mensagem de erro traduzida
  def error_message
    @form.object.errors[@field].first
  end

  def input_options
    opts = { class: final_classes, placeholder: @placeholder, data: @input_data }
    opts[:value] = @value unless @value.nil?
    opts
  end

  def final_classes
    base = "glass-textarea"
    
    # Se o Active Record acusar erro, subscreve a variante padrão para erro
    active_variant = has_error? ? "error" : @variant
    variant_class = ["danger", "error"].include?(active_variant) ? "glass-textarea-error" : ""
    
    "#{base} #{variant_class} #{@custom_class}".squish
  end

  def label_color
    has_error? || ["danger", "error"].include?(@variant) ? "text-rose-400" : "glass-label"
  end
end