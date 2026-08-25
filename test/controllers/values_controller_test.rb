require "test_helper"

class ValuesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:paul_hudson)
    sign_in @user
  end

  test "should instantiate values controller" do
    assert_not_nil ValuesController.new
  end
end
