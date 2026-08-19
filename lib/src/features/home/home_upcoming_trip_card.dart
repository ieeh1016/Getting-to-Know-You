import 'package:flutter/material.dart';

import '../../app/test_keys.dart';
import '../../domain/alagagi_controller.dart';
import '../../shared/ui_components.dart';
import '../../shared/ui_style.dart';

/// 다가오거나 진행 중인 여행이 있을 때만 홈에 보여주는 카드.
///
/// 여행은 날짜가 정해진 일이라 홈에서 남은 날이 보이면 준비를 놓치지 않는다.
/// 여행이 없으면 아무것도 보여주지 않아 홈이 길어지지 않게 한다.
class HomeUpcomingTripCard extends StatelessWidget {
  const HomeUpcomingTripCard({super.key, required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final trip = controller.upcomingTrip;
    if (trip == null) {
      return const SizedBox.shrink();
    }
    final timing = controller.tripTimingFor(trip);
    final packing = controller.tripItemsFor(
      trip.id,
      kind: TripItemKind.packing,
    );
    final checked = controller.tripPackingCheckedCount(trip.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AlagagiSectionLabel('다가오는 여행'),
        const SizedBox(height: 10),
        InkWell(
          key: homeUpcomingTripCardKey,
          onTap: () => controller.goTo(AlagagiRoute.trips),
          borderRadius: BorderRadius.circular(AlagagiCardGeometry.radius),
          child: AlagagiPaperCard(
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AlagagiColors.skyPanel,
                    border: Border.all(color: AlagagiColors.line),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    timing.label,
                    textAlign: TextAlign.center,
                    style: sans(
                      size: 11.5,
                      weight: FontWeight.w800,
                      color: AlagagiColors.sageDeep,
                    ),
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trip.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: serif(
                          context,
                          size: 16.5,
                          weight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        trip.destination.isEmpty
                            ? trip.durationLabel
                            : '${trip.destination} · ${trip.durationLabel}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: sans(size: 12, color: AlagagiColors.muted),
                      ),
                      if (packing.isNotEmpty) ...[
                        const SizedBox(height: 5),
                        Text(
                          '챙긴 것 $checked / ${packing.length}',
                          style: sans(
                            size: 11.5,
                            weight: FontWeight.w700,
                            color: AlagagiColors.sageDeep,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: AlagagiColors.muted,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
      ],
    );
  }
}
