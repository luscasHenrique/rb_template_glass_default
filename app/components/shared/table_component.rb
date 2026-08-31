class Shared::TableComponent < ViewComponent::Base
  # A MÁGICA DOS SLOTS: Gavetas dinâmicas que a view injeta na tabela
  renders_one :filters
  renders_one :actions

  def initialize(headers: [], selectable: false, custom_class: "", max_height: nil, pagination: nil)
    @headers = headers
    @selectable = selectable
    @custom_class = custom_class
    @max_height = max_height
    @pagination = pagination
  end
end