class Account < ApplicationRecord
  belongs_to :user
  validates_presence_of :currency, :user_id
  validates :currency, length: { is: 3 }
  validates_uniqueness_of :currency, scope: :user_id
end
