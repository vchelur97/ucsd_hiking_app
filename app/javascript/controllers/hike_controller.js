import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["alltrailsLink", "title", "length", "elevation", "routeType", "difficulty", "duration", "driverComp", "status"]

  // Add an event listener so that when the user focuses out of the alltrailslink field after entering a URL, the fetchHikeDetails method is called
  connect() {
    this.alltrailsLinkTarget.addEventListener("focusout", this.fetchHikeDetails.bind(this))
  }

  setStatusDraft(event) {
    event.preventDefault();
    this.statusTarget.children[1].value = "draft";
    this.element.submit();
  }

  setStatusReview(event) {
    event.preventDefault();
    this.statusTarget.children[1].value = "review";
    this.element.submit();
  }

  setStatusPublished(event) {
    event.preventDefault();
    this.statusTarget.children[1].value = "published";
    this.element.submit();
  }

  fetchHikeDetails() {
    const alltrailsLink = this.alltrailsLinkTarget.children[1].value
    if (!alltrailsLink) {
      return
    }
    const url = `/hike_details?alltrails_link=${encodeURIComponent(alltrailsLink)}`

    fetch(url)
      .then(response => response.json())
      .then(data => {
        console.log(data)
        if (data.title) {
          this.titleTarget.children[1].value = data.title
        }
        if (data.length) {
          this.lengthTarget.children[1].value = data.length
        }
        if (data.elevation) {
          this.elevationTarget.children[1].value = data.elevation
        }
        if (data.route_type) {
          this.routeTypeTarget.children[1].value = data.route_type
        }
        if (data.difficulty) {
          this.difficultyTarget.children[1].value = data.difficulty
        }
        if (data.duration) {
          this.durationTarget.children[1].value = data.duration
        }
      }).finally(() => {
        this.titleTarget.classList.remove("hidden")
        this.lengthTarget.classList.remove("hidden")
        this.elevationTarget.classList.remove("hidden")
        this.routeTypeTarget.classList.remove("hidden")
        this.difficultyTarget.classList.remove("hidden")
        this.durationTarget.classList.remove("hidden")
        this.driverCompTarget.classList.remove("hidden")
      })
  }
}