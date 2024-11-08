import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    if ("Notification" in window) {
      Notification.requestPermission().then((permission) => {
        if (permission === "granted") {
          // console.log("User accepted to allow notifications.")
          this.makeSubscription();
        } else if (permission === "denied") {
          console.warn("User rejected to allow notifications.");
        } else {
          console.warn("User still didn't give an answer about notifications.");
        }
      });
    } else {
      console.warn("Push notifications not supported.");
    }
  }

  makeSubscription() {
    navigator.serviceWorker.ready.then((serviceWorkerRegistration) => {
      serviceWorkerRegistration.pushManager
        .getSubscription()
        .then((existingSubscription) => {
          if (!existingSubscription) {
            serviceWorkerRegistration.pushManager
              .subscribe({
                userVisibleOnly: true,
                applicationServerKey: this.element.getAttribute(
                  "data-application-server-key"
                ),
              })
              .then((subscription) => {
                this.saveSubscription(subscription);
              });
          } else {
            this.saveSubscription(existingSubscription);
          }
        });
    });
  }

  saveSubscription(subscription) {
    const endpoint = subscription.endpoint;
    const p256dh = btoa(
      String.fromCharCode.apply(
        null,
        new Uint8Array(subscription.getKey("p256dh"))
      )
    );
    const auth = btoa(
      String.fromCharCode.apply(
        null,
        new Uint8Array(subscription.getKey("auth"))
      )
    );

    fetch("/user/session", {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        Accept: "application/json",
        "X-CSRF-Token": document
          .querySelector('meta[name="csrf-token"]')
          .getAttribute("content"),
      },
      body: JSON.stringify({ push_endpoint: endpoint, push_p256dh: p256dh, push_auth: auth }),
    })
      .then((response) => {
        if (response.ok) {
          console.log("Subscription successfully saved on the server.");
        } else {
          console.error("Error saving subscription on the server.");
          subscription.unsubscribe();
        }
      })
      .catch((error) => {
        console.error("Error sending subscription to the server:", error);
        subscription.unsubscribe();
      });
  }
}