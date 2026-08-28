class HomeController < ApplicationController
  def index
    # Como a Home não é um dado do banco (como um User ou Invoice), 
    # passamos um símbolo :dashboard para o Pundit achar o DashboardPolicy
    authorize :dashboard, :index?
    
    # Exemplo de variável que você pode renderizar para testar seus componentes
    @recent_activities = [] 
  end
end