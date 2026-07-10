require "test_helper"

class NotificationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @notification = notifications(:one)
    sign_in users(:paul_hudson)
  end

  test "should get index" do
    get notifications_url
    assert_response :success
  end

  test "should get new" do
    get new_notification_url
    assert_response :success
  end

  test "should create notification" do
    assert_difference("Notification.count") do
      post notifications_url, params: { notification: { field_id: @notification.field_id, send_to: @notification.send_to, table_id: @notification.table_id, value: @notification.value } }
    end

    assert_redirected_to notifications_url
  end

  test "should get edit" do
    get edit_notification_url(id: @notification.slug)
    assert_response :success
  end

  test "should update notification" do
    patch notification_url(id: @notification.slug), params: { notification: { field_id: @notification.field_id, send_to: @notification.send_to, table_id: @notification.table_id, value: @notification.value } }
    assert_redirected_to notifications_url
  end

  test "should destroy notification" do
    assert_difference("Notification.count", -1) do
      delete notification_url(id: @notification.slug)
    end

    assert_redirected_to notifications_url
  end
end
