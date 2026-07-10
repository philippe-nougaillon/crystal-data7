require "test_helper"

class FiltersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @filter = filters(:doliprane)
    sign_in users(:paul_hudson)
  end

  test "should get index" do
    get filters_url
    assert_response :success
  end

  test "should get new" do
    get new_filter_url
    assert_response :success
  end

  test "should create filter" do
    assert_difference("Filter.count") do
      post filters_url, params: { filter: { name: @filter.name, query: @filter.query, table_id: @filter.table_id } }
    end

    assert_redirected_to query_filter_url(id: Filter.last.slug)
  end

  test "should show filter" do
    get filter_url(id: @filter.slug)
    assert_response :success
  end

  test "should get edit" do
    get edit_filter_url(id: @filter.slug)
    assert_response :success
  end

  test "should update filter" do
    patch filter_url(id: @filter.slug), params: { filter: { name: @filter.name, query: @filter.query, table_id: @filter.table_id } }
    assert_redirected_to filter_url(id: @filter.slug)
  end

  test "should destroy filter" do
    assert_difference("Filter.count", -1) do
      delete filter_url(id: @filter.slug)
    end

    assert_redirected_to filters_url
  end
end
