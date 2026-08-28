class Shared::MultiSelectComponent < ViewComponent::Base
  # Autoriza o componente a consumir a gem Heroicons
  delegate :heroicon, to: :helpers

  def initialize(form:, field:, selected_items: [], label: nil)
    @form = form
    @field = field
    @selected_items = selected_items # Ex: [{text: "Opção 1", id: 1}]
    @label = label
  end
end