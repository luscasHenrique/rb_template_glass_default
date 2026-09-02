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

  # ARQUITETURA LIMPA: Verifica se há erro para repassar a cor correta ao Label
  def has_error?
    @form.object.present? && @form.object.errors[@field].any?
  end

  def label_color
    has_error? ? "text-rose-400" : "glass-label"
  end
end