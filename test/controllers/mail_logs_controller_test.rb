require "test_helper"

# Avoid making actual Mailgun API requests during test execution
class Mailgun::Client
  def get(*args)
    { "items" => [] }
  end
end

class MailLogsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @mail_log = mail_logs(:one)
    sign_in users(:paul_hudson)
  end

  test "should get index" do
    get mail_logs_url
    assert_response :success
  end

  test "should show mail_log" do
    get mail_log_url(id: @mail_log.id)
    assert_response :success
  end
end
