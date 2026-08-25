require "test_helper"

class FieldsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:paul_hudson)
    @table = tables(:produits)
    @field = fields(:produit_nom)
    sign_in @user
  end

  test "should get edit" do
    get edit_field_url(id: @field.slug)
    assert_response :success
  end

  test "should create field" do
    assert_difference("Field.count") do
      post fields_url, params: {
        field: {
          name: "Prix",
          table_id: @table.id,
          datatype: "Nombre",
          description: "Prix unitaire"
        }
      }
    end
    assert_redirected_to show_attrs_table_url(id: @table.slug)
  end

  test "should update field" do
    patch field_url(id: @field.slug), params: {
      field: {
        name: "Nom du produit"
      }
    }
    assert_redirected_to show_attrs_table_url(id: @table.slug)
    @field.reload
    assert_equal "Nom du produit", @field.name
  end

  test "should destroy field" do
    assert_difference("Field.count", -1) do
      delete field_url(id: @field.slug)
    end
    assert_redirected_to show_attrs_table_url(id: @table.slug)
  end

  test "should update row order" do
    post update_row_order_fields_url, params: {
      field: {
        field_id: @field.id,
        row_order_position: 2
      }
    }
    assert_response :success
  end
end
