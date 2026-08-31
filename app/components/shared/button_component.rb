class Shared::ButtonComponent < ViewComponent::Base
  delegate :heroicon, to: :helpers

  # Adicionado o form_id: nil
  def initialize(text: nil, variant: "primary", type: "button", method: :get, path: "#", icon: nil, icon_position: "left", loading_text: "Aguarde...", disable_loading: false, custom_class: "", data: {}, onclick: nil, form_id: nil)
    @text = text
    @variant = variant
    @type = type
    @method = method
    @path = path
    @icon = icon
    @icon_position = icon_position
    @loading_text = loading_text
    @disable_loading = disable_loading
    @custom_class = custom_class
    @data_attributes = data
    @onclick = onclick
    @form_id = form_id
  end

  def merged_data
    return @data_attributes if @disable_loading

    existing_controllers = @data_attributes[:controller].to_s
    existing_actions     = @data_attributes[:action].to_s

    @data_attributes.merge({
      controller: "#{existing_controllers} button-loading".squish,
      action: "#{existing_actions} click->button-loading#load".squish
    })
  end

  def final_classes
    has_size = @custom_class.match?(/(glass-btn-(xsm|sm|md|lg)|\bp-|\bpx-|\bpy-)/)
    default_size = has_size ? "" : "glass-btn-md"
    
base_classes = "glass-btn relative outline-none focus:outline-none"
    variant_classes = case @variant.to_s
                      when "primary"   then "glass-btn-primary"
                      when "danger"    then "glass-btn-danger"
                      when "success"   then "glass-btn-success"
                      when "warning"   then "glass-btn-warning"
                      when "info"      then "glass-btn-info"
                      when "blue"      then "glass-btn-blue"
                      when "secondary", "default", "ghost" then "glass-btn-secondary"
                      when "none"      then ""
                      when /^outline-(.*)$/ then "glass-btn-#{@variant}"
                      else "glass-btn-#{@variant}"
                      end

    "#{base_classes} #{default_size} #{variant_classes} #{@custom_class}".squish
  end
end