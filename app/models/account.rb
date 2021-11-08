class Account < ApplicationRecord
  belongs_to :user
  validates_presence_of :currency, :user_id
  validates :currency, length: { is: 3 }
  validates_uniqueness_of :currency, scope: :user_id

  def self.deposit(account, deposit_amount)
    return false unless amount_valid?(deposit_amount)
    account.amount += deposit_amount
    account.save!
  end

  private

  def self.amount_valid?(amount)
    amount >= 0.01
  end
end
