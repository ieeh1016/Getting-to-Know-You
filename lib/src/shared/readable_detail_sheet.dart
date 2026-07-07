import 'package:flutter/material.dart';

import '../app/test_keys.dart';
import 'ui_style.dart';

const int alagagiReadablePreviewLength = 120;

bool showsReadableCue(
  String body, {
  int threshold = alagagiReadablePreviewLength,
  bool expanded = false,
}) => !expanded && body.trim().length > threshold;

void showReadableDetailSheet(
  BuildContext context, {
  required String label,
  required String title,
  required String body,
  String? meta,
  String? actionLabel,
  VoidCallback? onAction,
}) {
  final trimmedMeta = meta?.trim();
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return DraggableScrollableSheet(
        initialChildSize: 0.62,
        minChildSize: 0.34,
        maxChildSize: 0.88,
        expand: false,
        builder: (_, scrollController) {
          return SafeArea(
            child: Container(
              key: readableDetailSheetKey,
              margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              decoration: BoxDecoration(
                color: AlagagiColors.paper,
                border: Border.all(color: AlagagiColors.line),
                borderRadius: BorderRadius.circular(28),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x2E2C2B25),
                    blurRadius: 44,
                    offset: Offset(0, 18),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD7D5CC),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFEFF8FD), AlagagiColors.paper],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _ReadableDetailMark(label: label),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    label,
                                    style: sans(
                                      size: 10.5,
                                      weight: FontWeight.w800,
                                      color: AlagagiColors.sageDeep,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    title,
                                    style: serif(
                                      sheetContext,
                                      size: 19.5,
                                      weight: FontWeight.w800,
                                      height: 1.43,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            _ReadableDetailCloseButton(
                              onPressed: () => Navigator.of(sheetContext).pop(),
                            ),
                          ],
                        ),
                        if (trimmedMeta != null && trimmedMeta.isNotEmpty) ...[
                          const SizedBox(height: 13),
                          Wrap(
                            spacing: 7,
                            runSpacing: 7,
                            children: [_ReadableDetailPill(text: trimmedMeta)],
                          ),
                        ],
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
                      children: [_ReadableDetailBodyCard(body: body)],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 44,
                            child: OutlinedButton(
                              onPressed: () => Navigator.of(sheetContext).pop(),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AlagagiColors.muted,
                                side: const BorderSide(
                                  color: AlagagiColors.line,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                textStyle: sans(
                                  size: 13,
                                  weight: FontWeight.w700,
                                ),
                              ),
                              child: const Text('닫기'),
                            ),
                          ),
                        ),
                        if (actionLabel != null && onAction != null) ...[
                          const SizedBox(width: 10),
                          Expanded(
                            child: SizedBox(
                              height: 44,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(sheetContext).pop();
                                  onAction();
                                },
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: AlagagiColors.sageDeep,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  textStyle: sans(
                                    size: 13,
                                    weight: FontWeight.w800,
                                  ),
                                ),
                                child: Text(actionLabel),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

class AlagagiOpenReadableIconButton extends StatelessWidget {
  const AlagagiOpenReadableIconButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: '전체 보기',
      onPressed: onPressed,
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints.tightFor(width: 44, height: 44),
      icon: Container(
        width: 31,
        height: 31,
        decoration: BoxDecoration(
          color: const Color(0xFFEFF8FD),
          border: Border.all(color: const Color(0x336F7F63)),
          borderRadius: BorderRadius.circular(999),
        ),
        alignment: Alignment.center,
        child: const Icon(
          Icons.open_in_full_rounded,
          size: 15,
          color: AlagagiColors.sageDeep,
        ),
      ),
    );
  }
}

class _ReadableDetailMark extends StatelessWidget {
  const _ReadableDetailMark({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.76),
        border: Border.all(color: const Color(0x336F7F63)),
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.center,
      child: Icon(
        _iconForLabel(label),
        size: 20,
        color: AlagagiColors.sageDeep,
      ),
    );
  }

  IconData _iconForLabel(String label) {
    if (label.contains('음악')) {
      return Icons.music_note_rounded;
    }
    if (label.contains('주식')) {
      return Icons.bar_chart_rounded;
    }
    if (label.contains('댓글')) {
      return Icons.chat_bubble_outline_rounded;
    }
    if (label.contains('소개')) {
      return Icons.badge_outlined;
    }
    return Icons.description_outlined;
  }
}

class _ReadableDetailCloseButton extends StatelessWidget {
  const _ReadableDetailCloseButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: '닫기',
      child: SizedBox(
        width: 42,
        height: 42,
        child: IconButton(
          onPressed: onPressed,
          icon: const Icon(Icons.close_rounded, size: 20),
          color: AlagagiColors.muted,
          padding: EdgeInsets.zero,
          style: IconButton.styleFrom(
            backgroundColor: Colors.white.withValues(alpha: 0.72),
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: AlagagiColors.line),
              borderRadius: BorderRadius.circular(21),
            ),
          ),
        ),
      ),
    );
  }
}

class _ReadableDetailPill extends StatelessWidget {
  const _ReadableDetailPill({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 26),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.72),
        border: Border.all(color: const Color(0x266F7F63)),
        borderRadius: BorderRadius.circular(999),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Text(
        text,
        style: sans(
          size: 11,
          weight: FontWeight.w700,
          color: AlagagiColors.muted,
          height: 1.25,
        ),
      ),
    );
  }
}

class _ReadableDetailBodyCard extends StatelessWidget {
  const _ReadableDetailBodyCard({required this.body});

  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7FCFF),
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(21),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 19),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 1,
            bottom: 1,
            child: Container(
              width: 3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                gradient: const LinearGradient(
                  colors: [AlagagiColors.sage, AlagagiColors.lavender],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              body,
              key: readableDetailBodyKey,
              style: sans(
                size: 14.2,
                color: const Color(0xFF3F3E39),
                height: 1.82,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
