import 'package:flutter/material.dart';

import 'ui_style.dart';

/// 되돌릴 수 없는 동작 앞에 한 번 묻는다.
///
/// 아이콘 한 번으로 사라지는 것이 없어야 한다. 여행, 항목, 사진 모두
/// 같은 sheet를 쓴다.
Future<bool> showAlagagiConfirmSheet(
  BuildContext context, {
  required String title,
  required String body,
  required String confirmLabel,
  required Key confirmKey,
}) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) => AlagagiConfirmSheet(
      title: title,
      body: body,
      confirmLabel: confirmLabel,
      confirmKey: confirmKey,
      onConfirm: () => Navigator.of(sheetContext).pop(true),
      onCancel: () => Navigator.of(sheetContext).pop(false),
    ),
  );
  return result ?? false;
}

/// 확인을 거친 뒤에만 지운다. 대부분의 삭제가 이 모양이라 한 줄로 줄인다.
Future<void> confirmThenDelete(
  BuildContext context, {
  required String title,
  String body = '지우면 되돌릴 수 없어요.',
  String confirmLabel = '지우기',
  required Key confirmKey,
  required VoidCallback onConfirmed,
}) async {
  final confirmed = await showAlagagiConfirmSheet(
    context,
    title: title,
    body: body,
    confirmLabel: confirmLabel,
    confirmKey: confirmKey,
  );
  if (confirmed) {
    onConfirmed();
  }
}

class AlagagiConfirmSheet extends StatelessWidget {
  const AlagagiConfirmSheet({
    super.key,
    required this.title,
    required this.body,
    required this.confirmLabel,
    required this.confirmKey,
    required this.onConfirm,
    required this.onCancel,
  });

  final String title;
  final String body;
  final String confirmLabel;
  final Key confirmKey;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        decoration: BoxDecoration(
          color: AlagagiColors.paper,
          border: Border.all(color: AlagagiColors.line),
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: serif(context, size: 17, weight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text(
              body,
              style: sans(size: 12.5, height: 1.6, color: AlagagiColors.muted),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton(
                      onPressed: onCancel,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AlagagiColors.muted,
                        side: const BorderSide(color: AlagagiColors.line),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        textStyle: sans(size: 13, weight: FontWeight.w700),
                      ),
                      child: const Text('그대로 두기'),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: FilledButton(
                      key: confirmKey,
                      onPressed: onConfirm,
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFB35A49),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        textStyle: sans(size: 13, weight: FontWeight.w800),
                      ),
                      child: Text(confirmLabel),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
