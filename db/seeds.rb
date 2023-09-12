User.create!([
  {name: "Démo", email: "philippe.nougaillon@gmail.com", password: "CDPassword", password_confirmation: "CDPassword", authentication_token: nil}
])

Table.create!([
  {name: "Stocks",        notification: false, lifo: true, record_index: 2, slug: "0f002a24-ef0b-4eec-8476-0392d6b21077"},
  {name: "Interventions", notification: false, lifo: true, record_index: 3, slug: "b7ad6668-c5e9-4d2e-8eec-8ceb396d088a"},
  {name: "Techniciens",   notification: false, lifo: true, record_index: 3, slug: "e108afdb-362a-4395-ad09-867e44f2a5b0"}
])

TablesUser.create!([
  {table_id: 1, user_id: 1, role: "propriétaire"},
  {table_id: 2, user_id: 1, role: "propriétaire"},
  {table_id: 3, user_id: 1, role: "propriétaire"}
])

Field.create!([
  {name: "Type",        table_id: 1, datatype: "Texte", items: nil, filtre: true, obligatoire: true, row_order: 1, operation: nil, slug: "d346547b-766d-41e5-ab23-c4b588d2ea7f"},
  {name: "Marque",      table_id: 1, datatype: "Texte", items: nil, filtre: true, obligatoire: false, row_order: 2, operation: nil, slug: "ab8c1c4d-27eb-461e-b304-515e3126546e"},
  {name: "Désignation", table_id: 1, datatype: "Texte", items: nil, filtre: false, obligatoire: false, row_order: 3, operation: nil, slug: "6178e16c-ae1f-4569-ba72-b4f56293bc9f"},
  {name: "Prix",        table_id: 1, datatype: "Euros", items: nil, filtre: false, obligatoire: false, row_order: 4, operation: nil, slug: "38060e19-93f9-4bab-a9fc-00dc165581c6"},
  {name: "Remarques",   table_id: 1, datatype: "Texte", items: nil, filtre: false, obligatoire: false, row_order: 5, operation: nil, slug: "9205be6b-0b54-4cb7-8e41-b6b2d2144d57"},
  {name: "Qté en stock",table_id: 1, datatype: "Nombre", items: nil, filtre: false, obligatoire: false, row_order: 6, operation: "Somme", slug: "c464126c-d848-497c-8f32-046b1bac9130"},

  {name: "Date",            table_id: 2, datatype: "Date", items: nil, filtre: false, obligatoire: true, row_order: 1, operation: nil, slug: "95371e31-6da2-49c1-9682-a4576bb5c663"},
  {name: "Client",          table_id: 2, datatype: "Texte", items: nil, filtre: false, obligatoire: false, row_order: 2, operation: nil, slug: "e67a87e1-be55-4cab-a5f6-6395bb7d2fe0"},
  {name: "Type",            table_id: 2, datatype: "Liste", items: "Dépose,Installation,Réparation", filtre: true, obligatoire: false, row_order: 3, operation: nil, slug: "ad18e6da-5474-4216-b508-7b9ded8fa54f"},
  {name: "Description",     table_id: 2, datatype: "Texte_long", items: nil, filtre: false, obligatoire: false, row_order: 4, operation: nil, slug: "0ebb2d39-055b-4b09-8aef-28ff4f7f75c1"},
  {name: "Prévoir escabeau?",table_id: 2, datatype: "Oui_non?", items: nil, filtre: false, obligatoire: false, row_order: 5, operation: nil, slug: "8c1aa55b-3ee0-4295-90bb-c4475a5f1049"},
  {name: "Technicien",      table_id: 2, datatype: "Table", items: "[Techniciens.\"Nom,Prénom\"]", filtre: false, obligatoire: false, row_order: 6, operation: nil, slug: "a028f718-ce14-42ec-8ed6-e7a7d92c8f43"},
  {name: "Observations",    table_id: 2, datatype: "Texte_riche", items: nil, filtre: false, obligatoire: false, row_order: 7, operation: nil, slug: "f4088f22-ce58-4738-836e-a503f9bffe43"},
  {name: "Temps passé",     table_id: 2, datatype: "Nombre", items: nil, filtre: false, obligatoire: false, row_order: 8, operation: nil, slug: "0962d1b7-382e-4484-aa28-560bae2c5cbf"},
  {name: "Localisation",    table_id: 2, datatype: "GPS", items: nil, filtre: false, obligatoire: false, row_order: 9, operation: nil, slug: "0962d1b7-382e-4484-aa28-560bae2cffff"},
  {name: "Etat",            table_id: 2, datatype: "Workflow", items: "Nouveau:primary,Confirmé:success,Annulé:danger,Archivé:secondary", filtre: true, obligatoire: true, row_order: 10, operation: nil, slug: "ead8868b-daa7-47d1-80c7-f9385e44ffec"},

  {name: "Nom",         table_id: 3, datatype: "Texte", items: nil, filtre: false, obligatoire: true, row_order: 1, operation: nil, slug: "1c75abf6-5736-4fc7-8c55-20a08b43f414"},
  {name: "Prénom",      table_id: 3, datatype: "Texte", items: nil, filtre: false, obligatoire: true, row_order: 2, operation: nil, slug: "5edf0f5f-25a8-4d36-adc4-3f71d67aa21d"},
  {name: "Embauché le", table_id: 3, datatype: "Date", items: nil, filtre: false, obligatoire: false, row_order: 3, operation: nil, slug: "c803b5ca-8832-4421-a991-dfcdaade349d"},
  {name: "Mémo",        table_id: 3, datatype: "Texte_riche", items: nil, filtre: false, obligatoire: false, row_order: 4, operation: nil, slug: "5cab5a0f-f312-417d-8995-cb63fa816449"}
])

Value.create!([
  {record_index: 1, field_id: 1, data: "Câble"},
  {record_index: 1, field_id: 2, data: "Nexans"},
  {record_index: 1, field_id: 3, data: "RJ45"},
  {record_index: 1, field_id: 4, data: "15.0"},
  {record_index: 1, field_id: 5, data: "Rouge"},
  {record_index: 1, field_id: 6, data: "7291"},
  
  {record_index: 2, field_id: 1, data: "Câble"},
  {record_index: 2, field_id: 2, data: "Nexans"},
  {record_index: 2, field_id: 3, data: "RJ11"},
  {record_index: 2, field_id: 4, data: "10.0"},
  {record_index: 2, field_id: 5, data: "Noir"},
  {record_index: 2, field_id: 6, data: "53"},


  {record_index: 1, field_id: 7, data: "2023-08-24"},
  {record_index: 1, field_id: 8, data: "Carrefour"},
  {record_index: 1, field_id: 9, data: "Installation"},
  {record_index: 1, field_id: 10, data: "installer une lampe"},
  {record_index: 1, field_id: 11, data: "Oui"},
  {record_index: 1, field_id: 12, data: "1"},
  {record_index: 1, field_id: 13, data: ""},
  {record_index: 1, field_id: 14, data: "0"},
  {record_index: 1, field_id: 15, data: ""},
  {record_index: 1, field_id: 16, data: "Nouveau"},

  {record_index: 2, field_id: 7, data: "2023-08-14"},
  {record_index: 2, field_id: 8, data: "Auchan"},
  {record_index: 2, field_id: 9, data: "Réparation"},
  {record_index: 2, field_id: 10, data: "Réparer caisse n°13"},
  {record_index: 2, field_id: 11, data: "Non"},
  {record_index: 2, field_id: 12, data: "2"},
  {record_index: 2, field_id: 13, data: "Elle est souvent cassée cette machine, c'est la 3° fois !"},
  {record_index: 2, field_id: 14, data: "2"},
  {record_index: 2, field_id: 15, data: "48.9019196, 2.553272"},
  {record_index: 2, field_id: 16, data: "Confirmé"},
  
  {record_index: 3, field_id: 7, data: "2023-08-30"},
  {record_index: 3, field_id: 8, data: "Monoprix"},
  {record_index: 3, field_id: 9, data: "Dépose"},
  {record_index: 3, field_id: 10, data: "Migration réseau LAN Drive"},
  {record_index: 3, field_id: 11, data: "Oui"},
  {record_index: 3, field_id: 12, data: "3"},
  {record_index: 3, field_id: 14, data: "4"},
  {record_index: 3, field_id: 13, data: "Ça m'a l'air trop compliqué !"},
  {record_index: 3, field_id: 15, data: ""},
  {record_index: 3, field_id: 16, data: "Annulé"},

  {record_index: 1, field_id: 17, data: "LEBRUN"},
  {record_index: 1, field_id: 18, data: "Félix"},
  {record_index: 1, field_id: 19, data: "2023-01-01"},
  {record_index: 1, field_id: 20, data: ""},
  
  {record_index: 2, field_id: 17, data: "AUGIER"},
  {record_index: 2, field_id: 18, data: "Alexis"},
  {record_index: 2, field_id: 19, data: "2021-06-01"},
  {record_index: 2, field_id: 20, data: ""},

  {record_index: 3, field_id: 17, data: "DUPIN"},
  {record_index: 3, field_id: 18, data: "Michel"},
  {record_index: 3, field_id: 19, data: "2022-09-01"},
  {record_index: 3, field_id: 20, data: ""},

])

Audited::Audit.delete_all