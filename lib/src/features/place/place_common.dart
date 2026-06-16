import 'package:flutter/material.dart';

import '../../app/test_keys.dart';
import '../../domain/alagagi_controller.dart';
import '../../shared/ui_style.dart';

String placeCategoryLabel(PlaceCategory category) {
  return switch (category) {
    PlaceCategory.cafe => '카페',
    PlaceCategory.food => '식사',
    PlaceCategory.exhibition => '전시',
    PlaceCategory.walk => '산책',
    PlaceCategory.activity => '활동',
  };
}

IconData placeCategoryIcon(PlaceCategory category) {
  return switch (category) {
    PlaceCategory.cafe => Icons.local_cafe_outlined,
    PlaceCategory.food => Icons.restaurant_outlined,
    PlaceCategory.exhibition => Icons.museum_outlined,
    PlaceCategory.walk => Icons.directions_walk_rounded,
    PlaceCategory.activity => Icons.auto_awesome_motion_outlined,
  };
}

class PlaceSaveStatus extends StatelessWidget {
  const PlaceSaveStatus({super.key, required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final state = controller.state;
    final status = state.placeSaveStatus;
    final message = switch (status) {
      SaveStatus.saving => '장소를 저장 중이에요...',
      SaveStatus.saved => state.placeSaveFeedback,
      SaveStatus.failed => state.placeError,
      SaveStatus.idle => null,
    };
    if (message == null || message.isEmpty) {
      return const SizedBox.shrink();
    }
    final failed = status == SaveStatus.failed;
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        decoration: BoxDecoration(
          color: failed ? const Color(0xFFFFF7F3) : const Color(0xFFF7F8F3),
          border: Border.all(
            color: failed ? const Color(0x33B18472) : const Color(0x338A9A7E),
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Icon(
              failed
                  ? Icons.error_outline_rounded
                  : status == SaveStatus.saving
                  ? Icons.sync_rounded
                  : Icons.check_circle_outline_rounded,
              size: 16,
              color: failed ? const Color(0xFFB18472) : AlagagiColors.sageDeep,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: sans(
                  size: 12,
                  color: failed
                      ? const Color(0xFFB18472)
                      : AlagagiColors.sageDeep,
                  weight: FontWeight.w700,
                ),
              ),
            ),
            if (failed && controller.canRetryPlaceSave)
              TextButton(
                key: placeRetryButtonKey,
                onPressed: controller.retryPlaceSave,
                child: Text(
                  '다시 시도',
                  style: sans(size: 12, weight: FontWeight.w800),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
