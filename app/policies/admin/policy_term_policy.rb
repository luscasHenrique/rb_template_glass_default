module Admin
  class PolicyTermPolicy < ApplicationPolicy
    # Apenas Master ou Admin do sistema podem gerenciar os termos
    def index?
      admin_or_master?
    end

    def show?
      admin_or_master?
    end

    def create?
      admin_or_master?
    end

    def new?
      create?
    end

    def activate?
      admin_or_master?
    end
  end
end