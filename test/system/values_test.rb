require "application_system_test_case"

class ValuesTest < ApplicationSystemTestCase

  setup do
    login_user
  end
  
  test "visiting the index" do
    visit tables_url
    click_on "Stocks"
    assert_selector "h1", text: "Stocks"
  end
  
  test "creating values" do
    visit tables_url
    click_on "Stocks"
    click_on "+ Ajouter"

    # Ajout des values
    field = find('[data-testid="Marque"]')
    field.fill_in with: "RJ11"
    click_button "Enregistrer"
    assert_text "Données ajoutées avec succès :)"
    assert_text "Stocks"
  end

  test "updating a Value" do
    visit tables_url
    click_on "Stocks"
    update_link = find('[data-testid="Modifier ligne n°1"]')
    update_link.click
    assert_text "Formulaire 'Stocks'"
    field = find('[data-testid="Marque"]')
    field.fill_in with: "RJ23"
    click_button "Enregistrer"
    assert_text "RJ23"
    assert_no_text "RJ45"
  end
  
  test "destroying a Value" do
    visit tables_url
    click_on "Stocks"
    delete_button = find('[data-testid="Supprimer ligne n°1"]')
    page.accept_confirm do
      delete_button.click
    end
    assert_text "Enregistrement #1 supprimé avec succès"
    assert_no_selector('[data-testid="Supprimer ligne n°1"]', visible: :all)
  end
end
