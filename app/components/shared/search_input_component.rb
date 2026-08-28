class Shared::SearchInputComponent < ViewComponent::Base
  # Autoriza o componente a consumir a gem Heroicons
  delegate :heroicon, to: :helpers

  def initialize(form:, field:, placeholder: "Pesquisar...")
    @form = form
    @field = field
    @placeholder = placeholder
  end
end