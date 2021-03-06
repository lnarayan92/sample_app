require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = User.new(name: "abcdef", email: "abcd@gmail.com", password: "mikejack", password_confirmation: "mikejack")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = " "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.name = "     "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a"*51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a"*244 + "@example.com"
    assert_not @user.valid?
  end

  test "should accept valid email" do
    valid_addresses = %w[user@example.com user_92@abc.com user@com.org.in]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "should reject invalid email" do
    invalid_addresses = %w[user@examplecom user_92abc.com user#com.org.in]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email address should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "password should be present" do
    @user.password = " "*3
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = "a"*5
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil remember_digest" do
    assert_not @user.authenticated?(:remember,' ')
  end

  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "This is some random content")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end

end
