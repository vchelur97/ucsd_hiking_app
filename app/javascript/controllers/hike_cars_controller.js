import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["carId", "carCapacity", "compensation"]

  // Add an event listener so that when the user focuses out of the alltrailslink field after entering a URL, the fetchHikeDetails method is called
  connect() {
    this.carId.addEventListener("change", this.fetchCarDetails.bind(this))
  }

    fetchCarDetails() {
        const carId = this.carIdTarget.value
        if (!carId) {
        return
        }
        const url = `/car_details?car_id=${encodeURIComponent(carId)}`
    
        fetch(url)
        .then(response => response.json())
        .then(data => {
            console.log(data)
            if (data.car_capacity) {
            this.carCapacityTarget.children[1].value = data.car_capacity
            }
            if (data.compensation) {
            this.compensationTarget.children[1].value = data.compensation
            }
        }).finally(() => {
            this.carCapacityTarget.classList.remove("hidden")
            this.compensationTarget.classList.remove("hidden")
        })
    }

}