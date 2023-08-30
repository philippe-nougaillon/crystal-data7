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
    click_on "Voir les données de 'Stocks'"
    assert_text "Stocks"
  end

  # test "updating a Value" do
  #   visit tables_url
  #   click_on "Stocks"
  #   sleep(1)
  #   update_button = find('[data-testid="Modifier ligne n°1"]')
  #   update_button.click_on "Modifier", match: :first
  #   assert_text "Formulaire 'Stocks'"

  #   field = find('[data-testid="Marque"]')
  #   field.fill_in with: "RJ23"
  #   click_button "Enregistrer"
    
  #   assert_text "RJ23"
  # end
  
  # test "destroying a Field" do
  #   visit tables_url
  #   click_on "Stocks"
  #   click_on "Modifier structure"
  #   page.accept_confirm do
  #     click_on "X", match: :first
  #   end

  #   assert_text "Colonne supprimée."
  # end
end
