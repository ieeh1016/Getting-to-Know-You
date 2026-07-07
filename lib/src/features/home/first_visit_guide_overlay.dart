import 'package:flutter/material.dart';

import '../../app/test_keys.dart';
import '../../domain/alagagi_controller.dart';
import '../../shared/ui_components.dart';
import '../../shared/ui_style.dart';

class FirstVisitGuideOverlay extends StatelessWidget {
  const FirstVisitGuideOverlay({
    super.key,
    required this.controller,
    required this.onOpenGuideBook,
  });

  final AlagagiController controller;
  final VoidCallback onOpenGuideBook;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Material(
        color: Colors.transparent,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxSheetHeight = (constraints.maxHeight - 32).clamp(
              320.0,
              620.0,
            );
            return Container(
              color: AlagagiColors.ink.withValues(alpha: 0.28),
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: maxSheetHeight),
                child: Container(
                  key: firstVisitGuideSheetKey,
                  decoration: BoxDecoration(
                    color: AlagagiColors.paper,
                    border: Border.all(color: AlagagiColors.line),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x2E2C2B25),
                        blurRadius: 42,
                        offset: Offset(0, 18),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
                  child: SingleChildScrollView(
                    child: SafeArea(
                      top: false,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Center(
                            child: Container(
                              width: 40,
                              height: 4,
                              decoration: BoxDecoration(
                                color: const Color(0xFFD7D5CC),
                                borderRadius: BorderRadius.circular(999),
                              ),
                            ),
                          ),
                          const SizedBox(height: 17),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '처음 방문 안내',
                                  style: sans(
                                    size: 10.5,
                                    weight: FontWeight.w800,
                                    color: AlagagiColors.sageDeep,
                                    letterSpacing: 1.6,
                                  ),
                                ),
                              ),
                              Container(
                                height: 26,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEAF7FD),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  '약 30초',
                                  style: sans(
                                    size: 11,
                                    weight: FontWeight.w800,
                                    color: AlagagiColors.sageDeep,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '오늘은 여기서 시작하면 충분해요',
                            style: serif(
                              context,
                              size: 23,
                              weight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            '기능을 전부 외울 필요 없이, 편한 것부터 하나씩 눌러보면 됩니다.',
                            style: sans(
                              size: 12.7,
                              color: AlagagiColors.muted,
                              height: 1.58,
                            ),
                          ),
                          const SizedBox(height: 15),
                          const _FirstVisitPathRow(
                            number: '01',
                            title: '오늘 질문에 답하기',
                            body: '가장 자연스러운 첫 행동으로 안내합니다.',
                          ),
                          const SizedBox(height: 8),
                          const _FirstVisitPathRow(
                            number: '02',
                            title: '한 곡 남기기',
                            body: '말보다 음악이 편한 날을 위한 선택지입니다.',
                          ),
                          const SizedBox(height: 8),
                          const _FirstVisitPathRow(
                            number: '03',
                            title: '언젠가 같이 담기',
                            body: '해보고 싶은 일을 가볍게 모아둡니다.',
                          ),
                          const SizedBox(height: 13),
                          Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: AlagagiColors.sage,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 7),
                              Expanded(
                                child: Text(
                                  '닫아도 마이에서 처음 안내를 다시 볼 수 있어요.',
                                  style: sans(
                                    size: 11.5,
                                    color: AlagagiColors.muted,
                                    height: 1.45,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          AlagagiPrimaryButton(
                            buttonKey: firstVisitGuideTourButtonKey,
                            label: '30초 둘러보기',
                            onPressed: () {
                              onOpenGuideBook();
                              controller.completeFirstVisitGuide();
                            },
                            color: AlagagiColors.sageDeep,
                          ),
                          const SizedBox(height: 6),
                          SizedBox(
                            height: 44,
                            child: TextButton(
                              key: firstVisitGuideStartButtonKey,
                              onPressed: controller.completeFirstVisitGuide,
                              style: TextButton.styleFrom(
                                foregroundColor: AlagagiColors.sageDeep,
                                textStyle: sans(
                                  size: 13,
                                  weight: FontWeight.w800,
                                ),
                              ),
                              child: const Text('바로 시작하기'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _FirstVisitPathRow extends StatelessWidget {
  const _FirstVisitPathRow({
    required this.number,
    required this.title,
    required this.body,
  });

  final String number;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 62),
      decoration: BoxDecoration(
        color: const Color(0xFFF5FCFF),
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Text(
              number,
              style: sans(
                size: 11,
                weight: FontWeight.w800,
                color: AlagagiColors.sageDeep,
              ),
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: sans(
                    size: 13,
                    weight: FontWeight.w800,
                    color: const Color(0xFF46443F),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  body,
                  style: sans(
                    size: 11.5,
                    color: AlagagiColors.muted,
                    height: 1.42,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
