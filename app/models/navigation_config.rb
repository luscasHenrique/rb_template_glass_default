class NavigationConfig
  ITEMS = [
    {
      title: "Dashboard",
      path: -> { Rails.application.routes.url_helpers.root_path },
      icon: "presentation-chart-bar",
      policy_record: :dashboard, 
      policy_action: :index? 
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
      policy_record: :chart,       
      policy_action: :index?,      
      path: -> { Rails.application.routes.url_helpers.respond_to?(:charts_path) ? Rails.application.routes.url_helpers.charts_path : "#" }
    },
    {
      title: "Administração",
      section: "Gestão do Sistema",
      icon: "cog-6-tooth",
      # O menu pai verifica uma permissão genérica apenas para saber se renderiza a categoria
      policy_record: :dashboard,
      policy_action: :admin_panel?, 
      sub_items: [
        {
          title: "Usuários",
          path: -> { Rails.application.routes.url_helpers.respond_to?(:admin_users_path) ? Rails.application.routes.url_helpers.admin_users_path : "#" },
          # AQUI: Consultando estritamente a Admin::UserPolicy
          policy_record: [:admin, :user], 
          policy_action: :index? 
        },
        {
          title: "Termos de Uso",
          path: -> { Rails.application.routes.url_helpers.respond_to?(:admin_policy_terms_path) ? Rails.application.routes.url_helpers.admin_policy_terms_path : "#" },
          # AQUI: Consultando estritamente a Admin::PolicyTermPolicy
          policy_record: [:admin, :policy_term], 
          policy_action: :index?
        },
        {
          title: "Cookies (LGPD)",
          path: -> { Rails.application.routes.url_helpers.respond_to?(:admin_cookie_policies_path) ? Rails.application.routes.url_helpers.admin_cookie_policies_path : "#" },
          # AQUI: Consultando estritamente a Admin::CookiePolicyPolicy
          policy_record: [:admin, :cookie_policy], 
          policy_action: :index?
        },
        {
          title: "Auditoria Global",
          icon: "clipboard-document-list",
          path: -> { Rails.application.routes.url_helpers.respond_to?(:admin_audits_path) ? Rails.application.routes.url_helpers.admin_audits_path : "#" },
          # AQUI: Consultando estritamente a Admin::AuditPolicy
          policy_record: [:admin, :audit], 
          policy_action: :index?
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

  def self.allowed?(user, record, action)
    policy = Pundit.policy(user, record)
    policy ? policy.public_send(action) : false
  rescue StandardError => e
    Rails.logger.error "[Menu Security] Erro ao carregar policy para #{record}##{action}: #{e.message}"
    false
  end
end