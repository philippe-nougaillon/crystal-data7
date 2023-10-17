require 'dotenv/load'

User.create!([
  {name: "Démo",      email: "crystaldata.demo@gmail.com", password: ENV['DEMO_PASSWORD'], password_confirmation: ENV['DEMO_PASSWORD']},
  {name: "CDLecteur", email: "crystaldata.lecteur@gmail.com", password: ENV['LECTEUR_PASSWORD'], password_confirmation: ENV['LECTEUR_PASSWORD']},
  {name: "CDCollecteur",email: "crystaldata.collecteur@gmail.com", password: ENV['COLLECTEUR_PASSWORD'], password_confirmation: ENV['COLLECTEUR_PASSWORD']},
  {name: "CDÉditeur", email: "crystaldata.editeur@gmail.com", password: ENV['EDITEUR_PASSWORD'], password_confirmation: ENV['EDITEUR_PASSWORD']}
])

Table.create!([
  {name: "Article",      notification: false, lifo: true, show_on_startup_screen: false, record_index: 2, slug: "0f002a24-ef0b-4eec-8476-0392d6b21077"},
  {name: "Intervention", notification: false, lifo: true, show_on_startup_screen: true, record_index: 3, slug: "b7ad6668-c5e9-4d2e-8eec-8ceb396d088a"},
  {name: "Technicien",   notification: false, lifo: true, show_on_startup_screen: false, record_index: 3, slug: "e108afdb-362a-4395-ad09-867e44f2a5b0"},
  {name: 'Frais',        notification: false, lifo: true, show_on_startup_screen: false, record_index: 7, slug: '7d75f3ca-a4e4-4280-917f-0f43f63318e2'}
])

TablesUser.create!([
  {table_id: 1, user_id: 1, role: "Propriétaire"},
  {table_id: 2, user_id: 1, role: "Propriétaire"},
  {table_id: 3, user_id: 1, role: "Propriétaire"},
  {table_id: 4, user_id: 1, role: "Propriétaire"},
  {table_id: 2, user_id: 2, role: "Lecteur"},
  {table_id: 2, user_id: 3, role: "Collecteur"},
  {table_id: 2, user_id: 4, role: "Éditeur"},
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
  {name: "Technicien",      table_id: 2, datatype: "Collection", items: "[Technicien.\"Nom,Prénom\"]", filtre: true, obligatoire: true, row_order: 6, operation: nil, slug: "a028f718-ce14-42ec-8ed6-e7a7d92c8f43"},
  {name: "Observations",    table_id: 2, datatype: "Texte_riche", items: nil, filtre: false, obligatoire: false, row_order: 7, operation: nil, slug: "f4088f22-ce58-4738-836e-a503f9bffe43"},
  {name: "Temps passé",     table_id: 2, datatype: "Nombre", items: nil, filtre: false, obligatoire: false, row_order: 8, operation: nil, slug: "0962d1b7-382e-4484-aa28-560bae2c5cbf"},
  {name: "Localisation",    table_id: 2, datatype: "GPS", items: nil, filtre: false, obligatoire: false, row_order: 9, operation: nil, visibility: 2, slug: "0962d1b7-382e-4484-aa28-560bae2cffff"},
  {name: "Etat",            table_id: 2, datatype: "Workflow", items: "Nouveau:primary,Confirmé:success,Annulé:danger,Archivé:secondary", filtre: true, obligatoire: true, row_order: 10, operation: nil, slug: "ead8868b-daa7-47d1-80c7-f9385e44ffec"},

  {name: "Nom",         table_id: 3, datatype: "Texte", items: nil, filtre: false, obligatoire: true, row_order: 1, operation: nil, slug: "1c75abf6-5736-4fc7-8c55-20a08b43f414"},
  {name: "Prénom",      table_id: 3, datatype: "Texte", items: nil, filtre: false, obligatoire: true, row_order: 2, operation: nil, slug: "5edf0f5f-25a8-4d36-adc4-3f71d67aa21d"},
  {name: "Embauché le", table_id: 3, datatype: "Date", items: nil, filtre: false, obligatoire: false, row_order: 3, operation: nil, slug: "c803b5ca-8832-4421-a991-dfcdaade349d"},
  {name: "Mémo",        table_id: 3, datatype: "Texte_riche", items: nil, filtre: false, obligatoire: false, row_order: 4, operation: nil, slug: "5cab5a0f-f312-417d-8995-cb63fa816449"},

  {name: "Date",         table_id: 4, datatype: "Date", items: nil, filtre: true, obligatoire: true, row_order: 1, operation: nil, slug: "fd35beda-0a77-4dc6-a1e8-17e0630e9236"},
  {name: "Désignation",  table_id: 4, datatype: "Texte", items: nil, filtre: true, obligatoire: true, row_order: 2, operation: nil, slug: "65597fab-3140-4ff2-9661-bda5226fd3f0"},
  {name: "Montant",      table_id: 4, datatype: "Euros", items: nil, filtre: false, obligatoire: true, row_order: 3, operation: "Somme", slug: "01513e99-8422-4885-8c24-e9f2cd0d7cf5"},
  {name: 'Intervention', table_id: 4, datatype: 'Collection', items: "[Intervention.\"Date,Client,Type,Etat,Technicien\"]", filtre: false, obligatoire: true, row_order: 4, operation: nil, slug: '4d9d1981-524a-4e0b-aab5-7fa81511b444'},
  {name: "Technicien",   table_id: 4, datatype: "Collection", items: "[Technicien.\"Nom,Prénom\"]", filtre: true, obligatoire: true, row_order: 5, operation: nil, slug: "c0e37920-9ec9-455a-846e-8a2d1ff42e39"},
  
])

Value.create!([
  {record_index: 1, field_id: 1, data: "Câble", user_id: 1},
  {record_index: 1, field_id: 2, data: "Nexans", user_id: 1},
  {record_index: 1, field_id: 3, data: "RJ45", user_id: 1},
  {record_index: 1, field_id: 4, data: "15.0", user_id: 1},
  {record_index: 1, field_id: 5, data: "Rouge", user_id: 1},
  {record_index: 1, field_id: 6, data: "7291", user_id: 1},
  
  {record_index: 2, field_id: 1, data: "Câble", user_id: 1},
  {record_index: 2, field_id: 2, data: "Nexans", user_id: 1},
  {record_index: 2, field_id: 3, data: "RJ11", user_id: 1},
  {record_index: 2, field_id: 4, data: "10.0", user_id: 1},
  {record_index: 2, field_id: 5, data: "Noir", user_id: 1},
  {record_index: 2, field_id: 6, data: "53", user_id: 1},


  {record_index: 1, field_id: 7, data: "2023-08-24", user_id: 1},
  {record_index: 1, field_id: 8, data: "Carrefour", user_id: 1},
  {record_index: 1, field_id: 9, data: "Installation", user_id: 1},
  {record_index: 1, field_id: 10, data: "installer une lampe", user_id: 1},
  {record_index: 1, field_id: 11, data: "Oui", user_id: 1},
  {record_index: 1, field_id: 12, data: "1", user_id: 1},
  {record_index: 1, field_id: 13, data: "", user_id: 1},
  {record_index: 1, field_id: 14, data: "0", user_id: 1},
  {record_index: 1, field_id: 15, data: "", user_id: 1},
  {record_index: 1, field_id: 16, data: "Nouveau", user_id: 1},

  {record_index: 2, field_id: 7, data: "2023-08-14", user_id: 1},
  {record_index: 2, field_id: 8, data: "Auchan", user_id: 1},
  {record_index: 2, field_id: 9, data: "Réparation", user_id: 1},
  {record_index: 2, field_id: 10, data: "Réparer caisse n°13", user_id: 1},
  {record_index: 2, field_id: 11, data: "Non", user_id: 1},
  {record_index: 2, field_id: 12, data: "2", user_id: 1},
  {record_index: 2, field_id: 13, data: "Elle est souvent cassée cette machine, c'est la 3° fois !", user_id: 1},
  {record_index: 2, field_id: 14, data: "2", user_id: 1},
  {record_index: 2, field_id: 15, data: "48.9019196, 2.553272", user_id: 1},
  {record_index: 2, field_id: 16, data: "Confirmé", user_id: 1},
  
  {record_index: 3, field_id: 7, data: "2023-08-30", user_id: 1},
  {record_index: 3, field_id: 8, data: "Monoprix", user_id: 1},
  {record_index: 3, field_id: 9, data: "Dépose", user_id: 1},
  {record_index: 3, field_id: 10, data: "Migration réseau LAN Drive", user_id: 1},
  {record_index: 3, field_id: 11, data: "Oui", user_id: 1},
  {record_index: 3, field_id: 12, data: "3", user_id: 1},
  {record_index: 3, field_id: 14, data: "4", user_id: 1},
  {record_index: 3, field_id: 13, data: "Ça m'a l'air trop compliqué !", user_id: 1},
  {record_index: 3, field_id: 15, data: "", user_id: 1},
  {record_index: 3, field_id: 16, data: "Annulé", user_id: 1},

  {record_index: 1, field_id: 17, data: "LEBRUN", user_id: 1},
  {record_index: 1, field_id: 18, data: "Félix", user_id: 1},
  {record_index: 1, field_id: 19, data: "2023-01-01", user_id: 1},
  {record_index: 1, field_id: 20, data: "", user_id: 1},
  
  {record_index: 2, field_id: 17, data: "AUGIER", user_id: 1},
  {record_index: 2, field_id: 18, data: "Alexis", user_id: 1},
  {record_index: 2, field_id: 19, data: "2021-06-01", user_id: 1},
  {record_index: 2, field_id: 20, data: "", user_id: 1},

  {record_index: 3, field_id: 17, data: "DUPIN", user_id: 1},
  {record_index: 3, field_id: 18, data: "Michel", user_id: 1},
  {record_index: 3, field_id: 19, data: "2022-09-01", user_id: 1},
  {record_index: 3, field_id: 20, data: "", user_id: 1},

  {record_index: 1, field_id: 21, data: "2023-08-30", user_id: 1},
  {record_index: 1, field_id: 22, data: "Essence", user_id: 1},
  {record_index: 1, field_id: 23, data: "82", user_id: 1},
  {record_index: 1, field_id: 24, data: "2", user_id: 1},
  {record_index: 1, field_id: 25, data: "1", user_id: 1},
  
  {record_index: 2, field_id: 21, data: "2023-09-13", user_id: 1},
  {record_index: 2, field_id: 22, data: "Repas", user_id: 1},
  {record_index: 2, field_id: 23, data: "25", user_id: 1},
  {record_index: 2, field_id: 24, data: "2", user_id: 1},
  {record_index: 2, field_id: 25, data: "1", user_id: 1},

  {record_index: 3, field_id: 21, data: "2023-08-30", user_id: 1},
  {record_index: 3, field_id: 22, data: "Essence", user_id: 1},
  {record_index: 3, field_id: 23, data: "66", user_id: 1},
  {record_index: 3, field_id: 24, data: "1", user_id: 1},
  {record_index: 3, field_id: 25, data: "2", user_id: 1},
  
  {record_index: 4, field_id: 21, data: "2023-09-13", user_id: 1},
  {record_index: 4, field_id: 22, data: "Repas", user_id: 1},
  {record_index: 4, field_id: 23, data: "15", user_id: 1},
  {record_index: 4, field_id: 24, data: "1", user_id: 1},
  {record_index: 4, field_id: 25, data: "2", user_id: 1},

  {record_index: 5, field_id: 21, data: "2023-09-23", user_id: 1},
  {record_index: 5, field_id: 22, data: "SNCF", user_id: 1},
  {record_index: 5, field_id: 23, data: "115", user_id: 1},
  {record_index: 5, field_id: 24, data: "3", user_id: 1},
  {record_index: 5, field_id: 25, data: "3", user_id: 1},
  
  {record_index: 6, field_id: 21, data: "2023-09-13", user_id: 1},
  {record_index: 6, field_id: 22, data: "Repas", user_id: 1},
  {record_index: 6, field_id: 23, data: "50", user_id: 1},
  {record_index: 6, field_id: 24, data: "3", user_id: 1},
  {record_index: 6, field_id: 25, data: "3", user_id: 1},

  {record_index: 7, field_id: 21, data: "2023-09-13", user_id: 1},
  {record_index: 7, field_id: 22, data: "Hotel", user_id: 1},
  {record_index: 7, field_id: 23, data: "150", user_id: 1},
  {record_index: 7, field_id: 24, data: "3", user_id: 1},
  {record_index: 7, field_id: 25, data: "3", user_id: 1},

])

Filter.create!([
  {name: "Frais de Repas > 20€", table_id: 4, user_id: 1, query: {"21"=>{"start"=>"", "end"=>""}, "22"=>"Repas", "23"=>"> 20"}, slug: "3ac28124-8562-46cb-8b93-dac890c66237"},
  {name: "Nouvelles installations pour Carrefour", table_id: 2, user_id: 1, query: {"7"=>{"start"=>"", "end"=>""},"8"=>"Carrefour","9"=>["Installation"],"10"=>"","13"=>"","14"=>"","15"=>"","16"=>["Nouveau"]}, slug: "88ef1c15-87a6-44ad-9a81-5aa5ec1b6ebf"}
])