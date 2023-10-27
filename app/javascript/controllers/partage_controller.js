import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ 'source', 'text', 'list' ]

  initialize() {
    this.textTarget.style.display = 'none';
    this.listTarget.style.display = 'none';
    this.change();
  }

  connect() {
    // console.log("Hello, Stimulus!", this.element)
  }
  change() {
    var type = this.sourceTarget;

    if (type.checked) {
      this.textTarget.style.display = 'block';
      this.listTarget.style.display = 'none';
    } else {
      this.textTarget.style.display = 'none';
      this.listTarget.style.display = 'block';
    }
  }
}
