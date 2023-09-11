import { Controller } from "@hotwired/stimulus"

const options = {
  enableHighAccuracy: true,
  maximumAge: 0
};

// Connects to data-controller="geolocation"
export default class extends Controller {
  static targets = [ 'gpstextfield' ]

  connect(){
    // console.log("Geoloc Connect")
  }

  search() {
    //console.log("Geoloc Search")
    navigator.geolocation.getCurrentPosition(this.success.bind(this), this.error, options);
  }

  success(pos) {
    // console.log("Geoloc Success")
    const crd = pos.coords;
    this.gpstextfieldTarget.value = `${crd.latitude}, ${crd.longitude}`
  }
  
  error(err) {
    console.log("Geoloc Error")
    console.warn(`ERROR(${err.code}): ${err.message}`);
  }
}