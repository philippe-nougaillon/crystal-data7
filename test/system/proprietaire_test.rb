require "application_system_test_case"

class ProprietaireFlowTest < ApplicationSystemTestCase

  setup do
    login_propriétaire
  end
  
  # Tables
  test "visiting the index" do
    visit tables_url
    assert_selector "h1", text: "Mes Objets"
  end
  
  test "creating a Table" do
    visit tables_url
    click_on "Nouvel Objet"

    fill_in "Donnez un nom à ce nouvel Objet", with: "Interventions"
    click_button "Continuer"
    assert_text "Objet créé. Vous pouvez maintenant y ajouter des attributs"

    # Ajout de fields
    fill_in "Nom", with: "Titre"
    check "Obligatoire ?"
    click_button "Ajouter cet attribut"
    assert_text "Nouvel attribut ajouté."
    # TODO: checker si le type du field est un string
    # TODO: checker si le field est obligatoire

    sleep(1) # Pour éviter que ça aille trop vite et que ça plante
    fill_in "Nom", with: "Prix"
    page.select "Nombre", from: "Type de données"
    click_button "Ajouter cet attribut"
    assert_text "Nouvel attribut ajouté."
  end

  test "updating a Table" do
    visit tables_url
    click_on "Modifier", match: :first
    click_on "Modifier", match: :first

    fill_in "Nom", with: "Type"
    click_button "Modifier"

    assert_text "Attribut modifié avec succès."
  end

  test "destroying a Table" do
    visit tables_url
    page.accept_confirm do
      click_on "X", match: :first
    end

    assert_text "Objet supprimé."
  end

  test 'chercher une valeur dans une table' do
    @table = tables(:stocks)

    visit tables_url
    click_on @table.name.upcase
    assert_text 'Stocks'
    fill_in 'Rechercher', with: 'RJ45'
    send_keys(:return)
    assert_selector 'p', text: 'Affichage de 1 Stocks sur 3 au total'
  end

  # Fields
  test "visiting the stocks show" do
    visit tables_url
    click_on "STOCKS", match: :first
    assert_text 'Stocks'
  end
  
  test "creating a Field" do
    visit tables_url
    click_on "STOCKS", match: :first
    click_on "Modifier Attributs"

    # Ajout d'un field
    fill_in "Nom", with: "Désignation"
    click_button "Ajouter cet attribut"
    assert_text "Nouvel attribut ajouté."
    assert_text "Désignation"
    # TODO: checker si le type du field est un string
    # TODO: checker si le field est obligatoire

    fill_in "Nom", with: "Prix"
    page.select "Nombre", from: "Type de données"
    click_button "Ajouter cet attribut"
    assert_text "Nouvel attribut ajouté."
    assert_text "Nombre"

    sleep(1)
    fill_in "Nom", with: "Lieu"
    page.select "Liste", from: "Type de données"
    fill_in "Paramètres", with: "[Interventions.Lieu]"
    click_button "Ajouter cet attribut"
    assert_text "Nouvel attribut ajouté."
    assert_text "Liste"
  end

  test "updating a Field" do
    visit tables_url
    click_on "STOCKS", match: :first
    click_on "Modifier Attributs"
    click_on "Modifier", match: :first
    
    fill_in "Nom", with: "Description"
    click_button "Modifier"
    
    assert_text "Attribut modifié avec succès."
  end
  
  test "destroying a Field" do
    visit tables_url
    click_on "STOCKS", match: :first
    click_on "Modifier Attributs"
    page.accept_confirm do
      click_on "X", match: :first
    end

    assert_text "Attribut supprimé."
  end

  test "create workflow field" do
    visit tables_url
    click_on "STOCKS", match: :first
    click_on "Modifier Attributs"

    fill_in "Nom", with: "État"
    page.select "Workflow", from: "Type de données"
    fill_in "Paramètres", with: "Nouveau:primary,Confirmé:success,Annulé:danger,Archivé:secondary"
    click_button "Ajouter cet attribut"
    assert_text "Nouvel attribut ajouté."

    click_on "Voir la Collection d'Objets", match: :first
    click_on "(+) Stock"
    field = find('[data-testid="État"]')
    field.select "Nouveau"
    click_button "Enregistrer"
    assert_text "Données ajoutées avec succès :)"
    assert_selector "span.badge.bg-primary"
  end

  test "create url field" do
    visit tables_url
    click_on "STOCKS", match: :first
    click_on "Modifier Attributs"

    fill_in "Nom", with: "Url"
    page.select "URL", from: "Type de données"
    click_button "Ajouter cet attribut"
    assert_text "Nouvel attribut ajouté."

    click_on "Voir la Collection d'Objets", match: :first
    click_on "(+) Stock"
    field = find('[data-testid="Url"]')
    field.fill_in with: "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
    click_button "Enregistrer"
    assert_text "Données ajoutées avec succès :)"
    click_on "youtube.com"
  end

  test "create color field" do
    visit tables_url
    click_on "STOCKS", match: :first
    click_on "Modifier Attributs"

    fill_in "Nom", with: "Couleur"
    page.select "Couleur", from: "Type de données"
    click_button "Ajouter cet attribut"
    assert_text "Nouvel attribut ajouté."

    click_on "Voir la Collection d'Objets", match: :first
    click_on "(+) Stock"
    field = find('[data-testid="Couleur"]')
    field.set("#FF0000")
    click_button "Enregistrer"
    assert_text "Données ajoutées avec succès :)"
    assert_selector('span[style="background-color: #ff0000"]')
  end

  test "create gps field" do
    visit tables_url
    click_on "STOCKS", match: :first
    click_on "Modifier Attributs"

    fill_in "Nom", with: "Coordonnées"
    page.select "GPS", from: "Type de données"
    click_button "Ajouter cet attribut"
    assert_text "Nouvel attribut ajouté."

    click_on "Voir la Collection d'Objets", match: :first
    click_on "(+) Stock"
    field = find('[data-testid="Coordonnées"]')
    field.fill_in with: '48.85879287621989, 2.294761243572842'
    click_button "Enregistrer"
    assert_text "Données ajoutées avec succès :)"

    button_show = find('[data-testid="Voir ligne n°4"]')
    button_show.click
    assert_selector('canvas[class="mapboxgl-canvas"]')
  end

  test "create image field" do
    visit tables_url
    click_on "STOCKS", match: :first
    click_on "Modifier Attributs"

    fill_in "Nom", with: "Image"
    page.select "Image", from: "Type de données"
    click_button "Ajouter cet attribut"
    assert_text "Nouvel attribut ajouté."

    click_on "Voir la Collection d'Objets", match: :first
    click_on "(+) Stock"
    field = find('[data-testid="Image"]')
    field.attach_file(Rails.root.join("test/fixtures/files/sample.jpg"))
    click_button "Enregistrer"
    assert_text "Données ajoutées avec succès :)"
    assert_selector('a[title="sample.jpg"]')
    assert_selector('img')
  end

  test "create pdf field" do
    visit tables_url
    click_on "STOCKS", match: :first
    click_on "Modifier Attributs"

    fill_in "Nom", with: "PDF"
    page.select "PDF", from: "Type de données"
    click_button "Ajouter cet attribut"
    assert_text "Nouvel attribut ajouté."

    click_on "Voir la Collection d'Objets", match: :first
    click_on "(+) Stock"
    field = find('[data-testid="PDF"]')
    field.attach_file(Rails.root.join("test/fixtures/files/sample.pdf"))
    click_button "Enregistrer"
    assert_text "Données ajoutées avec succès :)"
    show_button = find('a[data-testid="Voir ligne n°4"]')
    click_on show_button
    assert_selector('a[title="sample.pdf"]')
    assert_selector('img')
  end

  test "create table type field" do
    visit tables_url
    click_on "STOCKS", match: :first
    click_on "Modifier Attributs"

    fill_in "Nom", with: "Interventions"
    page.select "Collection", from: "Type de données"
    fill_in "Paramètres", with: "[Interventions.\"Lieu,Date\"]"
    click_button "Ajouter cet attribut"
    assert_text "Nouvel attribut ajouté."

    click_on "Voir la Collection d'Objets", match: :first
    click_on "(+) Stock"
    field = find('[data-testid="Interventions"]')
    field.select "Paris, 2023-12-25"
    click_button "Enregistrer"
    assert_text "Données ajoutées avec succès :)"
    
    new_window = window_opened_by do
      link = find('[title="Voir les détails de Interventions à la ligne n°1"]')
      link.click
    end
    within_window new_window do
      assert_text "Interventions"
      assert_text "Paris"
      assert_text "25/12/2023"
    end
  end

  test "create utilisateur type field" do
    user = users(:user_proriétaire)
    user_lecteur = users(:user_lecteur)

    visit tables_url
    click_on "INTERVENTIONS", match: :first
    click_on "Modifier Attributs"

    fill_in "Nom", with: "Assigné à"
    page.select "Utilisateur", from: "Type de données"
    click_button "Ajouter cet attribut"
    assert_text "Nouvel attribut ajouté."

    click_on "Voir la Collection d'Objets", match: :first
    click_on "(+) Intervention"
    field = find('[data-testid="Assigné à"]')
    field.select user.name
    click_button "Enregistrer"
    assert_text "Données ajoutées avec succès :)"

    click_on "(+) Intervention"
    field = find('[data-testid="Assigné à"]')
    field.select user_lecteur.name
    click_button "Enregistrer"
    assert_text "Données ajoutées avec succès :)"

  end

  # Values

  test "creating values" do
    visit tables_url
    click_on "STOCKS", match: :first
    click_on "(+) Stock"

    # Ajout des values
    field = find('[data-testid="Marque"]')
    field.fill_in with: "RJ11"
    click_button "Enregistrer"
    assert_text "Données ajoutées avec succès :)"
    assert_text "Stocks"
  end

  test "updating a Value" do
    visit tables_url
    click_on "STOCKS", match: :first
    update_link = find('[data-testid="Modifier ligne n°1"]')
    update_link.click
    assert_text "Modification 'Stocks'"
    field = find('[data-testid="Marque"]')
    field.fill_in with: "RJ23"
    click_button "Enregistrer"
    assert_text "RJ23"
    assert_no_text "RJ45"
  end
  
  test "destroying a Value" do
    visit tables_url
    click_on "STOCKS", match: :first
    delete_button = find('[data-testid="Supprimer ligne n°1"]')
    page.accept_confirm do
      delete_button.click
    end
    assert_text "Enregistrement #1 supprimé avec succès"
    assert_no_selector('[data-testid="Supprimer ligne n°1"]', visible: :all)
  end

  test 'filter les valeurs dans une table' do
    @table = tables(:stocks)

    visit tables_url
    click_on @table.name.upcase
    assert_text 'Stocks'

    fill_in 'Rechercher', with: 'RJ45'
    send_keys(:return)
    assert_selector 'p', text: 'Affichage de 1 Stocks sur 3 au total'

    select '', from: 'Catégorie'
    select 'Automobile', from: 'Catégorie'
    send_keys(:return)
    assert_selector 'p', text: 'Affichage de 1 Stocks sur 3 au total'
  end

  test 'filter les valeurs par date dans une table' do
    @table = tables(:interventions)

    visit tables_url
    click_on @table.name.upcase
    assert_text 'Interventions'

    fill_in 'Date : Du', with: '24-12-2023'
    send_keys(:return)
    fill_in 'Au', with: '10-01-2024'
    send_keys(:return)
    assert_selector 'p', text: 'Affichage de 1 Interventions sur 2 au total'

    fill_in 'Au', with: ''
    send_keys(:return)
    assert_selector 'p', text: 'Affichage de 2 Interventions sur 2 au total'
  end
end
