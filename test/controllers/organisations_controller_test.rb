require "test_helper"

class OrganisationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @organisation = organisations(:sanofi)
    sign_in users(:paul_hudson)
  end

  test "should show organisation" do
    get organisation_url(id: @organisation.slug)
    assert_response :success
  end

  test "should get edit" do
    get edit_organisation_url(id: @organisation.slug)
    assert_response :success
  end

  test "should update organisation" do
    patch organisation_url(id: @organisation.slug), params: { organisation: { nom: @organisation.nom } }
    assert_redirected_to organisation_url(id: @organisation.slug)
  end
end
