import 'package:flutter/material.dart';

import '../../app/test_keys.dart';
import '../../shared/ui_style.dart';

void showFirstVisitGuideBook(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return DraggableScrollableSheet(
        initialChildSize: 0.74,
        minChildSize: 0.42,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, scrollController) {
          return SafeArea(
            child: Container(
              key: firstVisitGuideBookSheetKey,
              margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              decoration: BoxDecoration(
                color: AlagagiColors.paper,
                border: Border.all(color: AlagagiColors.line),
                borderRadius: BorderRadius.circular(26),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x22000000),
                    blurRadius: 32,
                    offset: Offset(0, 16),
                  ),
                ],
              ),
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'GUIDE BOOK',
                                style: sans(
                                  size: 10.5,
                                  weight: FontWeight.w800,
                                  color: AlagagiColors.sageDeep,
                                  letterSpacing: 1.6,
                                ),
                              ),
                              const SizedBox(height: 7),
                              Text(
                                '헷갈릴 때만 다시 보는 안내서',
                                style: serif(
                                  sheetContext,
                                  size: 21,
                                  weight: FontWeight.w800,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 7),
                              Text(
                                '읽어도 상대에게 알림이 가지 않습니다. 필요한 기능만 눌러서 확인하면 돼요.',
                                style: sans(
                                  size: 12.3,
                                  color: AlagagiColors.muted,
                                  height: 1.58,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          tooltip: '닫기',
                          onPressed: () => Navigator.of(sheetContext).pop(),
                          icon: const Icon(Icons.close_rounded, size: 20),
                          color: AlagagiColors.muted,
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      controller: scrollController,
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
                      itemCount: _guideBookRows.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                      itemBuilder: (_, index) => _guideBookRows[index],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                    child: SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(sheetContext).pop(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AlagagiColors.sageDeep,
                          side: const BorderSide(color: Color(0x33A98B3C)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          textStyle: sans(size: 13, weight: FontWeight.w800),
                        ),
                        child: const Text('닫기'),
                      ),
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


/// 안내서는 실제로 있는 진입점만 가리킨다. where 값은 하단 tab 라벨이나
/// `메뉴`와 글자 그대로 같아야 한다.
const _guideBookRows = <_GuideBookFeatureRow>[
  _GuideBookFeatureRow(
    icon: Icons.question_answer_outlined,
    title: '오늘의 질문',
    body: '답을 남기면 상대 답도 함께 열려요.',
    where: '홈',
  ),
  _GuideBookFeatureRow(
    icon: Icons.calendar_month_outlined,
    title: '질문함과 기록',
    body: '지난 질문을 보고 늦게 답할 질문을 확인해요.',
    where: '질문',
  ),
  _GuideBookFeatureRow(
    icon: Icons.music_note_outlined,
    title: '음악 노트',
    body: '요즘 듣는 곡과 짧은 메모를 남겨요.',
    where: '음악',
  ),
  _GuideBookFeatureRow(
    icon: Icons.event_available_outlined,
    title: '데이트',
    body: '서로 되는 날을 달력에 남겨요.',
    where: '데이트',
  ),
  _GuideBookFeatureRow(
    icon: Icons.checklist_rounded,
    title: '데이트 계획',
    body: '정해진 날에 무엇을 할지 모아요.',
    where: '계획',
  ),
  _GuideBookFeatureRow(
    icon: Icons.place_outlined,
    title: '장소 보드',
    body: '가보고 싶은 곳을 함께 담아둬요.',
    where: '장소',
  ),
  _GuideBookFeatureRow(
    icon: Icons.luggage_outlined,
    title: '여행 계획',
    body: '숙소, 준비물, 일정을 한곳에 모아요.',
    where: '메뉴',
  ),
  _GuideBookFeatureRow(
    icon: Icons.bookmark_added_outlined,
    title: '서로의 기억',
    body: '잊고 싶지 않은 대화를 카드로 남겨요.',
    where: '메뉴',
  ),
  _GuideBookFeatureRow(
    icon: Icons.badge_outlined,
    title: '서로 노트',
    body: '취향과 대화 방식을 편한 질문부터 채워요.',
    where: '메뉴',
  ),
  _GuideBookFeatureRow(
    icon: Icons.bookmark_add_outlined,
    title: '언젠가, 같이',
    body: '같이 해보고 싶은 일을 조용히 담아둬요.',
    where: '메뉴',
  ),
];

class _GuideBookFeatureRow extends StatelessWidget {
  const _GuideBookFeatureRow({
    required this.icon,
    required this.title,
    required this.body,
    required this.where,
  });

  final IconData icon;
  final String title;
  final String body;
  final String where;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AlagagiColors.paper,
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFFDF9EA),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, size: 19, color: AlagagiColors.sageDeep),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: sans(
                    size: 12.8,
                    weight: FontWeight.w800,
                    color: const Color(0xFF46443F),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  body,
                  style: sans(
                    size: 11.4,
                    color: AlagagiColors.muted,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 9),
          Container(
            height: 24,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFCF5),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              where,
              style: sans(
                size: 10,
                weight: FontWeight.w800,
                color: AlagagiColors.sageDeep,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
