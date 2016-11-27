class List < ApplicationRecord
  belongs_to :user
  has_many :tasks, dependent: :delete_all

  has_many :lists_user
  has_many :users, through: :lists_user
end
