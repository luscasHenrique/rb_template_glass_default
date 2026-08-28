class Shared::RadioButtonComponent < ViewComponent::Base
  attr_reader :form, :field, :value, :label, :custom_class

  def initialize(form:, field:, value:, label:, custom_class: "")
    @form = form
    @field = field
    @value = value
    @label = label
    @custom_class = custom_class
  end

  def final_classes
    "glass-radio-wrapper #{@custom_class}".squish
  end
end