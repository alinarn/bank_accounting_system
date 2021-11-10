class Account < ApplicationRecord
  belongs_to :user
  validates_presence_of :currency, :user_id
  validates :currency, length: { is: 3 }
  validates_uniqueness_of :currency, scope: :user_id

  class << self
    def deposit(account, deposit_amount)
      return false unless amount_valid?(deposit_amount)
      account.balance += deposit_amount
      account.save!
    end

    def transfer(account, recipient_account, transfer_amount)
      return false if account.balance.nil?
      withdraw(account, transfer_amount)
      deposit(recipient_account, transfer_amount)
    end

    private

    def amount_valid?(amount)
      amount >= 0.01
    end

    def withdraw(account, amount)
      return false unless amount_valid?(amount)
      account.balance -= amount
      account.save!
    end
  end
end
