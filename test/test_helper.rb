ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  # parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def login_propriétaire
    visit root_path
    click_on "Se connecter en tant qu'invité (mode démonstration)"
    sleep(1)
  end

  # def login_lecteur
  #   visit root_path
  #   # email_field = find('[data-testid="Email"]')
  #   fill_in "email", with: users(:user_lecteur).email
  #   fill_in "Password", with: "AZERTYUIOP"
  #   click_on "S'identifier"
  #   sleep(1)
  # end

  # Add more helper methods to be used by all tests here...
end
