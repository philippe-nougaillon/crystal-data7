# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user = User
        .where(name: 'Démo')
        .first_or_create do |user|
            user.name                   = 'Démo' 
            user.email                  = 'philippe.nougaillon@gmail.com' 
            user.password               = 'CDPassword' 
            user.password_confirmation  = 'CDPassword'
        end

table = Table
            .where(name: 'Stocks')
            .first_or_create do |table|
                table.users << user
                table.name = 'Stocks'
            end

table.fields.destroy_all

field_Type = table.fields.create(name: 'Type', filtre: true)
field_Marque = table.fields.create(name: 'Marque', filtre: true)
field_Désignation = table.fields.create(name: 'Désignation')
field_Prix = table.fields.create(name: 'Prix', datatype: Field.datatypes['Euros'])
field_Rem = table.fields.create(name: 'Remarques')
field_QtéStock = table.fields.create(name: 'Qté en stock', datatype: Field.datatypes['Nombre'], operation: 'Somme')

field_Type.values.create(data: 'A', record_index: 1)
field_Marque.values.create(data: 'ACME', record_index: 1)
field_Désignation.values.create(data: 'Produit Z', record_index: 1)
field_Prix.values.create(data: 123.45, record_index: 1)
field_Rem.values.create(data: 'RAS', record_index: 1)
field_QtéStock.values.create(data: 7291, record_index: 1)

field_Type.values.create(data: 'A', record_index: 2)
field_Marque.values.create(data: 'ACME', record_index: 2)
field_Désignation.values.create(data: 'Produit X', record_index: 2)
field_Prix.values.create(data: 45.00, record_index: 2)
field_Rem.values.create(data: 'RAS', record_index: 2)
field_QtéStock.values.create(data: 7, record_index: 2)

field_Type.values.create(data: 'B', record_index: 3)
field_Marque.values.create(data: 'NEWACME', record_index: 3)
field_Désignation.values.create(data: 'Produit Y', record_index: 3)
field_Prix.values.create(data: 15.99, record_index: 3)
field_Rem.values.create(data: 'RAS', record_index: 3)
field_QtéStock.values.create(data: 91, record_index: 3)

field_Type.values.create(data: 'C', record_index: 4)
field_Marque.values.create(data: 'NEWACME', record_index: 4)
field_Désignation.values.create(data: 'Produit A', record_index: 4)
field_Prix.values.create(data: 99.99, record_index: 4)
field_Rem.values.create(data: 'Très solide !', record_index: 4)
field_QtéStock.values.create(data: 79, record_index: 4)


