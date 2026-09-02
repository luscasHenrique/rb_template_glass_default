class Shared::CheckboxGroupComponent < ViewComponent::Base
  delegate :heroicon, to: :helpers

  def initialize(form:, field:, collection:, label: nil, type: :checkbox, custom_class: "")
    @form = form
    @field = field
    @collection = collection
    @label = label
    @type = type
    @custom_class = custom_class
  end

  def has_error?
    @form.object.present? && @form.object.errors[@field].any?
  end

  def error_message
    @form.object.errors[@field].first
  end

  def label_color
    has_error? ? "text-rose-400" : "glass-label"
  end
end