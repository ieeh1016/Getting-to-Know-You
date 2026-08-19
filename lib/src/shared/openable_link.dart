/// 사용자가 적은 링크를 밖으로 열어도 되는 형태로 다듬는다.
///
/// scheme을 안 적는 사람이 많아 `booking.com/xyz`를 그대로 열면 앱 안의
/// 상대 경로가 열린다. `http`/`https`가 아닌 것은 아예 열지 않는다.
/// 열 수 없는 값이면 null을 돌려주고, 화면은 그때 button을 만들지 않는다.
String? normalizedOpenableLink(String rawLink) {
  final trimmed = rawLink.trim();
  if (trimmed.isEmpty) {
    return null;
  }

  final hasScheme = RegExp(r'^[a-zA-Z][a-zA-Z0-9+.-]*:').hasMatch(trimmed);
  final candidate = hasScheme ? trimmed : 'https://$trimmed';
  final uri = Uri.tryParse(candidate);
  if (uri == null || uri.host.trim().isEmpty) {
    return null;
  }

  final scheme = uri.scheme.toLowerCase();
  if (scheme != 'http' && scheme != 'https') {
    return null;
  }

  return uri.toString();
}
