class Shared::ModalComponent < ViewComponent::Base
  # Autoriza o componente a consumir a gem Heroicon
  delegate :heroicon, to: :helpers

  renders_one :header
  renders_one :body
  renders_one :footer

  def initialize(id:, size: "md")
    @id = id
    @size = size
  end

  def size_class
    case @size
    when "sm" then "max-w-md"
    when "lg" then "max-w-4xl"
    when "xl" then "max-w-6xl"
    else "max-w-2xl"
    end
  end
end