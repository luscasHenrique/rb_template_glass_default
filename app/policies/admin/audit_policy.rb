module Admin
  class AuditPolicy < ApplicationPolicy
    def index?
      admin_or_master? # Trava padrão herdada da sua ApplicationPolicy
    end

    def show?
      admin_or_master?
    end
  end
end