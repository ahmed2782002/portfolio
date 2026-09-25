{{flutter_js}}
{{flutter_build_config}}

// No service worker: always serve the latest deploy instead of a cached build.
// Also removes any worker registered by earlier deploys.
if ('serviceWorker' in navigator) {
  navigator.serviceWorker.getRegistrations().then((registrations) => {
    registrations.forEach((registration) => registration.unregister());
  });
}

_flutter.loader.load();
