require "application_system_test_case"

class FieldsTest < ApplicationSystemTestCase

  setup do
    login_user
  end
  
  test "visiting the index" do
    visit tables_url
    click_on "Stocks"
    assert_selector "h1", text: "Stocks"
  end
  
  test "creating a Field" do
    visit tables_url
    click_on "Stocks"
    click_on "Modifier structure"

    # Ajout d'un field
    fill_in "Nom", with: "Désignation"
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

  test "updating a Field" do
    visit tables_url
    click_on "Stocks"
    click_on "Modifier structure"
    click_on "Modifier", match: :first
    
    fill_in "Nom", with: "Description"
    click_button "Modifier"
    
    assert_text "Colonne modifiée."
  end
  
  test "destroying a Field" do
    visit tables_url
    click_on "Stocks"
    click_on "Modifier structure"
    page.accept_confirm do
      click_on "X", match: :first
    end

    assert_text "Colonne supprimée."
  end
end
