import 'package:flutter/material.dart';

/// 앱 전체 팔레트는 warm yellow(버터 크림 배경 + 오커 accent) 계열이다.
///
/// `sky`, `blue`, `sage` 같은 token 이름은 이전 sky-blue 팔레트에서 이어진 것이고
/// 값만 yellow 계열로 옮겼다. 이름이 아니라 역할로 읽는다.
/// - 배경: [appBackground], [outerBackground]
/// - 카드/표면: [paper], [skyPanel], [goldSoft]
/// - 주 accent: [sageDeep] (label, icon, 강조 text)
/// - 보조 accent: [gold], [sky], [lavender]
class AlagagiColors {
  static const outerBackground = Color(0xFFF9F1D8);
  static const appBackground = Color(0xFFFDF9EA);
  static const paper = Color(0xFFFFFDF7);
  static const ink = Color(0xFF2F2E2A);
  static const muted = Color(0xFF8C8069);
  static const line = Color(0xFFEFE1BE);
  static const sage = Color(0xFF9C8952);
  static const sageDeep = Color(0xFF8A6B1E);
  static const sageSoft = Color(0xFFFDF9EA);
  static const lavender = Color(0xFF9F8AB6);
  static const lavenderSoft = Color(0xFFF0EDF4);
  static const rose = Color(0xFFB78378);
  static const roseSoft = Color(0xFFF5E8E4);
  static const clay = Color(0xFFB18472);
  static const claySoft = Color(0xFFFDFAEF);
  static const gold = Color(0xFFC1922C);
  static const goldSoft = Color(0xFFFCF5DE);
  static const blue = Color(0xFF9A8C6B);
  static const blueSoft = Color(0xFFF1EFE7);
  static const sky = Color(0xFFDDB95E);
  static const skySoft = Color(0xFFFDF9EA);
  static const skyPanel = Color(0xFFFAF3DC);
  static const midnight = Color(0xFF2B2A25);
  static const moss = Color(0xFF635A4A);
  static const blush = Color(0xFFD8A49A);
  static const pearl = Color(0xFFFFFCF5);
  static const creamPanel = Color(0xFFFDFAEF);
  static const warm = Color(0xFFFFFCF5);
  static const softSage = sageSoft;
  static const sagePanel = Color(0xFFFAF3DC);
}

/// 카드 형태는 두 가지만 쓴다.
///
/// - 기본: 화면의 주요 카드. radius 22, padding 17.
/// - compact: 목록 안에 촘촘히 놓이는 카드. radius 18, padding 14.
///
/// 화면마다 다른 radius/padding을 새로 만들지 않는다.
class AlagagiCardGeometry {
  static const double radius = 22;
  static const double compactRadius = 18;
  static const EdgeInsets padding = EdgeInsets.all(17);
  static const EdgeInsets compactPadding = EdgeInsets.all(14);
}

const alagagiSansFonts = [
  'Apple SD Gothic Neo',
  'Noto Sans CJK KR',
  'Noto Sans KR',
  'Malgun Gothic',
  'Arial Unicode MS',
  'Apple Color Emoji',
];

const alagagiSerifFonts = [
  'Nanum Myeongjo',
  'AppleMyungjo',
  'Noto Serif CJK KR',
  'Noto Serif KR',
  'Apple SD Gothic Neo',
  'Noto Sans CJK KR',
  'Apple Color Emoji',
];

TextStyle serif(
  BuildContext context, {
  double? size,
  FontWeight? weight,
  Color? color,
  double? height,
}) {
  return TextStyle(
    fontFamily: 'Nanum Myeongjo',
    fontFamilyFallback: alagagiSerifFonts,
    fontSize: size,
    fontWeight: weight,
    color: color ?? AlagagiColors.ink,
    height: height,
    letterSpacing: 0,
  );
}

TextStyle sans({
  double? size,
  FontWeight? weight,
  Color? color,
  double? height,
  double? letterSpacing,
}) {
  return TextStyle(
    fontFamily: 'Apple SD Gothic Neo',
    fontFamilyFallback: alagagiSansFonts,
    fontSize: size,
    fontWeight: weight,
    color: color ?? AlagagiColors.ink,
    height: height,
    letterSpacing: letterSpacing ?? 0,
  );
}
