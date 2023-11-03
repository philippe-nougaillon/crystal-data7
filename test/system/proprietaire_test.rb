require "application_system_test_case"

class ProprietaireFlowTest < ApplicationSystemTestCase

  setup do
    login_propriétaire(@user)
  end
  
  # Tables
  test "visiting the index" do
    visit tables_url
    assert_selector "h1", text: "Objets"
  end
  
  test "creating a Table" do
    visit tables_url
    click_on "Nouvel Objet"

    fill_in "Donnez un nom à ce nouvel Objet", with: "Interventions"
    click_button "Continuer"
    assert_text "Objet créé. Vous pouvez maintenant y ajouter des attributs"

    fill_in "Nom", with: "Titre"
    check "Obligatoire ?"
    click_button "Ajouter cet attribut"
    assert_text "Nouvel attribut ajouté."
    # TODO: checker si le type du field est un string
    # TODO: checker si le field est obligatoire

    sleep(1)
    fill_in "Nom", with: "Prix"
    page.select "Nombre", from: "Type de données"
    click_button "Ajouter cet attribut"
    assert_text "Nouvel attribut ajouté."
  end

  test "Modifier le field d'une table" do
    visit tables_url
    click_on "Modifier", match: :first
    click_on "Modifier", match: :first

    fill_in "Nom", with: "Nouveau nom"
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
    visit tables_url
    click_on @manufacturer_table.name.upcase
    assert_text @manufacturer_table.name
    fill_in 'Rechercher', with: @manufacturer_table.values.first.data
    send_keys(:return)
    assert_text /Affichage de 1/
  end

  test "visiting the table show" do
    visit tables_url
    click_on @manufacturer_table.name.upcase
    assert_text @manufacturer_table.name
  end

  test "creating a Field" do
    visit tables_url
    click_on @manufacturer_table.name.upcase
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
    click_on @manufacturer_table.name.upcase
    click_on "Modifier Attributs"
    click_on "Modifier", match: :first
    
    fill_in "Nom", with: "Description"
    click_button "Modifier"
    
    assert_text "Attribut modifié avec succès."
  end
  
  test "destroying a Field" do
    visit tables_url
    click_on @manufacturer_table.name.upcase
    click_on "Modifier Attributs"
    page.accept_confirm do
      click_on "X", match: :first
    end

    assert_text "Attribut supprimé."
  end

  test "create workflow field" do
    visit tables_url
    click_on @manufacturer_table.name.upcase
    click_on "Modifier Attributs"

    fill_in "Nom", with: "État"
    page.select "Workflow", from: "Type de données"
    fill_in "Paramètres", with: "Nouveau:primary,Confirmé:success,Annulé:danger,Archivé:secondary"
    click_button "Ajouter cet attribut"
    assert_text "Nouvel attribut ajouté."

    click_on "Voir la Collection d'Objets", match: :first
    click_on "(+) #{@manufacturer_table.name}"
    field = find('[data-testid="État"]')
    field.select "Nouveau"
    click_button "Enregistrer"
    assert_text "Données ajoutées avec succès :)"
    assert_selector "span.badge.bg-primary"
  end

  test "create url field" do
    visit tables_url
    click_on @manufacturer_table.name.upcase
    click_on "Modifier Attributs"

    fill_in "Nom", with: "Url"
    page.select "URL", from: "Type de données"
    click_button "Ajouter cet attribut"
    assert_text "Nouvel attribut ajouté."

    click_on "Voir la Collection d'Objets", match: :first
    click_on "(+) #{@manufacturer_table.name}"
    field = find('[data-testid="Url"]')
    field.fill_in with: "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
    click_button "Enregistrer"
    assert_text "Données ajoutées avec succès :)"
    click_on "youtube.com"
  end

  test "create color field" do
    visit tables_url
    click_on @manufacturer_table.name.upcase
    click_on "Modifier Attributs"

    fill_in "Nom", with: "Couleur"
    page.select "Couleur", from: "Type de données"
    click_button "Ajouter cet attribut"
    assert_text "Nouvel attribut ajouté."

    click_on "Voir la Collection d'Objets", match: :first
    click_on "(+) #{@manufacturer_table.name}"
    field = find('[data-testid="Couleur"]')
    field.set("#FF0000")
    click_button "Enregistrer"
    assert_text "Données ajoutées avec succès :)"
    assert_selector('span[style="background-color: #ff0000"]')
  end

  test "create gps field" do
    visit tables_url
    click_on @manufacturer_table.name.upcase
    click_on "Modifier Attributs"

    fill_in "Nom", with: "Coordonnées"
    page.select "GPS", from: "Type de données"
    click_button "Ajouter cet attribut"
    assert_text "Nouvel attribut ajouté."

    click_on "Voir la Collection d'Objets", match: :first
    click_on "(+) #{@manufacturer_table.name}"
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
    click_on @manufacturer_table.name.upcase
    click_on "Modifier Attributs"

    fill_in "Nom", with: "Image"
    page.select "Image", from: "Type de données"
    click_button "Ajouter cet attribut"
    assert_text "Nouvel attribut ajouté."

    click_on "Voir la Collection d'Objets", match: :first
    click_on "(+) #{@manufacturer_table.name}"
    field = find('[data-testid="Image"]')
    field.attach_file(Rails.root.join("test/fixtures/files/sample.jpg"))
    click_button "Enregistrer"
    assert_text "Données ajoutées avec succès :)"
    assert_selector('a[title="sample.jpg"]')
    assert_selector('img')
  end

  test "create pdf field" do
    visit tables_url
    click_on @manufacturer_table.name.upcase
    click_on "Modifier Attributs"

    fill_in "Nom", with: "PDF"
    page.select "PDF", from: "Type de données"
    click_button "Ajouter cet attribut"
    assert_text "Nouvel attribut ajouté."

    click_on "Voir la Collection d'Objets", match: :first
    click_on "(+) #{@manufacturer_table.name}"
    field = find('[data-testid="PDF"]')
    field.attach_file(Rails.root.join("test/fixtures/files/sample.pdf"))
    click_button "Enregistrer"
    assert_text "Données ajoutées avec succès :)"
    assert_selector('a[title="sample.pdf"]')
    assert_selector('img')
  end

  test "create table type field" do
    visit tables_url
    click_on @manufacturer_table.name.upcase
    click_on "Modifier Attributs"

    fill_in "Nom", with: @device_table.name
    page.select "Collection", from: "Type de données"
    fill_in "Paramètres", with: "[#{@device_table.name}.\"#{@device_model_name_value_3.field.name},#{@device_release_date_value_3.field.name}\"]"
    click_button "Ajouter cet attribut"
    assert_text "Nouvel attribut ajouté."

    click_on "Voir la Collection d'Objets", match: :first
    click_on "(+) #{@manufacturer_table.name}"
    field = find("[data-testid='#{@device_table.name}']")
    field.select "#{@device_model_name_value_3.data}, #{@device_release_date_value_3.data}"
    click_button "Enregistrer"
    assert_text "Données ajoutées avec succès :)"

    link = find("[data-testid='Voir les détails de #{@device_table.name} à la ligne n°#{@device_model_name_value_3.record_index}']")
    link.click
    assert_text @device_table.name.humanize
    assert_text @device_model_name_value_3.data
    assert_text I18n.l @device_release_date_value_3.data.to_date
  end

  test "create utilisateur type field" do

    visit tables_url
    click_on @manufacturer_table.name.upcase
    click_on "Modifier Attributs"

    fill_in "Nom", with: "Assigné à"
    page.select "Utilisateur", from: "Type de données"
    click_button "Ajouter cet attribut"
    assert_text "Nouvel attribut ajouté."

    click_on "Voir la Collection d'Objets", match: :first
    click_on "(+) #{@manufacturer_table.name}"
    field = find('[data-testid="Assigné à"]')
    field.select @user.name
    click_button "Enregistrer"
    assert_text "Données ajoutées avec succès :)"

    click_on "(+) #{@manufacturer_table.name}"
    field = find('[data-testid="Assigné à"]')
    field.select @user_lecteur.name
    click_button "Enregistrer"
    assert_text "Données ajoutées avec succès :)"

  end

  # Values

  test "creating values" do
    visit tables_url
    click_on @manufacturer_table.name.upcase
    click_on "(+) #{@manufacturer_table.name}"

    # Ajout des values
    field = find("[data-testid='#{@manufacturer_table.fields.first.name}']")
    field.fill_in with: Faker::Device.manufacturer
    click_button "Enregistrer"
    assert_text "Données ajoutées avec succès :)"
    assert_text @manufacturer_table.name
  end

  test "updating a Value" do
    old_value = @manufacturer_table.values.find_by(record_index: 2).data
    
    visit tables_url
    click_on @manufacturer_table.name.upcase
    update_link = find('[data-testid="Modifier ligne n°2"]')
    update_link.click
    assert_text "Modification '#{@manufacturer_table.name}'"
    field = find("[data-testid='#{@manufacturer_table.fields.first.name}']")
    field.fill_in with: Faker::Device.manufacturer
    click_button "Enregistrer"
    assert_text "Données modifiées avec succès :)"
    assert_text @manufacturer_table.values.find_by(record_index: 2).data
    assert_no_text old_value
  end
  
  test "détruire un record" do
    visit tables_url
    click_on @manufacturer_table.name.upcase
    delete_button = find('[data-testid="Supprimer ligne n°2"]')
    page.accept_confirm do
      delete_button.click
    end
    assert_text "Enregistrement #2 supprimé avec succès"
    assert_no_selector('[data-testid="Supprimer ligne n°2"]', visible: :all)
  end

  test "ne pas détruire un record relié à une autre table" do
    visit tables_url
    click_on @manufacturer_table.name.upcase
    delete_button = find('[data-testid="Supprimer ligne n°1"]')
    page.accept_confirm do
      delete_button.click
    end
    assert_text "Cet enregistrement n'a pas été supprimé car il est utilisé dans d'autres Tables !"
    assert_selector('[data-testid="Supprimer ligne n°1"]', visible: :all)
  end

  test "créer un record à partir d'une relation" do
    visit tables_url
    click_on @manufacturer_table.name.upcase
    link = find("[data-testid='Voir les détails de #{@device_table.name} à la ligne n°#{@device_model_name_value_2.record_index}']")
    link.click
    sleep(1)
    assert_text /Affichage de 1/
    click_on "(+) #{@manufacturer_table.name.humanize}"
    assert_text "#{@device_model_name_value_2.data}, #{@device_release_date_value_2.data}"
    click_on "Enregistrer"
    assert_text "Données ajoutées avec succès :)"
    assert_text /Affichage de 2/
  end

  # Filtres
  test 'filtrer les valeurs dans une table' do
    visit tables_url
    click_on @manufacturer_table.name.upcase
    assert_text @manufacturer_table.name

    fill_in 'Rechercher', with: @manufacturer_table.values.first.data
    send_keys(:return)
    assert_text /Affichage de 1/

    fill_in 'Rechercher', with: ''
    send_keys(:return)
    select '1', from: 'Build number'
    send_keys(:return)
    assert_text /Affichage de 1/
  end

  test 'filtrer les valeurs par date dans une table (range)' do
    visit tables_url
    click_on @device_table.name.upcase
    assert_text @device_table.name

    fill_in 'Release date : Du', with: '12-24-2023'
    send_keys(:return)
    fill_in 'Au', with: '01-10-2024'
    send_keys(:return)
    assert_text /Affichage de 1/
  end

  test 'filtrer les valeurs par date dans une table (mauvaise date)' do
    visit tables_url
    click_on @device_table.name.upcase
    assert_text @device_table.name

    fill_in 'Release date : Du', with: '12-24-2023'
    send_keys(:return)
    assert_text /Affichage de 0/
  end

  test 'filtrer les valeurs par date dans une table (bonne date)' do
    visit tables_url
    click_on @device_table.name.upcase
    assert_text @device_table.name

    fill_in 'Release date : Du', with: '12-25-2023'
    send_keys(:return)
    assert_text /Affichage de 1/
  end
end
