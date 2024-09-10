require "application_system_test_case"

class MailLogsTest < ApplicationSystemTestCase
  setup do
    @mail_log = mail_logs(:one)
  end

  test "visiting the index" do
    visit mail_logs_url
    assert_selector "h1", text: "Mail logs"
  end

  test "should create mail log" do
    visit mail_logs_url
    click_on "New mail log"

    fill_in "Message", with: @mail_log.message_id
    fill_in "Subject", with: @mail_log.subject
    fill_in "To", with: @mail_log.to
    fill_in "User", with: @mail_log.user_id
    click_on "Create Mail log"

    assert_text "Mail log was successfully created"
    click_on "Back"
  end

  test "should update Mail log" do
    visit mail_log_url(@mail_log)
    click_on "Edit this mail log", match: :first

    fill_in "Message", with: @mail_log.message_id
    fill_in "Subject", with: @mail_log.subject
    fill_in "To", with: @mail_log.to
    fill_in "User", with: @mail_log.user_id
    click_on "Update Mail log"

    assert_text "Mail log was successfully updated"
    click_on "Back"
  end

  test "should destroy Mail log" do
    visit mail_log_url(@mail_log)
    click_on "Destroy this mail log", match: :first

    assert_text "Mail log was successfully destroyed"
  end
end
