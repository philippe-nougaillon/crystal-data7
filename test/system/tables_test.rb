require "application_system_test_case"

class TablesTest < ApplicationSystemTestCase

  setup do
    login_user
  end
  
  test "visiting the index" do
    visit tables_url
    assert_selector "h1", text: "Tables"
  end
  
  test "creating a Table" do
    visit tables_url
    click_on "Nouvelle Table"

    fill_in "Nom de la table", with: "Interventions"
    click_button "Continuer"
    assert_text "Table créée. Vous pouvez maintenant y ajouter des colonnes"

    # Ajout de fields
    fill_in "Nom", with: "Titre"
    check "Obligatoire ?"
    click_button "Ajouter cette nouvelle colonne"
    assert_text "Nouvelle colonne ajoutée."
    # TODO: checker si le type du field est un string
    # TODO: checker si le field est obligatoire

    sleep(1) # Pour éviter que ça aille trop vite et que ça plante
    fill_in "Nom", with: "Prix"
    page.select "Nombre", from: "Type de données"
    click_button "Ajouter cette nouvelle colonne"
    assert_text "Nouvelle colonne ajoutée."
  end

  test "updating a Table" do
    visit tables_url
    click_on "Modifier", match: :first
    click_on "Modifier", match: :first

    fill_in "Nom", with: "Type"
    click_button "Modifier"

    assert_text "Colonne modifiée."
  end

  test "destroying a Table" do
    visit tables_url
    page.accept_confirm do
      click_on "X", match: :first
    end

    assert_text "Table supprimée."
  end

  test 'chercher une valeur dans une table' do
    @table = tables(:stocks)

    visit tables_url
    click_on @table.name
    assert_selector 'h1', text: 'Stocks'
    fill_in 'Rechercher', with: 'RJ45'
    send_keys(:return)
    assert_selector 'p', text: 'Affichage de 1 Stocks sur 2 au total'
  end
end
