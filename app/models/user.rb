class User < ApplicationRecord
  has_paper_trail

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :profile, dependent: :destroy
  has_many :user_agreements, dependent: :destroy

  enum :role, { user: 0, admin: 1, manager: 2, auditor: 3, financeiro: 4, master: 5 }, default: :user
  
  accepts_nested_attributes_for :profile, update_only: true

  before_create :set_default_active_status
  after_create :build_associations

  def active_for_authentication?
    super && self.active != false
  end

  def inactive_message
    self.active != false ? super : :account_inactive
  end

  def accepted_current_term?
    current_term = PolicyTerm.find_by(active: true)
    return true unless current_term 
    user_agreements.exists?(policy_term_id: current_term.id)
  end

  private

  def set_default_active_status
    self.active = false if self.active.nil?
  end

  def build_associations
    if self.profile.present?
      self.profile.create_address unless self.profile.address.present?
    else
      p = self.create_profile(first_name: "Usuário", last_name: "Novo")
      p.create_address
    end
  end
end