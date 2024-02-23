require "application_system_test_case"

class IntrusionTest < ApplicationSystemTestCase

  test 'voir une table pas à nous' do
    visit root_url
    @user = User.create(email: 'crystaldata-user@gmail.com', name: 'user', password: 'AZERTYUIOP', password_confirmation: 'AZERTYUIOP')
    fill_in 'user[email]', with: @user.email
    fill_in 'user[password]', with: @user.password
    click_on 'Se connecter'

    # @interventions = tables(:interventions)
    visit '/tables/b7ad6668-c5e9-4d2e-8eec-8ceb396d088a'
    assert_no_text 'Interventions'
  end
end
