require "test_helper"

class GuestArticlesFlowTest < ActionDispatch::IntegrationTest
  test "guest user demo mode user flow for Articles table" do
    # 1. Log in as guest (demo mode)
    get user_connect_guest_user_url(user_id: 1)
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_equal tables_path, path

    # 2. Open 'Articles' table
    @table = tables(:articles)
    @field_titre = fields(:article_titre)
    @field_desc = fields(:article_description)

    get table_url(id: @table.slug)
    assert_response :success

    # 3. Check if the table shows 2 lines at least
    assert_operator @table.size, :>=, 2
    assert_includes response.body, "Premier Article"
    assert_includes response.body, "Second Article"

    # 4. Open form to add an article
    get fill_table_url(id: @table.slug)
    assert_response :success

    # Fill it with fake data and save it
    fake_titre = "Nouvel Article Fake #{SecureRandom.hex(4)}"
    fake_desc = "Description du nouvel article créé par le test d'intégration"

    post fill_do_table_url(id: @table.slug), params: {
      table_id: @table.id,
      data: {
        "-1" => {
          @field_titre.id.to_s => fake_titre,
          @field_desc.id.to_s => fake_desc
        }
      },
      commit: "Enregistrer"
    }

    assert_response :redirect
    follow_redirect!
    assert_response :success
    puts "DEBUG REDIRECT PATH: #{path}"
    puts "DEBUG FLASH NOTICE: #{flash[:notice]}"
    puts "DEBUG FLASH ALERT: #{flash[:alert]}"

    # 5. Check if all the new data are shown
    assert_includes response.body, fake_titre
    assert_includes response.body, fake_desc
  end
end
