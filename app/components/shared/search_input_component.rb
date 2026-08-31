class Shared::SearchInputComponent < ViewComponent::Base
  delegate :heroicon, to: :helpers

  def initialize(form:, field:, label: nil, placeholder: "Pesquisar...", value: nil, custom_class: "")
    @form = form
    @field = field
    @label = label
    @placeholder = placeholder
    @value = value
    @custom_class = custom_class
  end
end