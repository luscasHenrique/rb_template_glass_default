class Profile < ApplicationRecord
  has_paper_trail
  belongs_to :user
  has_one :address, as: :addressable, dependent: :destroy
  
  accepts_nested_attributes_for :address, allow_destroy: true

  validates :phone, length: { minimum: 10, maximum: 11 }, allow_blank: true
  validates :first_name, :last_name, presence: true
  
  before_validation :sanitize_phone_number

  private

  def sanitize_phone_number
    self.phone = phone.to_s.gsub(/\D/, '') if phone.present?
  end
end