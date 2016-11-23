class Task < ApplicationRecord
  belongs_to :list
  validates :title, presence: true,
                    length: { minimum: 3 },
                    uniqueness: true

  scope :filtered, ->(type) { send(type) if type }
  scope :done, -> { where(done: true) }
  scope :open, -> { where(done: false) }
end
