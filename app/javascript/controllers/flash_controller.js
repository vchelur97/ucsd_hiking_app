import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="flash"
export default class extends Controller {
  static targets = ["message", "closeButton"]

  connect() {
    const flashType = this.element.dataset.flashType
    if (flashType === "alert") {
      this.closeButtonTarget.classList.remove("bg-green-200", "text-green-700", "hover:bg-green-300")
      this.closeButtonTarget.classList.add("bg-red-200", "text-red-700", "hover:bg-red-300")
      this.messageTarget.classList.remove("bg-green-100", "text-green-700")
      this.messageTarget.classList.add("bg-red-100", "text-red-700")
    }
  }

  closeMessage() {
    this.messageTarget.classList.add('hidden')
  }
}
