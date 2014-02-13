require "active_model/password/version"
require "active_model"

module ActiveModel
  class Password
    include Model

    attr_accessor :user, :password

    validates :user, presence: true
    validates :password, presence: true, confirmation: true

    def persisted?
      user.present? and user.persisted?
    end

    def save
      return false unless valid?
      user.password = password
      user.password_confirmation = password_confirmation
      user.save
    end
  end
end
