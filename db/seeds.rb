User.create!([
  {name: "Démo", email: "philippe.nougaillon@gmail.com", password: "CDPassword", password_confirmation: "CDPassword", authentication_token: nil}
])
Table.create!([
  {name: "Stocks", notification: false, lifo: false, slug: "0f002a24-ef0b-4eec-8476-0392d6b21077"},
  {name: "Interventions", notification: false, lifo: false, slug: "b7ad6668-c5e9-4d2e-8eec-8ceb396d088a"}
])
TablesUser.create!([
  {table_id: 1, user_id: 1},
  {table_id: 2, user_id: 1}
])

Field.create!([
  {name: "Type", table_id: 1, datatype: "Texte", items: nil, filtre: true, obligatoire: false, row_order: 0, operation: nil, slug: "d346547b-766d-41e5-ab23-c4b588d2ea7f"},
  {name: "Prix", table_id: 1, datatype: "Euros", items: nil, filtre: false, obligatoire: false, row_order: 1879048192, operation: nil, slug: "38060e19-93f9-4bab-a9fc-00dc165581c6"},
  {name: "Marque", table_id: 1, datatype: "Texte", items: nil, filtre: true, obligatoire: false, row_order: 1073741824, operation: nil, slug: "ab8c1c4d-27eb-461e-b304-515e3126546e"},
  {name: "Désignation", table_id: 1, datatype: "Texte", items: nil, filtre: false, obligatoire: false, row_order: 1610612736, operation: nil, slug: "6178e16c-ae1f-4569-ba72-b4f56293bc9f"},
  {name: "Remarques", table_id: 1, datatype: "Texte", items: nil, filtre: false, obligatoire: false, row_order: 2013265920, operation: nil, slug: "9205be6b-0b54-4cb7-8e41-b6b2d2144d57"},
  {name: "Qté en stock", table_id: 1, datatype: "Nombre", items: nil, filtre: false, obligatoire: false, row_order: 2080374784, operation: "Somme", slug: "c464126c-d848-497c-8f32-046b1bac9130"},
  {name: "date", table_id: 2, datatype: "Texte", items: nil, filtre: false, obligatoire: false, row_order: 0, operation: nil, slug: "95371e31-6da2-49c1-9682-a4576bb5c663"},
  {name: "client", table_id: 2, datatype: "Texte", items: nil, filtre: false, obligatoire: false, row_order: 1073741824, operation: nil, slug: "e67a87e1-be55-4cab-a5f6-6395bb7d2fe0"},
  {name: "état", table_id: 2, datatype: "Texte", items: nil, filtre: false, obligatoire: false, row_order: 1610612736, operation: nil, slug: "ad18e6da-5474-4216-b508-7b9ded8fa54f"},
  {name: "description", table_id: 2, datatype: "Texte", items: nil, filtre: false, obligatoire: false, row_order: 1879048192, operation: nil, slug: "0ebb2d39-055b-4b09-8aef-28ff4f7f75c1"},
  {name: "prévoir un escabeau", table_id: 2, datatype: "Texte", items: nil, filtre: false, obligatoire: false, row_order: 2013265920, operation: nil, slug: "8c1aa55b-3ee0-4295-90bb-c4475a5f1049"},
  {name: "technicien", table_id: 2, datatype: "Texte", items: nil, filtre: false, obligatoire: false, row_order: 2080374784, operation: nil, slug: "a028f718-ce14-42ec-8ed6-e7a7d92c8f43"},
  {name: "observations", table_id: 2, datatype: "Texte", items: nil, filtre: false, obligatoire: false, row_order: 2113929216, operation: nil, slug: "f4088f22-ce58-4738-836e-a503f9bffe43"},
  {name: "temps passé", table_id: 2, datatype: "Texte", items: nil, filtre: false, obligatoire: false, row_order: 2130706432, operation: nil, slug: "0962d1b7-382e-4484-aa28-560bae2c5cbf"}
])

Value.create!([
  {field_id: 1, data: "A", record_index: 1},
  {field_id: 2, data: "ACME", record_index: 1},
  {field_id: 3, data: "Produit Z", record_index: 1},
  {field_id: 4, data: "123.45", record_index: 1},
  {field_id: 5, data: "RAS", record_index: 1},
  {field_id: 6, data: "7291", record_index: 1},
  {field_id: 1, data: "A", record_index: 2},
  {field_id: 2, data: "ACME", record_index: 2},
  {field_id: 3, data: "Produit X", record_index: 2},
  {field_id: 4, data: "45.0", record_index: 2},
  {field_id: 5, data: "RAS", record_index: 2},
  {field_id: 6, data: "7", record_index: 2},
  {field_id: 1, data: "B", record_index: 3},
  {field_id: 2, data: "NEWACME", record_index: 3},
  {field_id: 3, data: "Produit Y", record_index: 3},
  {field_id: 4, data: "15.99", record_index: 3},
  {field_id: 5, data: "RAS", record_index: 3},
  {field_id: 6, data: "91", record_index: 3},
  {field_id: 1, data: "C", record_index: 4},
  {field_id: 2, data: "NEWACME", record_index: 4},
  {field_id: 3, data: "Produit A", record_index: 4},
  {field_id: 4, data: "99.99", record_index: 4},
  {field_id: 5, data: "Très solide !", record_index: 4},
  {field_id: 6, data: "79", record_index: 4},
  {field_id: 7, data: "2023-08-24", record_index: 1},
  {field_id: 8, data: "le plateau", record_index: 1},
  {field_id: 9, data: "nouvelle", record_index: 1},
  {field_id: 10, data: "installer une lampe", record_index: 1},
  {field_id: 11, data: "Oui", record_index: 1},
  {field_id: 12, data: "Robert", record_index: 1},
  {field_id: 13, data: "", record_index: 1},
  {field_id: 14, data: "0", record_index: 1},
  {field_id: 7, data: "2023-08-14", record_index: 2},
  {field_id: 8, data: "Auchan", record_index: 2},
  {field_id: 9, data: " terminée", record_index: 2},
  {field_id: 10, data: "Réparer caisse n°3", record_index: 2},
  {field_id: 11, data: "Non", record_index: 2},
  {field_id: 12, data: " Bruno", record_index: 2},
  {field_id: 14, data: "2", record_index: 2},
  {field_id: 7, data: "2023-08-30", record_index: 3},
  {field_id: 8, data: "Monoprix", record_index: 3},
  {field_id: 9, data: " en cours", record_index: 3},
  {field_id: 10, data: "Migration réseau LAN Drive", record_index: 3},
  {field_id: 11, data: "Oui", record_index: 3},
  {field_id: 12, data: " Jean", record_index: 3},
  {field_id: 14, data: "4", record_index: 3},
  {field_id: 7, data: "", record_index: 4},
  {field_id: 8, data: "", record_index: 4},
  {field_id: 9, data: "", record_index: 4},
  {field_id: 10, data: "", record_index: 4},
  {field_id: 11, data: "", record_index: 4},
  {field_id: 12, data: "", record_index: 4},
  {field_id: 13, data: "", record_index: 4},
  {field_id: 14, data: "", record_index: 4},
  {field_id: 13, data: "Ça m'a l'air compliqué", record_index: 3},
  {field_id: 13, data: "Elle est souvent cassé cette machine, c'est embêtant !", record_index: 2}
])