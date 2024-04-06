import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="navbar"
export default class extends Controller {
  static targets = ["avatar", "avatarDropdown", "sidebar", "sidebarContent"]

  connect() {
    this.avatarTarget.addEventListener('click', (event) => {
      event.preventDefault() // Prevent default link behavior if the avatar is a link
      this.avatarDropdownTarget.classList.toggle('hidden')
    })

    this.sidebarTarget.addEventListener('click', () => {
      this.sidebarContentTarget.classList.toggle('hidden')
    })
  }
}
