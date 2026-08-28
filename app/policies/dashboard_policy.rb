class DashboardPolicy < ApplicationPolicy
  def index?
    active_user?
  end
  
  def finance_panel?
    finance_level?
  end
  
  def saas_admin_panel?
    admin_or_master?
  end

  # AQUI ESTÁ A CORREÇÃO: Declaramos a regra que o Menu está pedindo
  def admin_panel?
    admin_or_master?
  end
end