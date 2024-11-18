import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="graph"
export default class extends Controller {
  static targets = ['chartType', 'field', 'sort', 'desc']
  connect() {
    // console.log("Hello, Stimulus!", this.element)
    // this.changeType();
    // this.changeField();
    this.toggleSort();
  }

  changeType() {
    var chartType = this.chartTypeTarget;
    if (chartType.value != "mix") {
      // TODO : faire disparaitre le deuxième field
      // this.fieldTarget.style.display = 'none';
    } else {
      // TODO : faire appaitre le deuxième field
      // this.fieldTarget.style.display = 'block';
    }
  }

  changeField() {
    fetch(`/graphs/update_filters?field_id=${this.fieldTarget.value}`, {
      method: "GET",
      headers: {
        "Accept": "text/html"
      }
    })
      .then(response => response.text())
      .then(html => {
        // Mettre à jour les options de filter_id
        const filterSelect = this.element.querySelector('select[name="graph[filter_id]"]');
        const selectedValue = filterSelect.value;
        filterSelect.innerHTML = `<option value=""></option>` + html;
        if (Array.from(filterSelect.options).some(option => option.value === selectedValue)) {
          filterSelect.value = selectedValue;
        }
      })
      .catch(error => console.error('Erreur lors du chargement des filtres :', error));
  }

  toggleSort() {
    // var sort = this.sortTarget;
    // if (sort.checked) {
    //   this.descTarget.style.display = 'block';
    //   this.descTarget.classList.add('d-inline');
    // } else {
    //   this.descTarget.style.display = 'none';
    //   this.descTarget.classList.remove('d-inline');
    // }
  }
}
