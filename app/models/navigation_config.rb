class NavigationConfig
  ITEMS = [
    {
      title: "Dashboard",
      path: -> { Rails.application.routes.url_helpers.root_path },
      icon: "presentation-chart-bar",
      policy_record: :dashboard, 
      policy_action: :index? # <-- Ajustado para bater com o DashboardPolicy
    },
    {
      title: "Agenda",
      section: "Produtividade", 
      icon: "calendar-days",
      policy_record: :dashboard,
      policy_action: :index?,
      sub_items: [
        {
          title: "Minha Agenda",
          path: -> { Rails.application.routes.url_helpers.respond_to?(:schedule_items_path) ? Rails.application.routes.url_helpers.schedule_items_path : "#" },
          policy_record: :dashboard,
          policy_action: :index?
        }
      ]
    },
    {
      title: "Gráficos",
      section: "Análises",
      icon: "chart-pie",
      policy_record: :chart,       # Aponta para ChartPolicy
      policy_action: :index?,      # Testa o método index?
      path: -> { Rails.application.routes.url_helpers.respond_to?(:charts_path) ? Rails.application.routes.url_helpers.charts_path : "#" }
    },
    {
      title: "Administração",
      section: "Gestão do Sistema",
      icon: "cog-6-tooth",
      policy_record: :dashboard,
      policy_action: :admin_panel?, 
      sub_items: [
        {
          title: "Usuários",
          path: -> { Rails.application.routes.url_helpers.respond_to?(:admin_users_path) ? Rails.application.routes.url_helpers.admin_users_path : "#" },
          policy_record: :dashboard, 
          policy_action: :admin_panel? # <-- Reflete a permissão real
        },
        {
          title: "Termos de Uso",
          path: -> { Rails.application.routes.url_helpers.respond_to?(:admin_policy_terms_path) ? Rails.application.routes.url_helpers.admin_policy_terms_path : "#" },
          policy_record: :dashboard, 
          policy_action: :admin_panel?
        }
      ]
    }
  ].freeze

  def self.for(user)
    return [] unless user

    ITEMS.select { |item| allowed?(user, item[:policy_record], item[:policy_action]) }.map do |item|
      item_copy = item.dup
      if item_copy[:sub_items]
        item_copy[:sub_items] = item_copy[:sub_items].select do |sub_item|
          allowed?(user, sub_item[:policy_record], sub_item[:policy_action])
        end
      end
      item_copy
    end
  end

  # ARQUITETURA LIMPA E SEGURA: Default Deny. Se der erro, não mostra o menu!
  def self.allowed?(user, record, action)
    policy = Pundit.policy(user, record)
    policy ? policy.public_send(action) : false
  rescue StandardError => e
    Rails.logger.error "[Menu Security] Erro ao carregar policy para #{record}##{action}: #{e.message}"
    false
  end
end