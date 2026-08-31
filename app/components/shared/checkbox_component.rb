class Shared::CheckboxComponent < ViewComponent::Base
  attr_reader :form, :field, :label, :description, :input_data, :checked_value, :unchecked_value, :multiple

  # Adicionados os parâmetros nativos do Rails para checkboxes
  def initialize(form:, field:, checked_value: "1", unchecked_value: "0", multiple: false, variant: "default", custom_class: "p-4", label: nil, description: nil, input_data: {})
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

  def final_classes
    base_class = "glass-checkbox-wrapper"
    
    variant_class = case @variant
                    when "danger", "error" then "glass-checkbox-wrapper-danger"
                    when "success"         then "glass-checkbox-wrapper-success"
                    when "outline"         then "glass-checkbox-wrapper-outline"
                    when "minimal"         then "glass-checkbox-wrapper-minimal"
                    else                        "glass-checkbox-wrapper-default"
                    end

    "#{base_class} #{variant_class} #{@custom_class}".squish
  end

  def text_color
    ["danger", "error"].include?(@variant) ? "text-rose-100" : "text-white"
  end

  def desc_color
    ["danger", "error"].include?(@variant) ? "text-rose-200/70" : "text-white/50"
  end
end