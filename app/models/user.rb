class User < ActiveRecord::Base
  attr_accessor :list_id
  attr_accessor :remember_token
  before_save { email.downcase! }
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  has_many :lists, dependent: :destroy
  has_many :tasks, through: :lists, dependent: :destroy

  has_many :lists_user
  has_many :list, through: :lists_user

  validates :password, presence: true, length: { minimum: 2 }, allow_nil: true

  after_create :create_default_list

  scope :include_current_user_sql, ->(user, param_list) {
    sql =
        "SELECT DISTINCT u.id, u.email FROM users as u
        LEFT JOIN lists_users as lu ON lu.user_id = u.id
        WHERE u.id != #{user.id}
        AND lu.list_id != #{param_list.id}"
    records_array = ActiveRecord::Base.connection.execute(sql)
  }

  class << self
    # Returns the hash digest of the given string.
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
          BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    # Returns a random token.
    def new_token
      SecureRandom.urlsafe_base64
    end

    def shared_user(user)
      where.not(id: user.id)
    end

    def include_current_user(user, list)
      left_outer_joins(:lists_user)
          .where.not(users: { id: user.id }, lists_users: { list_id: list.id })
          .group('users.id')
    end
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

  private

  def create_default_list
    lists.create(title: :default)
  end
end