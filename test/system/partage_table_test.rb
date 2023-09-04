require "application_system_test_case"

class PartageTableTest < ApplicationSystemTestCase

  setup do
    login_user
    @user = User.create(email: 'crystaldata-user@gmail.com', name:"user", password: 'AZERTYUIOP', password_confirmation: 'AZERTYUIOP')
  end
  
  test "partager une table" do
    @stocks = tables(:stocks)

    visit tables_url
    click_on @stocks.name
    click_on "Partager"
    click_on "Ajouter un partage"
    fill_in "Email", with: @user.email
    click_on "Partager"
    click_on "Se déconnecter"
    fill_in "user[email]", with: @user.email
    fill_in "user[password]", with: @user.password
    click_on "S'identifier"
    click_on "Stocks"
    assert_text "RJ45"
  end
end
