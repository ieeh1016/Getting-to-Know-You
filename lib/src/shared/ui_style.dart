import 'package:flutter/material.dart';

class AlagagiColors {
  static const outerBackground = Color(0xFFE9E8E2);
  static const appBackground = Color(0xFFF4F3EF);
  static const paper = Color(0xFFFCFCFA);
  static const ink = Color(0xFF2E2E2C);
  static const muted = Color(0xFF9A9890);
  static const sage = Color(0xFF8A9A7E);
  static const sageDeep = Color(0xFF6F7F63);
  static const lavender = Color(0xFFB9A8C9);
  static const line = Color(0xFFE8E6DF);
  static const softSage = Color(0xFFDFE6D4);
  static const sagePanel = Color(0xFFCDD6C2);
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
