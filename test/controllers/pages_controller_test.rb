require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get à_propos" do
    get a_propos_url
    assert_response :success
  end
end
