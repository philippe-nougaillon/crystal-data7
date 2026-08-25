require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:paul_hudson)
    sign_in @user
  end

  test "should get a_propos" do
    get a_propos_url
    assert_response :success
  end

  test "should get mentions_legales" do
    get mentions_legales_url
    assert_response :success
  end

  test "should get dashboard" do
    get dashboard_url
    assert_response :success
  end

  test "should get assistant" do
    get assistant_url
    assert_response :success
  end
end
