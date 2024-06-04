// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "controllers"
import "@hotwired/turbo-rails"

Turbo.setConfirmMethod((message, element) => {
  let dialog = document.getElementById("turbo-confirm")
  dialog.querySelector("p").textContent = message
  dialog.showModal()

  return new Promise((resolve, reject) => {
    dialog.addEventListener("close", () => {
      resolve(dialog.returnValue == "confirm")
    }, { once: true });
  });
})