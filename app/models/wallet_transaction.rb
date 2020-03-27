class WalletTransaction < ApplicationRecord
  audited

  belongs_to :user
  belongs_to :charge_session, optional: true

  enum transaction_type: [:debit, :credit]

  before_create :set_identifier

  private

  def set_identifier
    self.identifier = generate_identifier
  end

  def generate_identifier
    loop do
      identifier = 8.times.map{rand(10)}.join
      break identifier unless self.class.where(identifier: identifier).exists?
    end
  end
end