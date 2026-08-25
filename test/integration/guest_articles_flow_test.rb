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

    # 5. Check if all the new data are shown
    assert_includes response.body, fake_titre
    assert_includes response.body, CGI.escapeHTML(fake_desc)
  end

  test "guest user demo mode user flow for editing an Article" do
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
    assert_includes response.body, "Premier Article"

    # 3. Select an article (view details of record 1)
    get details_table_url(id: @table.slug, record_index: 1)
    assert_response :success
    assert_includes response.body, "Premier Article"
    assert_includes response.body, "Description du premier article"

    # 4. Edit it (open edit form for record 1)
    get fill_table_url(id: @table.slug, record_index: 1)
    assert_response :success

    # Fill fields with different fake data
    updated_titre = "Premier Article Modifié #{SecureRandom.hex(4)}"
    updated_desc = "Nouvelle description modifiée pour l'article exemple"

    post fill_do_table_url(id: @table.slug), params: {
      table_id: @table.id,
      data: {
        "1" => {
          @field_titre.id.to_s => updated_titre,
          @field_desc.id.to_s => updated_desc
        }
      },
      commit: "Enregistrer"
    }

    # 5. Save and check if data are correct
    assert_response :redirect
    follow_redirect!
    assert_response :success

    assert_includes response.body, updated_titre
    assert_includes response.body, CGI.escapeHTML(updated_desc)
  end

  test "guest user demo mode user flow for adding and filling a new text attribute" do
    # 1. Log in as guest (demo mode)
    get user_connect_guest_user_url(user_id: 1)
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_equal tables_path, path

    # 2. Open 'Articles' table
    @table = tables(:articles)

    get table_url(id: @table.slug)
    assert_response :success

    # 3. Open attributes list
    get show_attrs_table_url(id: @table.slug)
    assert_response :success

    # 4. Add a new TEXT attribute and save
    attribute_name = "Code Référence #{SecureRandom.hex(4)}"

    post fields_url, params: {
      field: {
        table_id: @table.id,
        datatype: "Texte",
        name: attribute_name
      }
    }

    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_includes response.body, attribute_name

    new_field = @table.fields.find_by!(name: attribute_name)

    # 5. Fill this new field with fake data, save and check if data saved are correct
    get fill_table_url(id: @table.slug, record_index: 1)
    assert_response :success

    fake_text_data = "REF-#{SecureRandom.hex(3)}"
    field_titre = fields(:article_titre)
    field_desc = fields(:article_description)

    post fill_do_table_url(id: @table.slug), params: {
      table_id: @table.id,
      data: {
        "1" => {
          field_titre.id.to_s => "Premier Article",
          field_desc.id.to_s => "Description du premier article",
          new_field.id.to_s => fake_text_data
        }
      },
      commit: "Enregistrer"
    }

    assert_response :redirect
    follow_redirect!
    assert_response :success

    assert_includes response.body, fake_text_data
  end
end
