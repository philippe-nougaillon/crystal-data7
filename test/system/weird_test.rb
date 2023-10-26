require "application_system_test_case"

class WeirdTest < ApplicationSystemTestCase

  setup do
    login_propriétaire(@user)
  end



  test "problème quand on créé un champ : ça ajoute des records vides" do

  end
  test "p-e fixé en réglant le pb précédent : ne pas remplir un formulaire doit ne rien faire (pb quand on ajoute un champ après, ça créé un record vide)" do

  end

  test "import CSV Intervention ne fonctionne pas" do
    # Erreur :
    # PG::NotNullViolation: ERROR: null value in column "user_id" of relation "values" violates not-null constraint
    # DETAIL: Failing row contains (115, 50, 2023-08-30, 2023-10-26 09:36:05, 2023-10-26 09:36:05, 1, null, null).

    # ligne ou ça plante :
    # CONN.execute sql
  end

  test "formulaire partage ne marche pas avec la liste des users, il faut séparer les params, sinon params[:email] se fait écrasé par le prochain field" do

  end

  test "field/update : un field qui est pas bon va faire planter parce qu'on utiliser render" do

  end

  test "notice ne fonctionne plus" do

  end

  test "changer les params d'une collection va ne faire que réafficher l'ID du record lié (le Technicien)" do

  end

  test "y'a eu un décalage dans les fields"

  test "pas forcément un pb : changer les params d'une liste n'actualise pas les records" do

  end

  test "show_details : quand on clique sur les tabulations des tables liées, ça fait réapparaitre le nom de la personne" do

  end


  # à tester
  test "s'ajouter soi-même a une table" do

  end
end
