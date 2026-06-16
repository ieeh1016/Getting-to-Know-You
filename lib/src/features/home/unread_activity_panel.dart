import 'package:flutter/material.dart';

import '../../app/test_keys.dart';
import '../../domain/alagagi_controller.dart';
import '../../shared/ui_style.dart';

class UnreadActivityPanel extends StatelessWidget {
  const UnreadActivityPanel({
    super.key,
    required this.controller,
    required this.onOpenCuriosity,
  });

  final AlagagiController controller;
  final ValueChanged<BuildContext> onOpenCuriosity;

  @override
  Widget build(BuildContext context) {
    final activities = controller.unreadActivities;
    if (activities.isEmpty) {
      return const SizedBox.shrink();
    }
    final visibleActivities = activities.take(3).toList();
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Container(
        key: unreadActivityPanelKey,
        decoration: BoxDecoration(
          color: const Color(0xFFFAFAF5),
          border: Border.all(color: const Color(0x338A9A7E)),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AlagagiColors.softSage,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.notifications_none_rounded,
                    size: 16,
                    color: AlagagiColors.sageDeep,
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    '새로 도착한 것',
                    style: sans(
                      size: 13.5,
                      weight: FontWeight.w800,
                      color: const Color(0xFF3F403B),
                    ),
                  ),
                ),
                TextButton(
                  key: unreadActivityClearButtonKey,
                  onPressed: controller.markAllUnreadActivitiesSeen,
                  style: TextButton.styleFrom(
                    foregroundColor: AlagagiColors.muted,
                    visualDensity: VisualDensity.compact,
                    textStyle: sans(size: 11.5, weight: FontWeight.w800),
                  ),
                  child: const Text('모두 확인'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            for (var index = 0; index < visibleActivities.length; index++) ...[
              _UnreadActivityRow(
                activity: visibleActivities[index],
                onTap: () =>
                    _openUnreadActivity(context, visibleActivities[index]),
              ),
              if (index != visibleActivities.length - 1)
                const Divider(height: 14, color: AlagagiColors.line),
            ],
            if (activities.length > visibleActivities.length) ...[
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  key: unreadActivityMoreButtonKey,
                  onPressed: () => _showUnreadActivitySheet(
                    context,
                    controller,
                    onOpenCuriosity,
                  ),
                  icon: const Icon(Icons.expand_more_rounded, size: 16),
                  label: Text(
                    '외 ${activities.length - visibleActivities.length}개 더 보기',
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: AlagagiColors.sageDeep,
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    textStyle: sans(size: 11.5, weight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _openUnreadActivity(BuildContext context, UnreadActivity activity) {
    _openUnreadActivityFromHome(context, controller, activity, onOpenCuriosity);
  }
}

void _showUnreadActivitySheet(
  BuildContext parentContext,
  AlagagiController controller,
  ValueChanged<BuildContext> onOpenCuriosity,
) {
  showModalBottomSheet<void>(
    context: parentContext,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return DraggableScrollableSheet(
        initialChildSize: 0.64,
        minChildSize: 0.38,
        maxChildSize: 0.88,
        expand: false,
        builder: (_, scrollController) {
          return AnimatedBuilder(
            animation: controller,
            builder: (context, _) {
              final activities = controller.unreadActivities;
              return SafeArea(
                child: Container(
                  key: unreadActivitySheetKey,
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
                                    '새로 도착한 것',
                                    style: serif(
                                      sheetContext,
                                      size: 21,
                                      weight: FontWeight.w800,
                                      height: 1.35,
                                    ),
                                  ),
                                  const SizedBox(height: 7),
                                  Text(
                                    '${activities.length}개의 새 소식을 최신순으로 모아봤어요.',
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
                          itemCount: activities.length,
                          separatorBuilder: (_, _) => const Divider(
                            height: 14,
                            color: AlagagiColors.line,
                          ),
                          itemBuilder: (rowContext, index) {
                            final activity = activities[index];
                            return _UnreadActivityRow(
                              activity: activity,
                              onTap: () {
                                Navigator.of(sheetContext).pop();
                                _openUnreadActivityFromHome(
                                  parentContext,
                                  controller,
                                  activity,
                                  onOpenCuriosity,
                                );
                              },
                            );
                          },
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
    },
  );
}

void _openUnreadActivityFromHome(
  BuildContext context,
  AlagagiController controller,
  UnreadActivity activity,
  ValueChanged<BuildContext> onOpenCuriosity,
) {
  if (activity.feature == UnreadActivityFeature.curiosity) {
    controller.markFeatureSeen(UnreadActivityFeature.curiosity);
    onOpenCuriosity(context);
    return;
  }
  controller.openUnreadActivity(activity);
}

class _UnreadActivityRow extends StatelessWidget {
  const _UnreadActivityRow({required this.activity, required this.onTap});

  final UnreadActivity activity;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              _TinyUnreadDot(),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity.feature.label,
                      style: sans(
                        size: 11.2,
                        weight: FontWeight.w800,
                        color: AlagagiColors.sageDeep,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      activity.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: sans(
                        size: 12.4,
                        height: 1.45,
                        color: const Color(0xFF4D4C47),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: AlagagiColors.muted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TinyUnreadDot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        color: AlagagiColors.sageDeep,
        shape: BoxShape.circle,
      ),
    );
  }
}
