class CookiePolicy < ApplicationRecord
  # ARQUITETURA LIMPA: Mensagens de erro descritivas e traduzidas
  validates :version, presence: { message: "não pode ficar em branco" }
  validates :content, presence: { message: "não pode ficar em branco" }
  
  validates :version, uniqueness: { 
    message: "já está em uso. Por favor, escolha um identificador diferente." 
  }

  scope :current, -> { where(active: true).order(created_at: :desc).first }
  before_save :deactivate_others, if: :active?

  private

  def deactivate_others
    CookiePolicy.where.not(id: id).update_all(active: false)
  end
end