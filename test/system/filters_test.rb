require "application_system_test_case"

class FiltersTest < ApplicationSystemTestCase
  setup do
    login_propriétaire(@user)
    filter = create(:filter, table_id: @manufacturer_table.id, user_id: @user.id)
  end

  test "visiting the index" do
    visit filters_url
    assert_selector "h1", text: "Filtres"
  end

  test "should create filter and update filter" do
    visit filters_url
    click_on "Nouveau Filtre"

    fill_in "Nom", with: "Nouvelles interventions"
    page.select @manufacturer_table.name, from: "Collection"
    click_on "Continuer"

    fill_in "[query][#{@manufacturer_table.fields.first.id}]", with: "%%"
    click_on 'Enregistrer et appliquer le filtre'
    assert_text /Affichage de 3/
    fill_in "[query][#{@manufacturer_table.fields.first.id}]", with: @manufacturer_name_value_1.data
    click_on 'Enregistrer et appliquer le filtre'
    assert_text /Affichage de 1/
  end

  test "should destroy Filter" do
    visit filters_url
    page.accept_confirm do
      click_on "X", match: :first
    end
    assert_text "Filtre supprimé."
  end
end
