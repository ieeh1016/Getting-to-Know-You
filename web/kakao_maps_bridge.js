(function () {
  if (window.jogeumssikKakaoMaps) {
    return;
  }

  const instances = new Map();
  let sdkPromise = null;

  function createKakaoError(message, code, details) {
    const metadata = [code, details && details.status ? 'status=' + details.status : '']
      .filter(Boolean)
      .join(', ');
    const fullMessage = metadata ? message + ' [' + metadata + ']' : message;
    const error = new Error(fullMessage);
    error.name = 'JogeumssikKakaoMapError';
    error.code = code;
    error.userMessage = fullMessage;
    if (details && details.status) {
      error.status = details.status;
    }
    return error;
  }

  function asKakaoError(error, code, fallbackMessage, details) {
    if (error && error.name === 'JogeumssikKakaoMapError') {
      return error;
    }
    const message =
      error && error.message ? fallbackMessage + ' (' + error.message + ')' : fallbackMessage;
    return createKakaoError(message, code, details);
  }

  function loadKakaoMaps(resolve, reject) {
    if (!window.kakao || !window.kakao.maps || !window.kakao.maps.load) {
      reject(
        createKakaoError(
          'Kakao Maps SDK가 kakao.maps.load를 제공하지 않습니다. 앱 키와 허용 도메인을 확인해주세요.',
          'SDK_LOAD_MISSING'
        )
      );
      return;
    }
    try {
      window.kakao.maps.load(resolve);
    } catch (error) {
      reject(
        asKakaoError(
          error,
          'SDK_INIT_FAILED',
          'Kakao Maps SDK 초기화 중 오류가 발생했습니다. 앱 키와 허용 도메인을 확인해주세요.'
        )
      );
    }
  }

  function loadSdk(appKey) {
    if (!appKey) {
      return Promise.reject(
        createKakaoError('Kakao Maps JavaScript 키가 비어 있습니다.', 'APP_KEY_EMPTY')
      );
    }

    if (window.kakao && window.kakao.maps) {
      return new Promise(loadKakaoMaps);
    }

    if (sdkPromise) {
      return sdkPromise;
    }

    const pendingSdkPromise = new Promise((resolve, reject) => {
      const script = document.createElement('script');
      script.async = true;
      script.dataset.jogeumssikKakaoSdk = 'true';
      script.src =
        'https://dapi.kakao.com/v2/maps/sdk.js?appkey=' +
        encodeURIComponent(appKey) +
        '&libraries=services&autoload=false';
      script.onload = () => {
        if (!window.kakao || !window.kakao.maps) {
          script.remove();
          reject(
            createKakaoError(
              'Kakao Maps SDK는 로드됐지만 kakao.maps가 없습니다. JavaScript 키, 허용 도메인, services 라이브러리 설정을 확인해주세요.',
              'SDK_LOAD_MISSING'
            )
          );
          return;
        }
        loadKakaoMaps(resolve, reject);
      };
      script.onerror = () => {
        script.remove();
        reject(
          createKakaoError(
            'Kakao Maps SDK 스크립트 로드 실패. 네트워크, CSP, JavaScript 키, 허용 도메인을 확인해주세요.',
            'SDK_SCRIPT_LOAD_FAILED'
          )
        );
      };
      document.head.appendChild(script);
    });

    const retryableSdkPromise = pendingSdkPromise.catch((error) => {
      if (sdkPromise === retryableSdkPromise) {
        sdkPromise = null;
      }
      throw error;
    });
    sdkPromise = retryableSdkPromise;
    return sdkPromise;
  }

  function toNumber(value, fallback) {
    const number = Number(value);
    return Number.isFinite(number) ? number : fallback;
  }

  function containMapScroll(element) {
    if (element.dataset.jogeumssikMapScrollContained === 'true') {
      return;
    }
    element.dataset.jogeumssikMapScrollContained = 'true';

    const applyMapGestureStyles = (target) => {
      target.style.overscrollBehavior = 'contain';
      target.style.touchAction = 'none';
      target.style.userSelect = 'none';
    };
    const applyMapGestureStylesDeep = () => {
      applyMapGestureStyles(element);
      element.querySelectorAll('*').forEach(applyMapGestureStyles);
    };
    const containWheelScroll = (event) => {
      event.preventDefault();
      event.stopPropagation();
    };
    const stopGestureStartPropagation = (event) => {
      event.stopPropagation();
    };
    const markInteraction = () => {
      element.dataset.jogeumssikMapInteractedAt = String(Date.now());
    };

    applyMapGestureStylesDeep();
    const styleObserver = new MutationObserver(applyMapGestureStylesDeep);
    styleObserver.observe(element, { childList: true, subtree: true });

    ['wheel', 'mousewheel', 'DOMMouseScroll'].forEach((type) => {
      element.addEventListener(type, containWheelScroll, { passive: false });
    });
    // Kakao Maps relies on move events for panning, so only the gesture start is
    // stopped from reaching the Flutter page scroll layer.
    ['touchstart', 'pointerdown', 'mousedown'].forEach((type) => {
      element.addEventListener(type, stopGestureStartPropagation, { passive: true });
    });
    ['wheel', 'touchstart', 'pointerdown', 'mousedown'].forEach((type) => {
      element.addEventListener(type, markInteraction, { passive: true });
    });
  }

  function applyLightMapSurface(element) {
    element.style.backgroundColor = '#F7FCFF';
    element.style.colorScheme = 'light';
    element.style.filter = 'none';
    element.style.mixBlendMode = 'normal';
    element.style.opacity = '1';
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
      if (!markerOption) {
        return;
      }
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

  function refreshMapInstance(instance, center, level, markerOptions) {
    instance.map.relayout();
    instance.map.setCenter(center);
    instance.map.setLevel(level);
    drawMarkers(instance, markerOptions);
  }

  function scheduleOneSettlingRefresh(elementId, instance, renderId, center, level, markerOptions) {
    const scheduledAt = Date.now();
    window.setTimeout(() => {
      const element = document.getElementById(elementId);
      if (
        !element ||
        instances.get(elementId) !== instance ||
        instance.renderId !== renderId ||
        Number(element.dataset.jogeumssikMapInteractedAt || 0) > scheduledAt
      ) {
        return;
      }
      refreshMapInstance(instance, center, level, markerOptions);
    }, 450);
  }

  function renderMap(options) {
    return loadSdk(options.appKey).then(() => {
      const kakao = window.kakao;
      const element = document.getElementById(options.elementId);
      if (!element) {
        throw createKakaoError(
          '지도 컨테이너를 찾을 수 없습니다. Flutter HTML view가 생성된 뒤 다시 시도해주세요.',
          'MAP_CONTAINER_MISSING'
        );
      }
      applyLightMapSurface(element);
      containMapScroll(element);

      try {
        const center = new kakao.maps.LatLng(
          toNumber(options.centerLatitude, 37.5665),
          toNumber(options.centerLongitude, 126.9780)
        );
        let instance = instances.get(options.elementId);
        const level = Math.max(1, toNumber(options.level, 6));
        const markerOptions = Array.isArray(options.markers) ? options.markers : [];

        if (!instance) {
          const map = new kakao.maps.Map(element, {
            center,
            level,
          });
          if (kakao.maps.MapTypeId && kakao.maps.MapTypeId.ROADMAP) {
            map.setMapTypeId(kakao.maps.MapTypeId.ROADMAP);
          }
          map.addControl(
            new kakao.maps.ZoomControl(),
            kakao.maps.ControlPosition.RIGHT
          );
          instance = { map, markers: [], renderId: 0 };
          instances.set(options.elementId, instance);
        }

        const renderId = instance.renderId + 1;
        instance.renderId = renderId;
        refreshMapInstance(instance, center, level, markerOptions);
        scheduleOneSettlingRefresh(options.elementId, instance, renderId, center, level, markerOptions);
        return { ready: true };
      } catch (error) {
        throw asKakaoError(
          error,
          'MAP_RENDER_FAILED',
          '지도 렌더링 중 오류가 발생했습니다. 좌표 값, 컨테이너 크기, Kakao 도메인 설정을 확인해주세요.'
        );
      }
    });
  }

  function normalizePlace(place) {
    return {
      id: place.id || '',
      name: place.place_name || '',
      address: place.road_address_name || place.address_name || '',
      roadAddress: place.road_address_name || '',
      latitude: toNumber(place.y, null),
      longitude: toNumber(place.x, null),
      categoryName: place.category_name || '',
      categoryGroupCode: place.category_group_code || '',
    };
  }

  function searchPlaces(options) {
    const keyword = String(options.keyword || '').trim();
    if (keyword.length < 2) {
      return Promise.resolve([]);
    }

    return loadSdk(options.appKey).then(() => {
      const kakao = window.kakao;
      if (
        !kakao.maps.services ||
        !kakao.maps.services.Places ||
        !kakao.maps.services.Status
      ) {
        throw createKakaoError(
          'Kakao Places 서비스가 준비되지 않았습니다. SDK services 라이브러리 로드를 확인해주세요.',
          'PLACES_SERVICE_MISSING'
        );
      }
      return new Promise((resolve, reject) => {
        try {
          const places = new kakao.maps.services.Places();
          places.keywordSearch(
            keyword,
            (data, status) => {
              if (status === kakao.maps.services.Status.OK) {
                resolve(data.slice(0, 8).map(normalizePlace));
                return;
              }
              if (status === kakao.maps.services.Status.ZERO_RESULT) {
                resolve([]);
                return;
              }
              reject(
                createKakaoError(
                  'Kakao 장소 검색 실패. 네트워크, JavaScript 키, 허용 도메인, 쿼터를 확인해주세요.',
                  'PLACE_SEARCH_FAILED',
                  { status: status || 'UNKNOWN' }
                )
              );
            },
            { size: 8 }
          );
        } catch (error) {
          reject(
            asKakaoError(
              error,
              'PLACE_SEARCH_FAILED',
              'Kakao 장소 검색 요청 중 오류가 발생했습니다. services 라이브러리와 검색어를 확인해주세요.'
            )
          );
        }
      });
    });
  }

  function promiseFromJson(optionsJson, handler, errorCode) {
    try {
      return handler(JSON.parse(optionsJson));
    } catch (error) {
      return Promise.reject(
        asKakaoError(
          error,
          errorCode,
          'Kakao Maps 요청 옵션을 해석하지 못했습니다.'
        )
      );
    }
  }

  window.jogeumssikKakaoMaps = {
    renderMap,
    renderMapFromJson: (optionsJson) =>
      promiseFromJson(optionsJson, renderMap, 'MAP_OPTIONS_PARSE_FAILED'),
    searchPlaces,
    searchPlacesFromJson: (optionsJson) =>
      promiseFromJson(optionsJson, searchPlaces, 'SEARCH_OPTIONS_PARSE_FAILED').then(
        (results) => JSON.stringify(results)
      ),
  };
})();
