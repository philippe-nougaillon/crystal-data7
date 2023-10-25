## Vos données métier 'In da Cloud' 

### Application NO-CODE de base de données en ligne, qui vous permet de créer et de partager des collections d'Objets et formulaires variés avec vos collaborateurs

Développeur d'applications métiers en entreprises depuis plus de 30 ans, j'ai souvent aidé mes clients à passer 
d'un système d'information en silos, où les données métier de l'entreprise sont enfermées 
dans des feuilles Excel, à un système de type plateforme où les données sont centralisées et 
partagées entre les services depuis une source unique de confiance (<b>Single Source Of Truth</b>). 

C'est pourquoi j'ai commencé le développement d'un outil NO-CODE et open-source, il y a bientôt 10 ans,  
dans le but de couvrir les fonctions de base d'une plateforme d'information ouverte.

Fort d'une expérience de plus de 30 ans sur les SGDB les plus intéressants de leurs époques 
(SuperBase 64, Yes You Can, SuperDB, FoxPro, dBase 3/4, Paradox 3/4, Access, Delphi, VB4/5/6/SQL Server,
C#/SQLite/MySQL, stack LAMP, Ruby on Rails...), ma vocation a toujours été d'aider mes clients à franchir 
le pas vers le décloisonnement de leurs données, avec pour objectif une informatique de gestion plus efficace, 
collaborative et centrée sur les objectifs. 
	
CrystalData a donc pour ambition d'être un petit concentré de toute mon expérience dans les L4G/SGBD/AGL, 
et, pourquoi pas, de poser les fondations d'une future application sur mesure, la vôtre, 
intégrant toutes vos spécificités, règles métier, Workflow, etc...
	
### Principales fonctionnalités

* Créez des Objets constitués d'attributs variés <br>(Texte, Nombre, Euros, Date, Oui/Non, Liste de choix, Fichier, Image, PDF, Position GPS, Lien vers un Objet dans une autre Collection)
* Ajoutez, éditez vos objets dans un formulaire
* Audit trail: chaque modification d'un objet est consignée dans un historique (quand, qui, quoi, valeur avant, valeur après)
* Recherchez, filtrez et triez vos objets
* Partagez vos collections d'objet avec d'autres utilisateurs
* Exportez vos collections vers un tableur
* Soyez notifié après chaque ajout d'objet dans une collection'
* Accédez à toutes vos collections en mobilité (Les écrans s'adaptent automatiquement aux écrans de smartphones/tablettes)<

 
### L'Objet et ses Attributs

Un objet est constitué d'attributs (ex: Marque, Couleur, Prix, Qté en stock...) et 
chaque attribut peut avoir un type spécifique afin de s'adapter au mieux aux données qu'il contiendra. 

Les types disponibles sont : 

<ul>
			<li>
				<b>Texte</b> :
				<ul>
					<li>Texte simple : peut contenir une chaine de 255 caractères maximum. L'option 'Filtre ?' permet de créer une liste déroulante contenant les valeurs distinctes. </li>
					<li>Texte long : permet de faire des gros messages</li>
					<li>Texte riche : permet de formater du texte (gras, souligné, titre, couleur, taille, liens, listes, etc.), grâce à un éditeur de texte intégré</li>
				</ul>
			</i>
			<li>
				<b>Chiffres</b> :
				<ul>
					<li>Nombre : pour saisir des valeurs numériques, avec ou sans décimales. L'option 'Opération en bas de page', calculera la moyenne ou la somme des valeurs de l'attribut.</li>
					<li>Euros : idem 'Nombre' mais affiche la valeur avec le symbole euros (€).</li>
					<li>Formule : champ calculé à partir de champs existants ou d'une formule en langage Ruby. (Ex: <i>[Temps Passé] * [Coût horaire]</i> OU <i>[Prix HT] * 1.2</i>)
				</ul>
			</li>
			<li><b>Date</b> : une date choisie dans un calendrier.</li>
			<li><b>Oui/Non</b> : permet de choisir entre Oui ou Non ou aucun des deux.</li>
			<li><b>Liste</b> : pour contenir une liste de valeurs, comme 'Bleu,Blanc,Rouge' ou 'À faire,Fait,Annulé'. Les valeurs doivent être séparées par une virgule.
			</li>
			<li><b>Collection</b> : pour afficher les objets d'une autre collection.(Ex: <i>[Technicien."Nom,Prénom,Expérience"]</i>)</li>
			<li>
				<b>Fichier</b> :
				<ul>
					<li>Fichier : permet de lier et de stocker un fichier (document, image, etc...).</li>
					<li>Image : idem 'Fichier' mais affiche un aperçu de l'image ou l'image d'origine selon le contexte.</li>
					<li>PDF : idem 'Fichier' mais affiche un aperçu de la première page du document PDF.</li>
				</ul>
			</li>
			<li><b>URL</b> : permet d'ajouter un lien vers une ressource internet (interne ou externe).</li>
			<li><b>Couleur</b> : affiche une couleur choisie dans une palette.</li>
			<li><b>GPS</b> :
				<ul>
					<li>Capture la localisation de l'utilisateur, s'il le demande, en appuyant sur le bouton <span class="btn btn-sm btn-outline-primary"><i class="fa-solid fa-location-crosshairs"></i></li></span>
					<li>Affiche la location sur une carte, basée sur les coordonnées indiquées au format "LNG, LAT". (Ex: <i>48.85879287621989, 2.294761243572842</i> pour pointer sur la tour Eiffel).</li>
					<li>Distance : Permet de calculer la distance (à vol d'oiseau) entre deux positions GPS. (Ex: <i>[Chantier(GPS)] - [Maison(GPS)]</i> OU <i>[Chantier(GPS)] - 48.85879287621989, 2.294761243572842</i>)</li>
				</ul>
			</li>
			<li><b>Utilisateur</b> : permet de choisir un utilisateur parmi ceux qui ont accès à la table</li>
			<li><b>Workflow</b> : contient l'état d'un objet associé à une couleur. (Ex: <i>Nouveau:primary, Confirmé:success, Annulé:danger, Archivé:secondary</i>)
				<ul><li>
					Couleurs disponibles:
					<span class="badge bg-primary">Primary</span>
					<span class="badge bg-secondary">Secondary</span>
					<span class="badge bg-success">Success</span>
					<span class="badge bg-danger">Danger</span>
					<span class="badge bg-warning text-dark">Warning</span>
					<span class="badge bg-info text-dark">Info</span>
					<span class="badge bg-light text-dark">Light</span>
					<span class="badge bg-dark">Dark</span>
				</li></ul>
			</li>
			<li>
				<b>QR Code</b> : pour générer un QR Code à partir d'un autre attribut. (Ex: <i>[N°deSérie],[Reference],[url site web]</i>)
			</li>
			<li>
				<b>Vidéo YouTube</b> : affiche l'aperçu d'une vidéo YouTube.  
			</li>
			<li>
				<b>UUID</b> : génère un identifiant unique pour chaque objet. (Universally Unique IDentifier)
			</li>

### Relations entre objets
 
Les relations entre objets sont créées avec l'attribut 'Collection'. 
Exemple : un objet Intervention aura un attribut 'Technicien' qui permettra de choisir un technicien dans la collection du même nom.
Ces relations sont aussi visibles dans la vue détails d'un objet. 
Ainsi, quand un objet Technicien est lié à des Interventions, 
celles-ci s'afficheront automatiquement dans la vue de détail du Technicien.

Les Filtres permettent de mémoriser un ensemble de critères de sélection pour obtenir une collection filtrée d'objets.
Ces filtres acceptent différents critères selon le type d'attribut.
Ex : un attribut de type Texte est filtré avec %TXT% (Filtre tout ce qui contient les 3 lettres TXT) 
et un attribut numérique est filtré avec un signe et une valeur (Qté en stock: > 5) 

### Utilisateurs, partages et rôles

Vous pouvez partager vos collections avec d'autres utilisateurs en leur donnant un rôle (Lecteur, Collecteur, Éditeur).
Un <b>lecteur</b> peut seulement consulter les données.
Un <b>collecteur</b> peut ajouter des données mais il ne voit que ses données.
Un <b>éditeur</b> peut voir et modifier toutes les données.

### Développement, support et services

CrystalData a été développé par [Studio 'Philnoug & Partners'](https://www.philnoug.com)

### Besoin d'une nouvelle fonctionnalité ou d'une application sur mesure ? Nous vous la développons !

Pour en savoir plus, [contactez-nous](https://www.philnoug.com/contact)
