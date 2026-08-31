class CookieConsent < ApplicationRecord
  has_paper_trail
  # Opcional pois rastreamos tanto usuários autenticados quanto leads anônimos
  belongs_to :user, optional: true

  validates :session_hash, :ip_address, presence: true
  validates :necessary_accepted, inclusion: { in: [true], message: "Cookies necessários são obrigatórios" }
  
  # Garante que teremos apenas um registro válido por sessão/usuário no banco
  validates :session_hash, uniqueness: { scope: :user_id }

  # Escopos úteis para futuros dashboards de marketing
  scope :with_analytics, -> { where(analytics_accepted: true) }
  scope :with_marketing, -> { where(marketing_accepted: true) }
end