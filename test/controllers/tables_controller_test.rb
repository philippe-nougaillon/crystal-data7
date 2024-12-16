require "test_helper"

class TablesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @table_produit = tables(:produits)
    @table_étude = tables(:études)
    sign_in @admin # Assure-toi d'avoir Devise ou une méthode pour simuler la connexion
  end

  test "should get index" do
    get tables_url
    assert_response :success
  end

  test "should create table" do
    assert_difference("Table.count") do
      post tables_url, params: { table: { name: "Interventions" } }
    end

    assert_redirected_to show_attrs_path(id: Table.last.slug)
    follow_redirect!
    assert_match "Objet créé", response.body
  end

  test "should update table" do
    patch table_url(id: @table_produit.slug), params: { table: { name: "Nouveau nom" } }
    assert_redirected_to table_path(id: @table_produit.slug)
    follow_redirect!
    assert_match "Objet modifié.", response.body
    assert_equal "Nouveau nom", @table_produit.reload.name
  end

  test "should destroy table" do
    table = @table_produit
    assert_difference("Table.count", -1) do
      delete table_url(id: table.slug)
    end

    assert_redirected_to tables_url
    follow_redirect!
    assert_match "Objet supprimé", response.body
  end

  test "should search for a value in a table" do
    get table_url(id: @table_étude.slug), params: { search: @table_étude.values.first.data }
    assert_response :success
    assert_match /Affichage de 1/, response.body
  end

  test "should show table" do
    get table_url(id: @table_étude.slug)
    assert_response :success
    assert_select "a", @table_étude.name_pluralized
  end

  # test "should add field to table" do
  #   assert_difference("Field.count") do
  #     post table_fields_url(@table_étude), params: { field: { name: "Désignation", datatype: "string" } }
  #   end

  #   assert_redirected_to table_path(@table_étude)
  #   follow_redirect!
  #   assert_match "Nouvel attribut ajouté", response.body
  # end

  # test "should update field" do
  #   field = @table_étude.fields.first
  #   patch table_field_url(@table_étude, field), params: { field: { name: "Description" } }
  #   assert_redirected_to table_path(@table_étude)
  #   follow_redirect!
  #   assert_match "Attribut modifié avec succès", response.body
  #   assert_equal "Description", field.reload.name
  # end

  # test "should destroy field" do
  #   field = @table_étude.fields.first
  #   assert_difference("Field.count", -1) do
  #     delete table_field_url(@table_étude, field)
  #   end

  #   assert_redirected_to table_path(@table_étude)
  #   follow_redirect!
  #   assert_match "Attribut supprimé", response.body
  # end

  # test "should create a value in table" do
  #   field = @table_étude.fields.where(datatype: "Texte").first
  #   assert_difference("Value.count") do
  #     post table_values_url(@table_étude), params: { value: { data: "Nouvelle valeur", field_id: field.id, record_index: 1 } }
  #   end

  #   assert_redirected_to table_path(@table_étude)
  #   follow_redirect!
  #   assert_match "Données ajoutées avec succès", response.body
  # end

  # test "should update value in table" do
  #   value = @table_étude.values.first
  #   patch table_value_url(@table_étude, value), params: { value: { data: "Valeur mise à jour" } }
  #   assert_redirected_to table_path(@table_étude)
  #   follow_redirect!
  #   assert_match "Données modifiées avec succès", response.body
  #   assert_equal "Valeur mise à jour", value.reload.data
  # end

  # test "should destroy value in table" do
  #   value = @table_étude.values.first
  #   assert_difference("Value.count", -1) do
  #     delete table_value_url(@table_étude, value)
  #   end

  #   assert_redirected_to table_path(@table_étude)
  #   follow_redirect!
  #   assert_match "Données supprimées avec succès", response.body
  # end
end