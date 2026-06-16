import '../../domain/alagagi_controller.dart';

String questionDateContext(String? dateKey, DailyQuestion question) {
  final date = dateKey == null ? null : DateTime.tryParse(dateKey);
  if (date == null) {
    return 'DAY ${question.day}';
  }
  return '${date.month}월 ${date.day}일 · DAY ${question.day}';
}
