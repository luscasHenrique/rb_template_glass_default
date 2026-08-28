class SidebarComponent < ViewComponent::Base
  delegate :heroicon, to: :helpers
  attr_reader :user, :nav_items

  def initialize(user:)
    @user = user
    @nav_items = NavigationConfig.for(user)
  end
end