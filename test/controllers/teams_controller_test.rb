require "test_helper"

class TeamsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:paul_hudson)
    @team = teams(:doliprane)
    sign_in @user
  end

  test "should get new" do
    get new_team_url
    assert_response :success
  end

  test "should create team" do
    assert_difference("Team.count") do
      post teams_url, params: {
        team: {
          name: "Équipe Recherche & Développement"
        }
      }
    end
    assert_redirected_to users_url
  end

  test "should get edit" do
    get edit_team_url(id: @team.slug)
    assert_response :success
  end

  test "should update team" do
    patch team_url(id: @team.slug), params: {
      team: {
        name: "Doliprane 1000mg"
      }
    }
    assert_redirected_to users_url
    @team.reload
    assert_equal "Doliprane 1000mg", @team.name
  end

  test "should destroy team" do
    assert_difference("Team.count", -1) do
      delete team_url(id: @team.slug)
    end
    assert_redirected_to users_url
  end
end
