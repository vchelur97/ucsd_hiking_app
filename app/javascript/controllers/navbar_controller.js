import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="navbar"
export default class extends Controller {
  static targets = ["avatarDropdown", "sidebar"]

  toggleSidebar() {
    this.sidebarTarget.classList.toggle('hidden')
    this.avatarDropdownTarget.classList.add('hidden')
  }

  toggleAvatarDropdown() {
    this.avatarDropdownTarget.classList.toggle('hidden')
    this.sidebarTarget.classList.add('hidden')
  }
}
