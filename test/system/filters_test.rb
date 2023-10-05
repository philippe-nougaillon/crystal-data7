require "application_system_test_case"

class FiltersTest < ApplicationSystemTestCase
  setup do
    login_propriétaire
  end

  test "visiting the index" do
    visit filters_url
    assert_selector "h1", text: "Filtres"
  end

  # test "should create filter" do
  #   visit filters_url
  #   click_on "Nouveau Filtre"

  #   fill_in "Nom", with: "Nouvelles interventions"
  #   page.select "Intervention", from: "Collection"
  #   click_on "Continuer"

  #   assert_text "Filtre créé."
  # end

  # test "should update Filter" do
  #   visit filter_url(@filter)
  #   click_on "Edit this filter", match: :first

  #   fill_in "Name", with: @filter.name
  #   fill_in "Query", with: @filter.query
  #   fill_in "Table", with: @filter.table_id
  #   click_on "Update Filter"

  #   assert_text "Filter was successfully updated"
  #   click_on "Back"
  # end

  # test "should destroy Filter" do
  #   visit filter_url(@filter)
  #   click_on "Destroy this filter", match: :first

  #   assert_text "Filter was successfully destroyed"
  # end
end
