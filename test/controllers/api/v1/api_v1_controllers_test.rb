require "test_helper"

class ApiV1ControllersTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:paul_hudson)
    @table = tables(:produits)
    @field = fields(:produit_nom)
  end

  test "should get api v1 users index" do
    get api_v1_users_url
    assert_response :success
    json = JSON.parse(response.body)
    assert_kind_of Array, json
  end

  test "should get api v1 timestamps" do
    get api_v1_timestamps_url
    assert_response :success

    get api_v1_timestamps_url(user_id: @user.id)
    assert_response :success
  end

  test "should get api v1 tables index" do
    get api_v1_tables_url(user_id: @user.id)
    assert_response :success
  end

  test "should get api v1 fields index" do
    get api_v1_fields_url(slug: @table.slug)
    assert_response :success
  end

  test "should get api v1 values index" do
    get api_v1_values_url(slug: @table.slug)
    assert_response :success
  end

  test "should post api v1 value" do
    post api_v1_values_post_value_url, params: {
      value: {
        user_id: @user.id,
        field_id: @field.id,
        data: "Doliprane 500"
      }
    }
    assert_response :created
  end
end
