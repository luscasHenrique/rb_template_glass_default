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

  # ARQUITETURA LIMPA: Intercepta falhas do Active Record
  def has_error?
    @form.object.present? && @form.object.errors[@field].any?
  end

  def error_message
    @form.object.errors[@field].first
  end

  def label_color
    has_error? ? "text-rose-400" : "glass-label"
  end

  def trigger_classes
    base = "glass-input glass-input-md flex items-center justify-between w-full outline-none"
    state_class = has_error? ? "glass-input-error" : "glass-input-default"
    "#{base} #{state_class}"
  end

  def current_selected_text
    selected_val = @form.object.send(@field) if @form.object.respond_to?(@field)
    found = @collection.find { |item| item.last.to_s == selected_val.to_s }
    found ? found.first : @placeholder
  end
end