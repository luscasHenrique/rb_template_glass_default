class Shared::FlashMessagesComponent < ViewComponent::Base
  # Autoriza o componente a enxergar a biblioteca de ícones
  delegate :heroicon, to: :helpers

  def initialize(flash:)
    @flash = flash
  end

  def toast_class(type)
    base = "glass-toast"
    variant = case type.to_s
              when "notice" then "glass-toast-notice"
              when "success" then "glass-toast-success"
              when "error", "alert" then "glass-toast-error"
              when "warning" then "glass-toast-alert"
              else "glass-toast-notice"
              end
    "#{base} #{variant}"
  end

  # Mapeamento limpo e semântico dos ícones
  def icon_for(type)
    case type.to_s
    when "success" then "check-circle"
    when "error", "alert" then "exclamation-triangle"
    when "warning" then "exclamation-circle"
    else "information-circle"
    end
  end
end