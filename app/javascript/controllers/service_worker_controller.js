import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["installContainer", "networkStatus"]

  connect() {
    this.registerServiceWorker();
    this.deferInstallPrompt();
    // this.checkNetworkStatus();
  }

  registerServiceWorker() {
    if ("serviceWorker" in navigator) {
      navigator.serviceWorker
        .register("/service_worker.js")
        .then((registration) => {
          console.log("Service Worker registered with scope:", registration.scope);
        })
        .catch((error) => {
          console.error("Error during registration Service Worker:", error);
        });
    }
  }

  deferInstallPrompt() {
    const installContainer = this.installContainerTarget;

    window.addEventListener('beforeinstallprompt', (event) => {
      event.preventDefault();
      window.deferredPrompt = event;
      installContainer.classList.toggle('hidden', false);
    });

    installContainer.addEventListener('click', async () => {
      if (!window.deferredPrompt) {
        return;
      }
      window.deferredPrompt.prompt();
      const result = await window.deferredPrompt.userChoice;
      // console.log('👍', 'userChoice', result);
      window.deferredPrompt = null;
      installContainer.classList.toggle('hidden', true);
    });

    window.addEventListener('appinstalled', () => {
      window.deferredPrompt = null;
    });
  }

  checkNetworkStatus() {
    const updateNetworkStatus = () => {
      if (navigator.onLine) {
        this.networkStatusTarget.classList.toggle('hidden', true);
      } else {
        this.networkStatusTarget.classList.toggle('hidden', false);
      }
    }

    window.addEventListener('online', updateNetworkStatus);
    window.addEventListener('offline', updateNetworkStatus);
  }

}