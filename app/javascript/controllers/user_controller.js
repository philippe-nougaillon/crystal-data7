import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="user"
export default class extends Controller {
  static targets = ['source', 'team']
  connect() {
    // console.log("Hello, Stimulus!", this.element)
    console.log(this.teamTarget.querySelector('select'))
  }

  change() {
    var rôle = this.sourceTarget;
    if (rôle.value == "admin") {
      this.teamTarget.style.display = 'none';
      this.teamTarget.querySelector('select').required = false;
    } else {
      this.teamTarget.style.display = 'block';
      this.teamTarget.querySelector('select').required = true;
    }
  }
}
