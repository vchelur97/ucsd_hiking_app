import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["alltrailsLink", "title", "length", "elevation", "routeType", "difficulty", "duration", "driverComp", "status"]

  // Add an event listener so that when the user focuses out of the alltrailslink field after entering a URL, the fetchHikeDetails method is called
  connect() {
    this.alltrailsLinkTarget.addEventListener("focusout", this.fetchHikeDetails.bind(this))
  }

  setStatusDraft(event) {
    event.preventDefault();
    this.statusTarget.value = "draft";
    this.element.submit();
  }

  setStatusReview(event) {
    event.preventDefault();
    this.statusTarget.value = "review";
    this.element.submit();
  }

  setStatusPublished(event) {
    event.preventDefault();
    this.statusTarget.value = "published";
    this.element.submit();
  }

  fetchHikeDetails() {
    const alltrailsLink = this.alltrailsLinkTarget.value
    if (!alltrailsLink) {
      return
    }
    const url = `/hike_details?alltrails_link=${encodeURIComponent(alltrailsLink)}`

    fetch(url)
      .then(response => response.json())
      .then(data => {
        console.log(data)
        if (data.title) {
          this.titleTarget.value = data.title
        }
        if (data.length) {
          this.lengthTarget.value = data.length
        }
        if (data.elevation) {
          this.elevationTarget.value = data.elevation
        }
        if (data.route_type) {
          this.routeTypeTarget.value = data.route_type
        }
        if (data.difficulty) {
          this.difficultyTarget.value = data.difficulty
        }
        if (data.duration) {
          this.durationTarget.value = data.duration
        }
      })
  }
}