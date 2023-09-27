# Crystal-data

# Vos données métier, en ligne et en mobilité 

Cette application Web vous permet de créer des collections d'Objets à partir de feuilles Excel, de les partager en ligne et en mobilité

# Motivation

Développeur d'applications métiers depuis plus de 20 ans, j'ai souvent aidé mes clients à passer 
d'un système d'information en silos, où les données métier critiques de l'entreprise sont enfermées 
dans des feuilles Excel, à un système de type plateforme où les données sont centralisées, 
partagées entre les services, et qui permet à la direction d'avoir une vue d'ensemble de l'activité. 
A force de mettre en place ce type de solution, j'ai remarqué que des motifs se répétaient et 
qu'à chaque nouveau projet les besoins étaient les mêmes.

* Importer les données d'Excel
* Accéder aux données de n'importe où
* Rechercher, filtrer
* Partager les données en toute sécurité

C'est pourquoi j'ai développé Crystal-data, afin d'offrir les 4 premiers services d'un système ouvert 
de type plateforme et aider des entreprises à franchir le pas vers le décloisonnement de leurs données, 
pour une gestion efficace, collaborative et centrée sur leurs objectifs. 
Et, pourquoi pas, poser ainsi les fondations d'une future application sur mesures, 
intégrant les liens entre les données, les règles métiers et les vues personnalisées.


# Fonctionnalités

* Créez vos tables de donnée simplement à partir de feuilles Excel (exportées au format CSV)
* Ajoutez des attributs de type: Texte, Nombre, Euros, Date, Oui/Non, Liste de choix, Champ calculé, Fichier, Signature manuscrite, Coordonnées GPS, Météo locale
* Ajoutez, éditez vos enregistrements dans un formulaire
* Un formulaire permet de saisir vos données, sur PC ou sur mobile
* Audit: chaque modification est consignée dans un historique (qui, quand, quoi)
* Recherchez, filtrez et triez vos données 
* Partagez vos données avec d'autres utilisateurs
* Exportez vos données vers un tableur 
* Suivi graphique de l'activité 
* Notification après chaque ajout de nouvelles données
* Accédez à vos données en mobilité (webAPP)
* Les écrans s'adaptent automatiquement à la taille d'un écran de smartphone


# Installation

Crystal-data est une application <a href="http://rubyonrails.org/">Ruby On Rails 5</a>. 

Pour pouvoir executer l'application, vous devez d'abord installer RoR 5 sur votre serveur, puis copier les sources (git clone) et lancer l'application en utilisant le processus classique:

* bundle install
* rake db:setup
* rake db:seed
* rails s

# Version en ligne

Une version de démonstration est en ligne à cette adresse : <a href="http://crystal-data.philnoug.com"></a>