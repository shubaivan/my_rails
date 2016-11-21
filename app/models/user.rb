class User < ApplicationRecord
  EMAIL_REGEX = /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/

  has_secure_password
  has_many :lists, dependent: :destroy
  has_many :tasks, through: :lists, dependent: :destroy

  validates :name, presence: true, length: { minimum: 3 }
  validates :email, presence: true, format: EMAIL_REGEX, uniqueness: true
  validates :password, length: { minimum: 8 }, on: :create

  after_create :create_default_list

  private

  def create_default_list
    lists.create(title: :default)
  end
end
