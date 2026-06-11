# Flutter Web 지도 Open API 연동 가이드

이 문서는 Flutter Web에서 카카오 지도와 네이버 지도를 사용하기 전에 준비해야 할 콘솔 설정, 키 관리, 도메인 등록, JS SDK 로딩, 장소 검색, 마커 표시, 좌표 저장, 운영 보안 사항을 정리한다. 실제 키, 도메인, API 엔드포인트, 기본 좌표 같은 세부 값은 코드에 직접 쓰지 않고 환경변수, CI/CD 변수, 런타임 설정 파일로 주입한다.

## 공식 문서

- Kakao 지도 Web API 가이드: https://apis.map.kakao.com/web/guide/
- Kakao 지도 Web API Documentation: https://apis.map.kakao.com/web/documentation/
- Kakao Developers Console: https://developers.kakao.com/console/app
- NAVER 지도 API v3 기술 문서: https://navermaps.github.io/maps.js.ncp/docs/
- NAVER 지도 API v3 클라이언트 아이디 발급: https://navermaps.github.io/maps.js.ncp/docs/tutorial-1-Getting-Client-ID.html
- NAVER 지도 API v3 시작하기: https://navermaps.github.io/maps.js.ncp/docs/tutorial-2-Getting-Started.html
- NAVER 지도 API v3 Geocoder: https://navermaps.github.io/maps.js.ncp/docs/tutorial-Geocoder-Geocoding.html
- NAVER Cloud Console: https://console.ncloud.com
- NAVER Search API 지역 검색: https://developers.naver.com/docs/serviceapi/search/local/local.md

## 권장 구성

Flutter Web은 브라우저에서 실행되므로 지도 JS SDK 키는 사용자에게 노출된다. 카카오 JavaScript Key와 네이버 지도 `ncpKeyId`는 클라이언트에 노출되는 전제의 키로 보고, 반드시 콘솔에서 허용 도메인을 제한한다.

반대로 서버 인증 헤더가 필요한 키는 Flutter Web에 넣지 않는다. 특히 네이버 지역 검색 API의 `X-Naver-Client-Secret`은 브라우저에 노출하면 안 되므로 백엔드 프록시에서만 보관하고 호출한다. 카카오도 REST API를 직접 써야 하는 경우에는 CORS, quota, 키 노출 정책을 확인하고 가능하면 서버 프록시로 감싼다. 브라우저에서 장소 검색을 처리할 때는 카카오 지도 JS SDK의 `services` 라이브러리를 우선 사용한다.

예시 설정 이름은 다음처럼 분리한다.

```text
MAP_PROVIDER=kakao|naver|both
KAKAO_MAP_JS_KEY=<runtime injected>
NAVER_MAP_NCP_KEY_ID=<runtime injected>
MAP_SEARCH_PROXY_BASE_URL=<runtime injected>
DEFAULT_MAP_LAT=<runtime injected>
DEFAULT_MAP_LNG=<runtime injected>
DEFAULT_MAP_ZOOM=<runtime injected>
```

`--dart-define`은 빌드 산출물에 값이 포함될 수 있으므로 공개 가능한 지도 JS 키와 공개 설정에만 사용한다. 운영에서는 배포 플랫폼의 환경변수로 `web/env.js`, `assets/config.json`, 또는 서버 렌더링 템플릿을 생성해 런타임에 읽는 방식을 권장한다. 어떤 방식을 쓰더라도 실제 Secret은 Flutter Web 번들, Git 저장소, 정적 호스팅 파일에 넣지 않는다.

## 카카오 지도 준비

### 콘솔 설정

1. Kakao Developers Console에서 애플리케이션을 생성한다.
2. 앱 설정에서 플랫폼을 Web으로 추가한다.
3. Flutter Web이 실행될 모든 Origin을 사이트 도메인에 등록한다.
4. 앱 키 목록에서 JavaScript Key를 확인한다.
5. 지도 SDK에서 장소 검색이 필요하면 JS SDK 로딩 시 `libraries=services`를 포함한다.

도메인은 프로토콜, 호스트, 포트까지 실제 접속 Origin과 맞춘다. 로컬 개발에서 포트가 바뀌면 `http://localhost:<port>`와 `http://127.0.0.1:<port>`를 각각 등록해야 할 수 있다. 개발, 스테이징, 운영 도메인은 별도로 등록하고 운영은 HTTPS 도메인만 허용한다.

현재 앱은 `KAKAO_MAP_JS_KEY` dart-define이 있으면 장소 화면의 지도 영역에서 카카오 지도 SDK를 로드한다. 키가 없거나 등록되지 않은 Origin이면 기존 미리보기 UI가 유지된다.

```bash
flutter run -d chrome --web-port=8097 --dart-define=KAKAO_MAP_JS_KEY=<KAKAO_JAVASCRIPT_KEY>
```

배포 빌드는 같은 값을 build 시점에 넣는다.

```bash
flutter build web --dart-define=KAKAO_MAP_JS_KEY=<KAKAO_JAVASCRIPT_KEY>
```

위 명령을 쓰면 Kakao Developers Console의 JavaScript SDK 도메인에 `http://localhost:8097` 또는 브라우저가 실제로 접근하는 `http://127.0.0.1:8097`을 등록한다. 운영 배포에는 운영 도메인만 등록하고, REST API 키나 Admin 키는 Flutter Web 빌드 산출물에 포함하지 않는다.

GitHub Pages 자동 배포는 `.github/workflows/deploy.yml`에서 `secrets.KAKAO_MAP_JS_KEY`를 읽는다. GitHub 저장소 설정에는 Secret 이름을 `KAKAO_MAP_JS_KEY`로 등록한다.

### JS SDK 로딩

Flutter Web에서는 `web/index.html`에 고정 스크립트를 넣을 수도 있지만, 키를 런타임 설정으로 주입하려면 Dart 또는 작은 bootstrap JS에서 동적으로 로드하는 편이 관리하기 쉽다.

```text
https://dapi.kakao.com/v2/maps/sdk.js?appkey=<KAKAO_MAP_JS_KEY>&libraries=services&autoload=false
```

`autoload=false`를 사용하면 스크립트 삽입 완료 후 `kakao.maps.load(callback)`에서 지도 객체를 생성한다. 이렇게 하면 SDK가 완전히 준비되기 전에 `kakao.maps.Map`, `kakao.maps.services.Places`에 접근하는 문제를 줄일 수 있다.

```javascript
function loadKakaoMapSdk(kakaoMapJsKey, onReady) {
  if (window.kakao && window.kakao.maps) {
    window.kakao.maps.load(onReady);
    return;
  }

  const script = document.createElement('script');
  script.src =
    'https://dapi.kakao.com/v2/maps/sdk.js'
    + '?appkey=' + encodeURIComponent(kakaoMapJsKey)
    + '&libraries=services'
    + '&autoload=false';
  script.onload = () => window.kakao.maps.load(onReady);
  script.onerror = () => console.error('Kakao Maps SDK load failed');
  document.head.appendChild(script);
}
```

### 지도, 장소 검색, 마커

카카오 장소 검색은 `services` 라이브러리의 `Places.keywordSearch`를 사용한다. 결과의 `x`는 경도, `y`는 위도 문자열이므로 저장 전에 숫자로 변환하고, 지도에는 `new kakao.maps.LatLng(Number(y), Number(x))` 순서로 전달한다.

```javascript
function searchKakaoPlace(map, keyword, onSelect) {
  const places = new kakao.maps.services.Places();

  places.keywordSearch(keyword, (results, status) => {
    if (status !== kakao.maps.services.Status.OK) {
      onSelect({ ok: false, reason: status });
      return;
    }

    const place = results[0];
    const lat = Number(place.y);
    const lng = Number(place.x);
    const position = new kakao.maps.LatLng(lat, lng);

    const marker = new kakao.maps.Marker({
      map,
      position,
      title: place.place_name,
    });

    map.setCenter(position);
    onSelect({
      ok: true,
      provider: 'kakao',
      providerPlaceId: place.id,
      name: place.place_name,
      roadAddress: place.road_address_name,
      jibunAddress: place.address_name,
      lat,
      lng,
      marker,
    });
  });
}
```

사용자가 지도를 클릭해 좌표를 직접 선택하는 플로우라면 `kakao.maps.event.addListener(map, 'click', handler)`에서 `mouseEvent.latLng.getLat()`와 `mouseEvent.latLng.getLng()`를 읽어 같은 저장 모델로 정규화한다.

## 네이버 지도 준비

### 콘솔 설정

1. NAVER Cloud Console에서 `Service > Application Services > Maps > Application`으로 이동한다.
2. 애플리케이션을 생성하고 `Dynamic Map` 사용 여부를 확인한다.
3. 발급된 지도용 Client ID, 즉 JS SDK 로딩에 쓰는 `ncpKeyId`를 런타임 설정으로 관리한다.
4. Flutter Web이 실행될 모든 Web service URL을 등록한다.
5. Geocoder를 쓸 경우 해당 기능의 사용량, 과금, 일일 허용량을 함께 확인한다.

네이버 지도 JS SDK와 NAVER Search API 지역 검색은 인증 체계가 다르다. 지도 표시와 마커는 NAVER Cloud Maps의 `ncpKeyId`를 사용한다. 키워드 기반 업체/기관 검색이 필요하면 NAVER Developers에서 Search API를 사용하는 애플리케이션을 별도로 등록하고, Client ID와 Client Secret은 백엔드 프록시에만 둔다.

### JS SDK 로딩

지도만 표시할 때는 `ncpKeyId`로 SDK를 로드한다.

```text
https://oapi.map.naver.com/openapi/v3/maps.js?ncpKeyId=<NAVER_MAP_NCP_KEY_ID>
```

주소-좌표 변환을 브라우저 SDK에서 호출하려면 `geocoder` 서브 모듈을 포함한다.

```text
https://oapi.map.naver.com/openapi/v3/maps.js?ncpKeyId=<NAVER_MAP_NCP_KEY_ID>&submodules=geocoder&callback=<GLOBAL_CALLBACK>
```

네이버 문서의 인증 실패 핸들러를 전역에 정의해 두면 운영 장애를 빨리 감지할 수 있다.

```javascript
window.navermap_authFailure = function () {
  console.error('NAVER Maps authentication failed');
};
```

### 지도, 장소 검색, 마커

지도와 마커는 JS SDK에서 바로 처리한다.

```javascript
function createNaverMarker(map, place) {
  const position = new naver.maps.LatLng(place.lat, place.lng);

  const marker = new naver.maps.Marker({
    map,
    position,
    title: place.name,
  });

  map.setCenter(position);
  return marker;
}
```

장소 검색은 목적에 따라 두 경로로 나눈다.

- 주소 검색이면 `submodules=geocoder`를 포함하고 `naver.maps.Service.geocode({ query })`로 WGS84 위경도를 얻는다.
- 업체/기관 키워드 검색이면 Flutter Web에서 NAVER Search API를 직접 호출하지 말고 백엔드의 `/map/search/naver` 같은 프록시를 호출한다. 프록시는 `X-Naver-Client-Id`, `X-Naver-Client-Secret`을 서버 환경변수에서 읽어 NAVER Search API 지역 검색을 호출하고, 응답을 앱의 장소 모델로 정규화해 반환한다.

지역 검색 응답의 `mapx`, `mapy`는 API 버전과 좌표계 해석을 반드시 공식 레퍼런스와 실제 응답으로 검증한다. 지도 저장 모델에는 `mapx`, `mapy`를 그대로 저장하지 말고 WGS84 `lat`, `lng` double 값으로 정규화해서 저장한다. 가장 안전한 방식은 지역 검색 결과의 `roadAddress` 또는 `address`를 Geocoder로 다시 변환해 위경도를 얻는 것이다. 기존 좌표 필드를 활용해야 한다면 `naver.maps.TransCoord` 또는 서버 측 좌표 변환 로직으로 명시적인 좌표계 변환을 거친 뒤 지도에 표시한다.

## Flutter Web 통합 방식

지도 SDK는 실제 DOM 요소를 요구한다. Flutter Web에서는 지도 영역을 `HtmlElementView`로 노출하고, SDK 초기화는 해당 DOM이 생성된 뒤 실행한다. 웹 전용 코드가 필요하므로 모바일 빌드까지 같은 소스를 공유한다면 conditional import로 분리한다.

```dart
// 웹 전용 예시. 실제 구현에서는 conditional import로 격리한다.
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

void registerMapView(String viewType, String elementId) {
  ui_web.platformViewRegistry.registerViewFactory(
    viewType,
    (int viewId) => html.DivElement()
      ..id = elementId
      ..style.width = '100%'
      ..style.height = '100%',
  );
}
```

탭, 바텀시트, 다이얼로그처럼 처음에는 숨겨진 영역에 지도를 만들면 컨테이너 크기가 0으로 계산될 수 있다. 영역이 표시된 뒤 카카오는 `map.relayout()`과 `map.setCenter(center)`, 네이버는 컨테이너 크기 변경 후 `map.setSize(...)` 또는 재초기화 전략을 적용한다.

SDK 로더는 같은 스크립트를 중복 삽입하지 않도록 `id` 또는 전역 Promise로 한 번만 실행한다. Provider를 런타임 설정으로 선택할 수 있게 만들면 카카오와 네이버를 동시에 번들링하지 않고 필요한 SDK만 로드할 수 있다.

## 저장 모델

저장소에는 지도 제공자별 원본 응답을 그대로 밀어 넣기보다 앱에서 쓰는 공통 모델로 정규화한다.

```text
provider: kakao|naver|manual
providerPlaceId: <provider place id or null>
name: <place name>
category: <normalized category or provider category>
roadAddress: <road address or null>
jibunAddress: <jibun address or null>
lat: <WGS84 latitude double>
lng: <WGS84 longitude double>
source: keyword_search|address_search|map_click|manual_input
searchedKeyword: <optional>
selectedAt: <ISO-8601 timestamp>
rawProviderPayloadRef: <optional debug/storage reference>
```

좌표는 항상 WGS84 위도/경도 double로 저장한다. 화면 표시용 줌 레벨, 지도 Provider, 마커 스타일은 좌표와 분리해서 저장한다. 원본 API 응답 전체를 저장해야 한다면 개인정보, 불필요한 HTML 태그, 제공자 약관, 보관 기간을 검토하고 별도 디버그 필드나 서버 로그로 제한한다.

## 백엔드 프록시 권장 형태

네이버 지역 검색처럼 Secret이 필요한 API는 다음 형태로 백엔드에서 처리한다.

```text
GET /map/search/naver?query=<keyword>

Server env:
NAVER_SEARCH_CLIENT_ID=<secret runtime env>
NAVER_SEARCH_CLIENT_SECRET=<secret runtime env>
```

프록시 응답은 프론트엔드가 바로 마커를 찍을 수 있도록 정규화한다.

```json
{
  "items": [
    {
      "provider": "naver",
      "providerPlaceId": null,
      "name": "장소명",
      "roadAddress": "도로명 주소",
      "jibunAddress": "지번 주소",
      "lat": 37.0,
      "lng": 127.0,
      "source": "keyword_search"
    }
  ]
}
```

프록시는 CORS 허용 Origin을 서비스 도메인으로 제한하고, 사용자 입력 검색어의 길이 제한, rate limit, 캐시, 에러 표준화, quota 초과 알림을 둔다.

## 운영 보안 체크리스트

- 클라이언트에 노출되는 카카오 JavaScript Key와 네이버 `ncpKeyId`는 콘솔에서 허용 도메인을 최소화한다.
- 네이버 Search API Client Secret, 서버용 REST 키, 관리자 토큰은 Flutter Web 코드와 정적 파일에 넣지 않는다.
- 로컬 개발 도메인, 스테이징 도메인, 운영 도메인을 분리하고 운영 키에는 개발 도메인을 등록하지 않는다.
- 사용하지 않는 플랫폼과 API 권한은 끈다.
- 키는 팀 계정 또는 조직 계정으로 발급하고 소유자 퇴사, 계정 잠금에 대비한다.
- 키 회전 절차를 문서화하고 이전 키와 새 키를 동시에 허용하는 전환 기간을 짧게 둔다.
- 지도 사용량, Geocoder 사용량, 지역 검색 사용량에 quota 알림과 비용 알림을 설정한다.
- CSP를 적용할 경우 `script-src`와 네트워크 정책에 카카오/네이버 지도 SDK 및 지도 타일, 이미지, API 도메인이 허용되어 있는지 브라우저 네트워크 탭으로 검증한다.
- 좌표가 특정 사용자와 결합되면 개인정보 또는 민감한 위치 정보가 될 수 있으므로 수집 목적, 보관 기간, 삭제 정책, 접근 권한을 명확히 한다.
- 장소명, 주소, 검색어를 로그에 남길 때는 개인정보 포함 가능성을 고려해 마스킹 또는 보관 기간 제한을 적용한다.
- 지도 제공자의 로고, 저작권 표시, 이용약관, 캐싱 제한을 지운 채로 UI를 커스터마이징하지 않는다.
- 인증 실패를 운영 로그로 잡는다. 카카오는 SDK 로드 실패와 콘솔 오류를, 네이버는 `window.navermap_authFailure`와 SDK 로드 실패를 별도 이벤트로 남긴다.

## 개발 검증 순서

1. 등록된 로컬 Origin에서 SDK가 정상 로드되는지 확인한다.
2. 등록되지 않은 Origin에서 인증 실패가 나는지 확인한다.
3. 카카오 `services` 장소 검색 결과의 `x`, `y`를 `lng`, `lat` 순서로 잘 변환하는지 테스트한다.
4. 네이버 지도 `ncpKeyId`와 Search API Client ID/Secret을 혼동하지 않는지 확인한다.
5. 네이버 지역 검색 결과가 WGS84 `lat`, `lng`로 정규화된 뒤 저장되는지 확인한다.
6. 지도 컨테이너가 숨겨졌다 표시되는 화면에서 resize/relayout 처리가 되는지 확인한다.
7. 배포 빌드 산출물에 서버 Secret이 포함되지 않았는지 검색한다.
8. 운영 도메인에서 quota, CSP, CORS, 인증 실패 로그가 정상 동작하는지 확인한다.
