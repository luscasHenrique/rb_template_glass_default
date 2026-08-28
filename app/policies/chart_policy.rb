class ChartPolicy < ApplicationPolicy
  def index?
    # Vamos dizer que apenas Gerentes, Admins e Masters podem ver gráficos
    manager_level? 
  end
end