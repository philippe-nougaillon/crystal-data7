import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="weather"
export default class extends Controller {
  static targets = ['weathertextfield']
  connect() {
    console.log("Weather Connect")
  }

  search() {
    console.log("Weather Search")
    
    this.getLocation()
  }

  getLocation() {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(position => {
        const latitude = position.coords.latitude;
        const longitude = position.coords.longitude;
        this.getWeather(latitude, longitude);
      }, error => {
        console.error(`Erreur de géolocalisation: ${error.message}`);
      });
    } else {
      console.error("La géolocalisation n'est pas supportée par ce navigateur.");
    }
  }

  async getWeather(latitude, longitude) {
    const apiKey = '4a8bbd4c05f24260958123949242006';
    const url = `https://api.weatherapi.com/v1/current.json?key=${apiKey}&q=${latitude},${longitude}&lang=fr`;

    try {
      const response = await fetch(url);
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      const data = await response.json();

      const temperature = data.current.temp_c;
      const condition = data.current.condition.text;
      const humidity = data.current.humidity;

      // console.log(`Current temperature in ${location}: ${temperature}°C`);
      // console.log(`Current condition in ${location}: ${condition}`);
      this.weathertextfieldTarget.value = `${temperature}°C, ${condition}, ${humidity}% d'humidité`
    } catch (error) {
      console.error(`Could not fetch weather data: ${error}`);
    }
  }
}
