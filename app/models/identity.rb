class Identity < ApplicationRecord

  self.table_name = "identities"

  belongs_to :user
  validates_uniqueness_of :uid, scope: :provider
  validates_presence_of :uid, :provider

  before_validation :generate_token, on: :create, if: ->(identity) { identity.provider == 'email' }

  private

  def generate_token
    self.uid = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless self.class.exists?(uid: random_token)
    end
  end
end
