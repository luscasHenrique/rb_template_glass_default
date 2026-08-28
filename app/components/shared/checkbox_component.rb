class Shared::CheckboxComponent < ViewComponent::Base
  attr_reader :form, :field, :label, :description, :input_data

  def initialize(form:, field:, variant: "default", custom_class: "p-4", label: nil, description: nil, input_data: {})
    @form = form
    @field = field
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