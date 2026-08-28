class Shared::CustomSelectComponent < ViewComponent::Base
  # Delega a autorização para uso da API de ícones do Heroicons
  delegate :heroicon, to: :helpers

  attr_reader :form, :field, :collection, :label, :placeholder

  def initialize(form:, field:, collection:, label: nil, placeholder: "Selecione uma opção...")
    @form = form
    @field = field
    @collection = collection
    @label = label
    @placeholder = placeholder
  end

  def current_selected_text
    selected_val = @form.object.send(@field) if @form.object.respond_to?(@field)
    found = @collection.find { |item| item.last.to_s == selected_val.to_s }
    found ? found.first : @placeholder
  end
end