class Shared::PasswordInputComponent < ViewComponent::Base
  # Correção Arquitetural: Delega a nova gem heroicon
  delegate :heroicon, to: :helpers
  
  attr_reader :form, :field, :label, :placeholder, :input_data

  def initialize(form:, field:, variant: "default", custom_class: "px-4 py-3 text-base w-full", placeholder: "", label: nil, input_data: {})
    @form = form
    @field = field
    @variant = variant
    @custom_class = custom_class
    @placeholder = placeholder
    @label = label
    @input_data = input_data
  end

  # ARQUITETURA LIMPA: Verifica se há erro no campo
  def has_error?
    @form.object.present? && @form.object.errors[@field].any?
  end

  # Captura a primeira mensagem de erro traduzida
  def error_message
    @form.object.errors[@field].first
  end

  def merged_input_data
    existing_targets = @input_data[:password_visibility_target].to_s
    @input_data.merge({
      password_visibility_target: "#{existing_targets} input".squish
    })
  end

  def final_classes
    base_class = "glass-input-password-base"
    
    # Se houver erro, subscreve a variante padrão para erro
    active_variant = has_error? ? "error" : @variant

    variant_class = case active_variant
                    when "danger", "error" then "glass-input-password-danger"
                    when "outline"         then "glass-input-password-outline"
                    else                        "glass-input-password-default"
                    end

    "#{base_class} #{variant_class} #{@custom_class}".squish
  end

  def label_color
    has_error? || ["danger", "error"].include?(@variant) ? "text-rose-400" : "glass-label"
  end

  def icon_color
    # Se houver erro, o ícone de mostrar/ocultar senha também fica vermelho
    has_error? || ["danger", "error"].include?(@variant) ? "text-rose-400 hover:text-rose-300" : "text-white/40 hover:text-white"
  end
end