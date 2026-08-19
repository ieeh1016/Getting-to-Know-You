// 여행 화면들이 함께 쓰는 표기 규칙.

/// 천 단위로 끊어 읽는다. 요약 카드와 항목 줄이 같은 모양을 쓴다.
String formatTripAmount(int amount) {
  final digits = amount.toString();
  final buffer = StringBuffer();
  for (var index = 0; index < digits.length; index += 1) {
    if (index > 0 && (digits.length - index) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(digits[index]);
  }
  return buffer.toString();
}
