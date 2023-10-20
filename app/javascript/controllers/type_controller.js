import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ 'source', 'params', 'number' ]

  initialize() {
    this.paramsTarget.style.display = 'none';
    this.numberTarget.style.display = 'none';
    this.change();
  }

  connect() {
    // console.log("Hello, Stimulus!", this.element)
  }
  change() {
    var type = this.sourceTarget;

    if (['Formule', 'Liste', 'Workflow', 'Collection', 'QRCode', 'Distance'].includes(type.value)) {
      this.paramsTarget.style.display = 'block';
      this.numberTarget.style.dispaly = 'none';
      if (type.value == "Formule" ) {
        this.paramsTarget.children[2].innerHTML = "ex: [Temps] * [Coût horaire] ou [Prix HT] * 1.2 "
      } else if (type.value == "Liste" ) {
        this.paramsTarget.children[2].innerHTML = "ex : À faire,Fait,Annulé ou Monsieur, Madame, Mademoiselle"
      } else if (type.value == "Workflow") {
        this.paramsTarget.children[2].innerHTML = "ex : Nouveau:primary, Confirmé:success, Annulé:danger, Archivé:secondary"
      } else if (type.value == "Collection") {
        this.paramsTarget.children[2].innerHTML = "ex : [Technicien.\"Nom,Prénom,Expérience\"]"
      } else if (type.value == "QRCode") {
        this.paramsTarget.children[2].innerHTML = "ex : [Référence]"
      } else if (type.value == "Distance") {
        this.paramsTarget.children[2].innerHTML = "ex : [Lieu]"
      }
    } else if (type.value == "Nombre" || type.value == "Euros" ) {
      this.paramsTarget.style.display = 'none';
      this.numberTarget.style.display = 'block';
    } else {
      this.paramsTarget.style.display = 'none';
      this.numberTarget.style.display = 'none';
    }
  }
}
