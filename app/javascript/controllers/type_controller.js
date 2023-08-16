import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ 'source', 'params', 'number' ]

  initialize() {
    this.paramsTarget.style.display = 'none';
    this.numberTarget.style.display = 'none';
  }

  connect() {
    // console.log("Hello, Stimulus!", this.element)
  }
  change() {
    var type = this.sourceTarget;

    if (type.value == "Formule" || type.value == "Liste" ) {
      this.paramsTarget.style.display = 'block';
      this.numberTarget.style.dispaly = 'none';
    } else if (type.value == "Nombre" || type.value == "Euros" ) {
      this.paramsTarget.style.display = 'none';
      this.numberTarget.style.display = 'block';
    } else {
      this.paramsTarget.style.display = 'none';
      this.numberTarget.style.display = 'none';
    }
  }
}
