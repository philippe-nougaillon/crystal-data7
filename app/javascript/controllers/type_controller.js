import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ 'source', 'attribute_name', 'params', 'number' ]

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

    if (['Formule', 'Liste', 'Statut', 'Collection', 'QRCode', 'Distance'].includes(type.value)) {
      this.paramsTarget.style.display = 'block';
      this.numberTarget.style.display = 'none';
      if (type.value == "Formule") {
        this.paramsTarget.children[2].innerHTML = translations.formula_hint;
      } else if (type.value == "Liste") {
        this.paramsTarget.children[2].innerHTML = translations.list_hint;
      } else if (type.value == "Statut") {
        this.paramsTarget.children[2].innerHTML = translations.status_hint;
      } else if (type.value == "Collection") {
        this.paramsTarget.children[2].innerHTML = translations.collection_hint;
      } else if (type.value == "QRCode") {
        this.paramsTarget.children[2].innerHTML = translations.qrcode_hint;
      } else if (type.value == "Distance") {
        this.paramsTarget.children[2].innerHTML = translations.distance_hint;
      }
    } else if (type.value == "Nombre" || type.value == "Euros" ) {
      this.paramsTarget.style.display = 'none';
      this.numberTarget.style.display = 'block';
    } else {
      this.paramsTarget.style.display = 'none';
      this.numberTarget.style.display = 'none';
    }

    // Préremplissage du nom de l'attribut
    this.attribute_nameTarget.children[1].value = this.sourceTarget.value;
  }
}
