importScripts('https://storage.googleapis.com/workbox-cdn/releases/6.4.1/workbox-sw.js');

workbox.routing.registerRoute(
  ({ request }) => request.destination === 'image',
  new workbox.strategies.CacheFirst()
);

const pushHandler = async (event) => {
  const notificationData = JSON.parse(event.data.text());
  const options = {
    title: notificationData.title,
    body: notificationData.body,
    icon: notificationData.icon,
    data: {
      link: notificationData.link,
    }
  };
  event.waitUntil(
    self.registration.showNotification(notificationData.title, options)
  );
};

const notificationClickHandler = async (event) => {
  const link = event.notification.data.link;
  event.notification.close();

  event.waitUntil(
    clients
      .matchAll({
        type: "window",
      })
      .then((clientList) => {
        for (const client of clientList) {
          if ("focus" in client) return client.focus().then(() => client.navigate(link));
        }
        if (clients.openWindow) return clients.openWindow(link);
      }),
  );
};

self.addEventListener('push', pushHandler);
self.addEventListener('notificationclick', notificationClickHandler);