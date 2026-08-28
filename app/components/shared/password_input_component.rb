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

  def merged_input_data
    existing_targets = @input_data[:password_visibility_target].to_s
    @input_data.merge({
      password_visibility_target: "#{existing_targets} input".squish
    })
  end

  def final_classes
    base_class = "glass-input-password-base"
    
    variant_class = case @variant
                    when "danger", "error" then "glass-input-password-danger"
                    when "outline"         then "glass-input-password-outline"
                    else                        "glass-input-password-default"
                    end

    "#{base_class} #{variant_class} #{@custom_class}".squish
  end

  def label_color
    ["danger", "error"].include?(@variant) ? "text-rose-400" : "glass-label"
  end

  def icon_color
    ["danger", "error"].include?(@variant) ? "text-rose-400 hover:text-rose-300" : "text-white/40 hover:text-white"
  end
end