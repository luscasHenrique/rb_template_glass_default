class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  # Por padrão, no nível mais seguro, NINGUÉM pode fazer NADA (Default Deny)
  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  protected

  # ==========================================
  # HIERARQUIA DE NEGÓCIO (Reuso de Código)
  # ==========================================
  
  # Master (Dono do SaaS) tem passe livre global
  def master?
    user&.master?
  end

  # C-Level e Admins do Inquilino
  def admin_or_master?
    user&.admin? || master?
  end

  # Gerência Operacional
  def manager_level?
    user&.manager? || admin_or_master?
  end

  # Departamentos Específicos
  def finance_level?
    user&.financeiro? || admin_or_master?
  end

  def auditor_level?
    user&.auditor? || admin_or_master?
  end

  # Qualquer usuário logado ativo
  def active_user?
    user.present? && user.active?
  end

  # Pundit Scopes (Filtros de Banco de Dados por Nível de Acesso)
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end
  end
end