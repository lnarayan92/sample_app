require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: {name: "",
                                        email: "invalid.com",
                                        password: "123",
                                        password_confirmation: "1234"}}
    end
    assert_template 'users/new'
  end

  test "valid signup information" do
    get signup_path
    assert_difference 'User.count' do
      post users_path, params: { user: {name: "jacky lee", email: "lee@gmail.com", password: "Test1234", password_confirmation: "Test1234"}}
    end
    follow_redirect!
    assert_template 'users/show'
  end

end
