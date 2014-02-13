require "active_model/password/version"
require "active_model"

module ActiveModel
  class Password
    include Model

    attr_accessor :user, :password

    validates :user, presence: true
    validates :password, presence: true, confirmation: true
    validate :user_password, if: :user?

    def user?
      user.present?
    end

    def persisted?
      user? and user.persisted?
    end

    def save
      return false unless valid?
      user.password = password
      user.password_confirmation = password_confirmation
      user.save
    end

    private

    def user_password
      old_password = user.password
      user.password = password
      if user.invalid? and user.errors[:password].present?
        user.errors[:password].each { |error| errors.add(:password, error) }
      end
    ensure
      user.password = old_password
    end
  end
end
