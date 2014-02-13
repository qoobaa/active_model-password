require "test_helper"

class User
  include ActiveModel::Model

  attr_accessor :password, :password_confirmation, :persisted
  validates :password, format: {with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)./}, length: {in: 8..255}, if: -> { password.present? }

  def save
    valid?
  end

  def persisted?
    !!persisted
  end
end

class PasswordTest < Test::Unit::TestCase
  include ActiveModel::Lint::Tests

  setup do
    @user = User.new
    @model = @password = ActiveModel::Password.new(user: @user, password: "Password123", password_confirmation: "Password123")
  end

  test "is valid with valid attributes" do
    assert @password.valid?
  end

  test "is invalid when user is nil" do
    @password.user = nil
    assert @password.invalid?
    assert @password.errors[:user].present?
  end

  test "is invalid without password" do
    @password.password = ""
    assert @password.invalid?
    assert @password.errors[:password].present?
  end

  test "is invalid with too short password" do
    @password.password = "Secret1"
    assert @password.invalid?
    assert @password.errors[:password].present?
  end

  test "is invalid with password without uppercase letter" do
    @password.password = "secretsecret1"
    assert @password.invalid?
    assert @password.errors[:password].present?
  end

  test "is invalid with password without lowercase letter" do
    @password.password = "SECRETSECRET1"
    assert @password.invalid?
    assert @password.errors[:password].present?
  end

  test "is invalid with password without number" do
    @password.password = "SecretSecret"
    assert @password.invalid?
    assert @password.errors[:password].present?
  end

  test "is invalid without password confirmation" do
    @password.password_confirmation = ""
    assert @password.invalid?
    assert @password.errors[:password_confirmation].present?
  end

  test "is invalid with non-matching password confirmation" do
    @password.password_confirmation = "terces"
    assert @password.invalid?
    assert @password.errors[:password_confirmation].present?
  end

  test "save returns false if invalid" do
    @password.user = nil
    assert_equal false, @password.save
  end

  test "save returns true, sets new password" do
    assert @password.save
    assert @user.password = "Password123"
    assert @user.password_confirmation = "Password123"
  end

  test "persisted returns true if user present and user persisted" do
    @user.persisted = true
    assert @password.persisted?
  end

  test "persisted returns false if no user present" do
    @password.user = nil
    refute @password.persisted?
  end

  test "persisted returns false if user present and user not persisted" do
    refute @password.persisted?
  end
end
