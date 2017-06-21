require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @admin = users(:michael)
    @non_admin = users(:rock)
  end

  test "index with pagination and delete link for admin" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    users_in_first_page = User.paginate(page: 1)
    users_in_first_page.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      assert_select 'a[href=?]', user_path(user), text: 'delete' unless user == @admin
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end


  end

  test "index when logged in as non-admin" do
    log_in_as(@non_admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    assert_select 'a', text: 'delete', count: 0
  end




end

