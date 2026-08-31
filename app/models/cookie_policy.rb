
class CookiePolicy < ApplicationRecord
  validates :version, :content, presence: true
  validates :version, uniqueness: true

  # Escopo rápido para buscar a versão em vigor
  scope :current, -> { where(active: true).order(created_at: :desc).first }

  # Regra de Negócio: Garante que apenas uma política fique ativa por vez
  before_save :deactivate_others, if: :active?

  private

  def deactivate_others
    CookiePolicy.where.not(id: id).update_all(active: false)
  end
end