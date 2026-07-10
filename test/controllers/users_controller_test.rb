require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:sébastien)
    sign_in users(:paul_hudson)
  end

  test "should get index" do
    get users_url
    assert_response :success
  end

  test "should get edit" do
    get edit_user_url(id: @user.slug)
    assert_response :success
  end

  test "should update user" do
    patch user_url(id: @user.slug), params: { user: { name: "New Name" } }
    assert_redirected_to users_url
  end

  test "should destroy user" do
    assert_difference("User.count", -1) do
      delete user_url(id: @user.slug)
    end

    assert_redirected_to root_path
  end
end
