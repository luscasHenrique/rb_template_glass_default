class PolicyTerm < ApplicationRecord
  has_paper_trail # Auditoria de quem criou ou ativou o termo
  
  has_many :user_agreements, dependent: :restrict_with_error
  has_many :users, through: :user_agreements

  validates :document_version, :content, presence: true
  validates :document_version, uniqueness: true

  # Travas de Governança
  before_update :prevent_edit_if_active
  before_save :deactivate_others_if_active
  before_destroy :prevent_destroy_if_active

  private

  # 1. IMUTABILIDADE: Se o termo já era ativo, ele não pode ser alterado 
  # (exceto se a alteração for justamente desativá-lo)
  def prevent_edit_if_active
    if active_was && changed? && !active_changed?(from: true, to: false)
      errors.add(:base, "Governança: Termos ativos não podem ser alterados. Crie uma nova versão.")
      throw(:abort)
    end
  end

  # 2. SINGLE SOURCE OF TRUTH: Se este termo está sendo ativado, 
  # derruba qualquer outro que estivesse ativo no sistema.
  def deactivate_others_if_active
    if active? && active_changed?
      PolicyTerm.where.not(id: id).update_all(active: false)
    end
  end
# 3. GOVERNANÇA: Termos ativos não podem ser excluídos, apenas desativados.
  def prevent_destroy_if_active
    if active?
      errors.add(:base, "Termos em vigor não podem ser excluídos, apenas desativados por uma nova versão.")
      throw(:abort)
    end
  end
end