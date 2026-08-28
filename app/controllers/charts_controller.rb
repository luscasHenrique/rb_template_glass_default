class ChartsController < ApplicationController
  def index
    # O Pundit vai procurar o ChartPolicy e o método index?
    authorize :chart
    
    # Aqui iriam as lógicas de buscar dados no banco no futuro
    @title = "Gráficos de Desempenho"
  end
end