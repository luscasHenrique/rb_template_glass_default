class Shared::CheckboxGroupComponent < ViewComponent::Base
  def initialize(form:, field:, collection:, label: nil, type: :checkbox, custom_class: "")
    @form = form
    @field = field
    @collection = collection # Ex: [["Opção 1", "val1"], ["Opção 2", "val2"]]
    @label = label
    @type = type # :checkbox ou :radio
    @custom_class = custom_class
  end
end