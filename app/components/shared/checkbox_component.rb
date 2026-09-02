class Shared::CheckboxComponent < ViewComponent::Base
  attr_reader :form, :field, :label, :description, :input_data, :checked_value, :unchecked_value, :multiple

  # ARQUITETURA LIMPA: form: nil como padrão para permitir uso em tabelas
  def initialize(form: nil, field:, checked_value: "1", unchecked_value: "0", multiple: false, variant: "default", custom_class: "p-4", label: nil, description: nil, input_data: {})
    @form = form
    @field = field
    @checked_value = checked_value
    @unchecked_value = unchecked_value
    @multiple = multiple
    @variant = variant
    @custom_class = custom_class
    @label = label
    @description = description
    @input_data = input_data
  end

  def has_error?
    @form.present? && @form.object.present? && @form.object.errors[@field].any?
  end

  def final_classes
    base_class = "glass-checkbox-wrapper"
    active_variant = has_error? ? "error" : @variant
    
    variant_class = case active_variant
                    when "danger", "error" then "glass-checkbox-wrapper-danger"
                    when "success"         then "glass-checkbox-wrapper-success"
                    when "outline"         then "glass-checkbox-wrapper-outline"
                    when "minimal"         then "glass-checkbox-wrapper-minimal"
                    else                        "glass-checkbox-wrapper-default"
                    end

    "#{base_class} #{variant_class} #{@custom_class}".squish
  end

  def text_color
    has_error? || ["danger", "error"].include?(@variant) ? "text-rose-400" : "text-white"
  end

  def desc_color
    has_error? || ["danger", "error"].include?(@variant) ? "text-rose-400/70" : "text-white/50"
  end
end