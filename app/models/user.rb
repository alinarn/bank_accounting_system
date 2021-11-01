class User < ApplicationRecord
  validates_presence_of :id, :full_name
  validates :id, uniqueness: :true
  has_many :tags
  accepts_nested_attributes_for :tags
end
