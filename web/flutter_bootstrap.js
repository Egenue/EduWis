if (!_flutter) {
  var _flutter = {
    loader: null,
    serviceWorkerVersion: null,
    serviceWorkerUrl: null
  };
}

(function() {
  var scriptLoaded = false;
  function loadMainDartJs() {
    if (scriptLoaded) {
      return;
    }
    scriptLoaded = true;
    var scriptTag = document.createElement('script');
    scriptTag.src = 'main.dart.js';
    scriptTag.type = 'application/javascript';
    document.body.append(scriptTag);
  }

  if ('serviceWorker' in navigator) {
    window.addEventListener('load', function () {
      var serviceWorkerUrl = 'flutter_service_worker.js?v=' + _flutter.serviceWorkerVersion;
      navigator.serviceWorker.register(serviceWorkerUrl)
        .then((reg) => {
          function waitForActivation(serviceWorker) {
            serviceWorker.addEventListener('statechange', () => {
              if (serviceWorker.state == 'activated') {
                console.log('Installed new service worker.');
                loadMainDartJs();
              }
            });
          }
          if (!reg.active && (reg.installing || reg.waiting)) {
            waitForActivation(reg.installing || reg.waiting);
          } else {
            loadMainDartJs();
          }
        })
        .catch((err) => {
          console.error('Failed to register service worker:', err);
          loadMainDartJs();
        });
    });
  } else {
    loadMainDartJs();
  }
})();