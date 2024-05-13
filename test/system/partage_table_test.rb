require "application_system_test_case"

class PartageTableTest < ApplicationSystemTestCase

  test "partager une table à un lecteur et vérifier l'accès" do
    login_propriétaire(@user)
    new_user = create(:user)

    visit tables_url
    click_on @manufacturer_table.name
    click_on "Partages"
    radio_button = find('[value="text"]')
    radio_button.choose
    fill_in "Email", with: new_user.email
    click_on "Partager"
    click_on "Profil"
    click_on "Se déconnecter"

    # Se connecter avec le compte ajouté
    visit root_url
    fill_in "user[email]", with: new_user.email
    fill_in "user[password]", with: new_user.password
    click_on "Se connecter"
    assert_text @manufacturer_table.values.first.data
  end
end
