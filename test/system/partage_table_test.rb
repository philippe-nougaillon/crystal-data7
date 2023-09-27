require "application_system_test_case"

class PartageTableTest < ApplicationSystemTestCase

  test "partager une table à un lecteur et vérifier l'accès" do
    login_propriétaire
    @user = User.create(email: 'crystaldata-lecteur@gmail.com', name:"CDLecteur", password: 'AZERTYUIOP', password_confirmation: 'AZERTYUIOP')
    @stocks = tables(:stocks)

    visit tables_url
    click_on @stocks.name
    click_on "Partager"
    click_on "Ajouter un partage"
    fill_in "Email", with: @user.email
    click_on "Partager"
    click_on "Se déconnecter"

    # Se connecter avec le compte ajouté
    visit root_url
    fill_in "user[email]", with: @user.email
    fill_in "user[password]", with: @user.password
    click_on "S'identifier"
    click_on "Stocks"
    assert_text "RJ45"
  end
end
