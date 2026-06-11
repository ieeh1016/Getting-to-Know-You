(function () {
  if (window.jogeumssikKakaoMaps) {
    return;
  }

  const instances = new Map();
  let sdkPromise = null;

  function loadSdk(appKey) {
    if (!appKey) {
      return Promise.reject(new Error('Kakao Maps app key is empty.'));
    }

    if (window.kakao && window.kakao.maps) {
      return new Promise((resolve) => window.kakao.maps.load(resolve));
    }

    if (sdkPromise) {
      return sdkPromise;
    }

    sdkPromise = new Promise((resolve, reject) => {
      const script = document.createElement('script');
      script.async = true;
      script.dataset.jogeumssikKakaoSdk = 'true';
      script.src =
        'https://dapi.kakao.com/v2/maps/sdk.js?appkey=' +
        encodeURIComponent(appKey) +
        '&libraries=services&autoload=false';
      script.onload = () => {
        if (!window.kakao || !window.kakao.maps) {
          reject(new Error('Kakao Maps SDK loaded without kakao.maps.'));
          return;
        }
        window.kakao.maps.load(resolve);
      };
      script.onerror = () => reject(new Error('Kakao Maps SDK load failed.'));
      document.head.appendChild(script);
    });

    return sdkPromise;
  }

  function toNumber(value, fallback) {
    const number = Number(value);
    return Number.isFinite(number) ? number : fallback;
  }

  function clearMarkers(instance) {
    if (!instance || !instance.markers) {
      return;
    }
    instance.markers.forEach((marker) => marker.setMap(null));
    instance.markers = [];
  }

  function drawMarkers(instance, markerOptions) {
    clearMarkers(instance);
    const kakao = window.kakao;
    const bounds = new kakao.maps.LatLngBounds();
    let validMarkerCount = 0;

    markerOptions.forEach((markerOption) => {
      const latitude = toNumber(markerOption.latitude, NaN);
      const longitude = toNumber(markerOption.longitude, NaN);
      if (!Number.isFinite(latitude) || !Number.isFinite(longitude)) {
        return;
      }

      const position = new kakao.maps.LatLng(latitude, longitude);
      const marker = new kakao.maps.Marker({
        map: instance.map,
        position,
        title: markerOption.title || '',
      });
      instance.markers.push(marker);
      bounds.extend(position);
      validMarkerCount += 1;
    });

    if (validMarkerCount === 1) {
      instance.map.setCenter(bounds.getSouthWest());
    } else if (validMarkerCount > 1) {
      instance.map.setBounds(bounds);
    }
  }

  function renderMap(options) {
    return loadSdk(options.appKey).then(() => {
      const kakao = window.kakao;
      const element = document.getElementById(options.elementId);
      if (!element) {
        throw new Error('Kakao map container is missing.');
      }

      const center = new kakao.maps.LatLng(
        toNumber(options.centerLatitude, 37.5665),
        toNumber(options.centerLongitude, 126.9780)
      );
      let instance = instances.get(options.elementId);

      if (!instance) {
        const map = new kakao.maps.Map(element, {
          center,
          level: Math.max(1, toNumber(options.level, 6)),
        });
        map.addControl(
          new kakao.maps.ZoomControl(),
          kakao.maps.ControlPosition.RIGHT
        );
        instance = { map, markers: [] };
        instances.set(options.elementId, instance);
      } else {
        instance.map.setCenter(center);
        instance.map.setLevel(Math.max(1, toNumber(options.level, 6)));
      }

      instance.map.relayout();
      drawMarkers(instance, Array.isArray(options.markers) ? options.markers : []);
      return { ready: true };
    });
  }

  window.jogeumssikKakaoMaps = {
    renderMap,
    renderMapFromJson: (optionsJson) => renderMap(JSON.parse(optionsJson)),
  };
})();
