module Admin
  class UserPolicy < ApplicationPolicy
    def index?
      manager_level?
    end

    def show?
      index?
    end

    def create?
      manager_level?
    end

    def new?
      create?
    end

    def edit?
      update?
    end

    def update?
      manager_level?
    end

    def destroy?
      admin_or_master?
    end

    def confirm_destroy?
      destroy?
    end
  end
end