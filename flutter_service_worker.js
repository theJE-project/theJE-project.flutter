'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "681d507c0f066d90a668e9a6c0ac8190",
"assets/AssetManifest.bin.json": "f96fc3e3d2d82215569e58b27cef0cd1",
"assets/AssetManifest.json": "e4f85bcd315b5dac19cde6bde4274cc5",
"assets/assets/flower.jpg": "8cd468d072ac354d4dc66d8ec3fa0676",
"assets/FontManifest.json": "4801af706d6888ee3106fcd21849840d",
"assets/fonts/MaterialIcons-Regular.otf": "b38641d2b9018086ce5a74172508d71a",
"assets/NOTICES": "859fac45f99609833eda2cb320dc8e3a",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/packages/flutter_feather_icons/fonts/feather.ttf": "c96dc22ca29a082af83cce866d35cebc",
"assets/packages/flutter_tailwind_ui/fonts/Geist-Black.ttf": "7fd0bf9902a8efe2a3b5cab43ef39c9c",
"assets/packages/flutter_tailwind_ui/fonts/Geist-Bold.ttf": "541436b3265ad8b4c64b65756321310f",
"assets/packages/flutter_tailwind_ui/fonts/Geist-ExtraBold.ttf": "6331bd0fab7f4bc57eaba55e3ece631d",
"assets/packages/flutter_tailwind_ui/fonts/Geist-ExtraLight.ttf": "714aaef7dc77437a2a4cf247d4671682",
"assets/packages/flutter_tailwind_ui/fonts/Geist-Light.ttf": "27acd1886e661dca041eb211b8882222",
"assets/packages/flutter_tailwind_ui/fonts/Geist-Medium.ttf": "ca345dfc7f31610b5afdcbeba6e34717",
"assets/packages/flutter_tailwind_ui/fonts/Geist-Regular.ttf": "7d0f7be5b9c326afdaa60860a863ff6e",
"assets/packages/flutter_tailwind_ui/fonts/Geist-SemiBold.ttf": "9558c63980ec6c013c03e8a9ca38fa89",
"assets/packages/flutter_tailwind_ui/fonts/Geist-Thin.ttf": "62cec5ab8ccf1c22ecf43231aed1475f",
"assets/packages/flutter_tailwind_ui/fonts/JetBrainsMono-Bold.ttf": "8658ffe39dbfa1c12436789a50212180",
"assets/packages/flutter_tailwind_ui/fonts/JetBrainsMono-ExtraBold.ttf": "1e8904787ca346b750a6d425e543b6f8",
"assets/packages/flutter_tailwind_ui/fonts/JetBrainsMono-ExtraLight.ttf": "6ec36ffaff8fd3902485078869d8db14",
"assets/packages/flutter_tailwind_ui/fonts/JetBrainsMono-Light.ttf": "5f68b90fb3ae2b26792475f2e92f966a",
"assets/packages/flutter_tailwind_ui/fonts/JetBrainsMono-Medium.ttf": "b41d61d1b5a063fdcb6a7cdeacac57b0",
"assets/packages/flutter_tailwind_ui/fonts/JetBrainsMono-Regular.ttf": "d09f65145228b709a10fa0a06d522d89",
"assets/packages/flutter_tailwind_ui/fonts/JetBrainsMono-SemiBold.ttf": "fa952b0ebc58a82f6fcfff6250284bc7",
"assets/packages/flutter_tailwind_ui/fonts/JetBrainsMono-Thin.ttf": "4abec0295db416a000ea0d1dcec54964",
"assets/packages/flutter_tailwind_ui/grammar/css.json": "a5c68895e16ec1ffcabfc82ad78d8ff4",
"assets/packages/flutter_tailwind_ui/grammar/dart.json": "9f247370a264cacc52657e474a3938d2",
"assets/packages/flutter_tailwind_ui/grammar/html.json": "9f7597a6ec3a8593af627e216f4087c7",
"assets/packages/flutter_tailwind_ui/grammar/javascript.json": "afaa2964e32826a73d1176824beb53f9",
"assets/packages/flutter_tailwind_ui/grammar/json.json": "221281d40a1e467c85a04118f73f71fe",
"assets/packages/flutter_tailwind_ui/grammar/python.json": "5454a650e3d5a0bb91ea918775ea1dd1",
"assets/packages/flutter_tailwind_ui/grammar/shell.json": "ced747f7326af9342eaa075abeea266d",
"assets/packages/flutter_tailwind_ui/grammar/sql.json": "2b1733b9ce8f7fd195b4cde98067f1be",
"assets/packages/flutter_tailwind_ui/grammar/toml.json": "6f4ff8e4cb0e5911e5257eabfb2b53a5",
"assets/packages/flutter_tailwind_ui/grammar/xml.json": "2315428dd0a0fc88a8f62586a142be9b",
"assets/packages/flutter_tailwind_ui/grammar/yaml.json": "8828ad4ccb7867632614071f016a12f1",
"assets/packages/syntax_highlight/grammars/dart.json": "b533a238112e4038ed399e53ca050e33",
"assets/packages/syntax_highlight/grammars/json.json": "e608a2cc8f3ec86a5b4af4d7025ae43f",
"assets/packages/syntax_highlight/grammars/serverpod_protocol.json": "cc9b878a8ae5032ca4073881e5889fd5",
"assets/packages/syntax_highlight/grammars/sql.json": "957a963dfa0e8d634766e08c80e00723",
"assets/packages/syntax_highlight/grammars/yaml.json": "7c2dfa28161c688d8e09478a461f17bf",
"assets/packages/syntax_highlight/themes/dark_plus.json": "b212b7b630779cb4955e27a1c228bf71",
"assets/packages/syntax_highlight/themes/dark_vs.json": "2839d5be4f19e6b315582a36a6dcd1c3",
"assets/packages/syntax_highlight/themes/light_plus.json": "2a29ad892e1f54e93062fee13b3688c6",
"assets/packages/syntax_highlight/themes/light_vs.json": "8025deae1ca1a4d1cb803c7b9f8528a1",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"flutter_bootstrap.js": "1dde51eb22e0468efeca21fc75143b3b",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "f158a0efcfd01f6b42ec090d43a22c19",
"/": "f158a0efcfd01f6b42ec090d43a22c19",
"main.dart.js": "c52613735bbb36a8c54f0adf4f5eaf8b",
"manifest.json": "5dcd58f6494b1b136090627fc6edd8b8",
"version.json": "d0f62e0f21f926859ad26aefbe283a86"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
