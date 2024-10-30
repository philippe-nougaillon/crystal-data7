ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  include FactoryBot::Syntax::Methods
  
  # Run tests in parallel with specified workers
  # parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  setup do
    # Manufacturer table
  #   # @manufacturer_table = create(:table, name: "Manufacturer", record_index: 3)
  #   # manufacturer_propriétaire_tables_user = create(:tables_user, role: "Propriétaire", table: @manufacturer_table)
  #   # manufacturer_lecteur_tables_user = create(:tables_user, role: "Lecteur", table: @manufacturer_table)
  #   # @user = manufacturer_propriétaire_tables_user.user
  #   # @user_lecteur = manufacturer_lecteur_tables_user.user

  #   # Manufacturer fields
  #   manufacturer_name_field = create(:field, table: @manufacturer_table, row_order: 1, datatype: "Texte", name: "Name")
  #   manufacturer_build_number_field = create(:field, table: @manufacturer_table, row_order: 2, datatype: "Liste", name: "Build Number", items: "[1,2,3,4,5]", filtre: true)

  #   # Manufacturer values
  #   @manufacturer_name_value_1 = create(:value, field: manufacturer_name_field, record_index: 1, data: Faker::Device.unique.manufacturer, user_id: @user.id)
  #   manufacturer_name_value_2 = create(:value, field: manufacturer_name_field, record_index: 2, data: Faker::Device.unique.manufacturer, user_id: @user.id)
  #   manufacturer_name_value_3 = create(:value, field: manufacturer_name_field, record_index: 3, data: Faker::Device.unique.manufacturer, user_id: @user.id)
  #   manufacturer_build_number_value_1 = create(:value, field: manufacturer_build_number_field, record_index: 1, data: 1, user_id: @user.id)

  #   # Device Table
  #   @device_table = create(:table, name: "device", record_index: 3)
  #   devices_users_table = create(:tables_user, role: "Propriétaire", table: @device_table, user: manufacturer_propriétaire_tables_user.user)

  #   # Device fields
  #   device_model_name_field = create(:field, table: @device_table, datatype: "Texte", row_order: 1, name: "Model name")
  #   device_release_date_field = create(:field, table: @device_table, datatype: "Date", row_order: 2, name: "Release Date", filtre: true)
  #   device_manufacturer_field = create(:field, table: @device_table, datatype: "Liste", row_order: 3, name: "Manufacturers", items: "[Manufacturer.Name]")

  #   # Device values
  #   device_model_name_value_1 = create(:value, field: device_model_name_field, record_index: 1, data: Faker::Device.unique.model_name, user_id: @user.id)
  #   @device_model_name_value_2 = create(:value, field: device_model_name_field, record_index: 2, data: Faker::Device.unique.model_name, user_id: @user.id)
  #   @device_model_name_value_3 = create(:value, field: device_model_name_field, record_index: 3, data: Faker::Device.unique.model_name, user_id: @user.id)
  #   device_release_date_value_1 = create(:value, field: device_release_date_field, record_index: 1, data: '2023-12-25', user_id: @user.id)
  #   @device_release_date_value_2 = create(:value, field: device_release_date_field, record_index: 2, data: '2023-12-12', user_id: @user.id)
  #   @device_release_date_value_3 = create(:value, field: device_release_date_field, record_index: 3, data: '2023-10-02', user_id: @user.id)
  #   device_manufacturer_value_1 = create(:value, field: device_manufacturer_field, record_index: 1, data: @manufacturer_name_value_1.data, user_id: @user.id)

  #   # Manufacturer remaining field and values
  #   manufacturer_device_field = create(:field, table: @manufacturer_table, row_order: 4, datatype: "Collection", name: "Device", items: "[#{@device_table.name}.\"#{device_model_name_field.name},#{device_release_date_field.name}\"]")
  #   manufacturer_device_value_1 = create(:value, field: manufacturer_device_field, record_index: 1, data: "2", user_id: @user.id)
  #   manufacturer_device_value_2 = create(:value, field: manufacturer_device_field, record_index: 2, data: "1", user_id: @user.id)

    sanofi = organisations(:sanofi)
    doliprane = teams(:doliprane)
    @admin = sanofi.users.create(name: "Adrien", email: 'admin@gmail.commmm', role: 'admin', password: 'azeaze', password_confirmation: 'azeaze')
    @user = sanofi.users.create(team_id: doliprane.id, name: "Ulysse", email: 'ulysse@gmail.commm', role: 'user', password: '@wGheRSJikuM2ng', password_confirmation: '@wGheRSJikuM2ng')
    
    # pierre_fabre = organisations(:pierre_fabre)
  end

  def login(user)
    visit unauthenticated_root_path
    fill_in "user_email", with: user.email
    fill_in "user_password", with: user.password
    click_on "Se connecter"
    sleep(1)
  end

  # Add more helper methods to be used by all tests here...
end
