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

    def edit?
      admin_or_master?
    end

    def update?
      admin_or_master?
    end

    def activate?
      admin_or_master?
    end

    def destroy?
      admin_or_master?
    end

    def confirm_destroy?
      destroy?
    end
  end
end