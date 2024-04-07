importScripts('https://storage.googleapis.com/workbox-cdn/releases/6.4.1/workbox-sw.js');

workbox.routing.registerRoute(
  ({ request }) => request.destination === 'image',
  new workbox.strategies.CacheFirst()
);

self.addEventListener('push', function (event) {
  const notificationData = JSON.parse(event.data.text());

  const options = {
    title: notificationData.title,
    body: notificationData.body,
    icon: notificationData.icon,
  };

  event.waitUntil(
    self.registration.showNotification(notificationData.title, options)
  );
});
