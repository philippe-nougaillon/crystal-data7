require "application_system_test_case"

class GraphsTest < ApplicationSystemTestCase
  setup do
    @graph = graphs(:one)
  end

  test "visiting the index" do
    visit graphs_url
    assert_selector "h1", text: "Graphs"
  end

  test "should create graph" do
    visit graphs_url
    click_on "New graph"

    fill_in "Field", with: @graph.field_id
    fill_in "Filter", with: @graph.filter_id
    check "Order" if @graph.order
    fill_in "Organisation", with: @graph.organisation_id
    check "Sort" if @graph.sort
    fill_in "Type", with: @graph.type
    click_on "Create Graph"

    assert_text "Graph was successfully created"
    click_on "Back"
  end

  test "should update Graph" do
    visit graph_url(@graph)
    click_on "Edit this graph", match: :first

    fill_in "Field", with: @graph.field_id
    fill_in "Filter", with: @graph.filter_id
    check "Order" if @graph.order
    fill_in "Organisation", with: @graph.organisation_id
    check "Sort" if @graph.sort
    fill_in "Type", with: @graph.type
    click_on "Update Graph"

    assert_text "Graph was successfully updated"
    click_on "Back"
  end

  test "should destroy Graph" do
    visit graph_url(@graph)
    click_on "Destroy this graph", match: :first

    assert_text "Graph was successfully destroyed"
  end
end
