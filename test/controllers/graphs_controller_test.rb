require "test_helper"

class GraphsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @graph = graphs(:one)
    sign_in users(:paul_hudson)
  end

  test "should get index" do
    get graphs_url
    assert_response :success
  end

  test "should get new" do
    get new_graph_url
    assert_response :success
  end

  test "should create graph" do
    assert_difference("Graph.count") do
      post graphs_url, params: { graph: { field_id: @graph.field_id, filter_id: @graph.filter_id, poids: @graph.poids, sort: @graph.sort, chart_type: @graph.chart_type } }
    end

    assert_redirected_to graph_url(id: Graph.last.slug)
  end

  test "should show graph" do
    get graph_url(id: @graph.slug)
    assert_response :success
  end

  test "should get edit" do
    get edit_graph_url(id: @graph.slug)
    assert_response :success
  end

  test "should update graph" do
    patch graph_url(id: @graph.slug), params: { graph: { field_id: @graph.field_id, filter_id: @graph.filter_id, poids: @graph.poids, sort: @graph.sort, chart_type: @graph.chart_type } }
    assert_redirected_to graph_url(id: @graph.slug)
  end

  test "should destroy graph" do
    assert_difference("Graph.count", -1) do
      delete graph_url(id: @graph.slug)
    end

    assert_redirected_to graphs_url
  end
end
