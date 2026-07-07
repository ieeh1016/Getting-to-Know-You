import 'package:flutter/material.dart';

class AlagagiColors {
  static const outerBackground = Color(0xFFD9EEF8);
  static const appBackground = Color(0xFFEAF7FD);
  static const paper = Color(0xFFF7FCFF);
  static const ink = Color(0xFF2F2E2A);
  static const muted = Color(0xFF6F8794);
  static const line = Color(0xFFCFE6F1);
  static const sage = Color(0xFF819174);
  static const sageDeep = Color(0xFF5F7156);
  static const sageSoft = Color(0xFFEAF7FD);
  static const lavender = Color(0xFF9F8AB6);
  static const lavenderSoft = Color(0xFFF0EDF4);
  static const rose = Color(0xFFB78378);
  static const roseSoft = Color(0xFFF5E8E4);
  static const clay = Color(0xFFB18472);
  static const claySoft = Color(0xFFEFF8FD);
  static const gold = Color(0xFF4F95B8);
  static const goldSoft = Color(0xFFDFF2FB);
  static const blue = Color(0xFF718EA1);
  static const blueSoft = Color(0xFFE7EEF1);
  static const sky = Color(0xFF86B9D6);
  static const skySoft = Color(0xFFEAF7FD);
  static const skyPanel = Color(0xFFDDF0F9);
  static const midnight = Color(0xFF2B2A25);
  static const moss = Color(0xFF55654F);
  static const blush = Color(0xFFD8A49A);
  static const pearl = Color(0xFFF5FCFF);
  static const creamPanel = Color(0xFFEFF8FD);
  static const warm = Color(0xFFF5FCFF);
  static const softSage = sageSoft;
  static const sagePanel = Color(0xFFDDF0F9);
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
