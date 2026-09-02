class Shared::MultiSelectComponent < ViewComponent::Base
  delegate :heroicon, to: :helpers

  def initialize(form:, field:, collection:, label: nil, variant: "primary", placeholder: "Selecione..")
    @form = form
    @field = field
    @collection = collection 
    @label = label
    @variant = variant
    @placeholder = placeholder
  end

  # ARQUITETURA LIMPA: Detecção de erros no Active Record
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
    base = "glass-input glass-input-md flex flex-wrap items-center gap-1.5 cursor-pointer transition-all min-h-[48px] m-0"
    state_class = has_error? ? "glass-input-error" : "glass-input-default"
    "#{base} #{state_class}"
  end

  # Mapeia as cores das tags baseado nas suas variantes Outline Glow
  def tag_classes
    case @variant.to_s
    when "primary" then "bg-violet-500/20 border-violet-500/30 text-violet-200"
    when "success" then "bg-emerald-500/20 border-emerald-500/30 text-emerald-200"
    when "danger"  then "bg-rose-500/20 border-rose-500/30 text-rose-200"
    when "warning" then "bg-amber-500/20 border-amber-500/30 text-amber-200"
    when "info"    then "bg-cyan-500/20 border-cyan-500/30 text-cyan-200"
    else "bg-white/10 border-white/20 text-white"
    end
  end

  # Cor do checkmark interno da lista
  def check_color
    case @variant.to_s
    when "primary" then "bg-violet-500"
    when "success" then "bg-emerald-500"
    when "danger"  then "bg-rose-500"
    when "warning" then "bg-amber-500"
    when "info"    then "bg-cyan-500"
    else "bg-white/30"
    end
  end
end