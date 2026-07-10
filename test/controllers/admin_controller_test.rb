require "test_helper"

class AdminControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:sébastien)
  end

  test "should get stats" do
    get admin_stats_url
    assert_response :success
  end
end
