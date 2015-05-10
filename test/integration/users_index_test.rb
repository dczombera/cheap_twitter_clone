require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @admin = users(:bruce)
    @non_admin = users(:joker)
  end

  test "index including pagination and delete links" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    User.paginate(page: 1).each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: 'delete',
                                                    method: :delete
      end
    end
  end

  test "index as non-admin" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end

  test "index only showing activated user" do
    @non_admin.toggle!(:activated)
    log_in_as(@admin)
    get users_path
    assert_select "a[href=?]", user_path(@non_admin), count: 0
  end

  test "show for non-activated user" do
    @non_admin.toggle!(:activated)
    log_in_as(@admin)
    get user_path(@non_admin)
    assert_redirected_to root_url
  end

  test "show for activated user" do
    log_in_as(@admin)
    get user_path(@non_admin)
    assert_template 'users/show'
    assert_select "title", full_title(@non_admin.name)
  end
end
