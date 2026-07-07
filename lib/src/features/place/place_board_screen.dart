import 'package:flutter/material.dart';

import '../../app/app_shell.dart';
import '../../app/test_keys.dart';
import '../../domain/alagagi_controller.dart';
import '../../shared/ui_components.dart';
import '../../shared/ui_style.dart';
import '../../ui/kakao_map_panel.dart';
import 'place_common.dart';

const _mapCenterLatitude = 37.5665;
const _mapCenterLongitude = 126.9780;
const _placeBoardMapHorizontalBleed = 12.0;
const _selectedPlaceMiniMapHeight = 204.0;

enum _PlaceBoardFilter { all, mutual, mine, partner }

enum _PlaceBoardMode { map, board }

double _placeBoardMapHeight(BuildContext context) {
  final viewportHeight = MediaQuery.sizeOf(context).height;
  return (viewportHeight * 0.58).clamp(386.0, 440.0).toDouble();
}

class PlaceBoardScreen extends StatefulWidget {
  const PlaceBoardScreen({
    super.key,
    required this.controller,
    required this.onOpenExternalLink,
  });

  final AlagagiController controller;
  final ValueChanged<String> onOpenExternalLink;

  @override
  State<PlaceBoardScreen> createState() => _PlaceBoardScreenState();
}

class _PlaceBoardScreenState extends State<PlaceBoardScreen> {
  bool _mapOverlayVisible = true;
  _PlaceBoardFilter _filter = _PlaceBoardFilter.all;
  _PlaceBoardMode _mode = _PlaceBoardMode.map;

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final onOpenExternalLink = widget.onOpenExternalLink;
    final places = controller.sharedPlaces;
    final filteredPlaces = _filteredPlaces(controller, places);
    final mutualCount = places.where((place) => place.isMutual).length;
    return AlagagiScreenScroll(
      bottomNavigation: AlagagiBottomNav(controller: controller),
      children: [
        AlagagiTopBar(title: '가보고 싶은 곳', trailing: ''),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: Text(
                '지도에서 찾은 장소를 둘만의 보드에 모아요',
                style: sans(size: 12.5, color: AlagagiColors.muted),
              ),
            ),
            const SizedBox(width: 8),
            if (_mode == _PlaceBoardMode.map)
              _PlaceMapOverlayButton(
                visible: _mapOverlayVisible,
                onPressed: _toggleMapOverlay,
              ),
          ],
        ),
        const SizedBox(height: 12),
        _PlaceBoardModeToggle(
          selected: _mode,
          onChanged: (mode) => setState(() => _mode = mode),
        ),
        const SizedBox(height: 14),
        AlagagiFeatureHero(
          eyebrow: 'DATE MAP',
          title: '우리 장소 보드',
          subtitle: '언젠가 같이 갈 곳과 서로 관심 있는 장소를 데이트 후보로 모아둬요.',
          icon: Icons.map_rounded,
          gradient: const [
            Color(0xFF2F2E2A),
            Color(0xFF5F7156),
            Color(0xFFB99856),
          ],
          stats: [
            AlagagiHeroStat(
              icon: Icons.place_rounded,
              label: '담은 장소',
              value: '${places.length}곳',
            ),
            AlagagiHeroStat(
              icon: Icons.favorite_rounded,
              label: '서로 관심',
              value: '$mutualCount곳',
            ),
            AlagagiHeroStat(
              icon: Icons.filter_alt_rounded,
              label: '현재 보기',
              value: '${filteredPlaces.length}곳',
            ),
          ],
        ),
        const SizedBox(height: 14),
        _PlaceRouteBoard(
          totalCount: places.length,
          mutualCount: mutualCount,
          filteredCount: filteredPlaces.length,
        ),
        const SizedBox(height: 14),
        if (_mode == _PlaceBoardMode.map)
          _PlaceMapPreview(
            controller: controller,
            mutualCount: mutualCount,
            totalCount: places.length,
            places: places,
            overlayVisible: _mapOverlayVisible,
          )
        else
          _PlaceBoardFocusSummary(
            totalCount: places.length,
            mutualCount: mutualCount,
            filteredCount: filteredPlaces.length,
          ),
        PlaceSaveStatus(controller: controller),
        const SizedBox(height: 14),
        if (controller.state.placeDraftVisible)
          _PlaceDraftCard(controller: controller)
        else
          _PlaceSearchEntryCard(controller: controller),
        const SizedBox(height: 18),
        Row(
          children: [
            const Expanded(child: AlagagiSectionLabel('장소 보드')),
            AlagagiSmallBadge(label: '지도 검색'),
          ],
        ),
        const SizedBox(height: 12),
        if (places.isNotEmpty) ...[
          _PlaceBoardFilterBar(
            selected: _filter,
            onChanged: (filter) => setState(() => _filter = filter),
          ),
          const SizedBox(height: 12),
        ],
        if (places.isEmpty)
          const AlagagiEmptyStateCard(text: '가보고 싶은 곳을 하나만 담아볼까요?')
        else if (filteredPlaces.isEmpty)
          AlagagiEmptyStateCard(text: _placeFilterEmptyText(_filter))
        else
          Column(
            key: placeBoardKey,
            children: [
              for (final place in filteredPlaces) ...[
                _PlaceCard(
                  controller: controller,
                  place: place,
                  onOpenExternalLink: onOpenExternalLink,
                ),
                const SizedBox(height: 12),
              ],
            ],
          ),
      ],
    );
  }

  void _toggleMapOverlay() {
    setState(() => _mapOverlayVisible = !_mapOverlayVisible);
  }

  List<SharedPlace> _filteredPlaces(
    AlagagiController controller,
    List<SharedPlace> places,
  ) {
    return switch (_filter) {
      _PlaceBoardFilter.all => places,
      _PlaceBoardFilter.mutual =>
        places.where((place) => place.isMutual).toList(),
      _PlaceBoardFilter.mine =>
        places
            .where(
              (place) => place.createdByProfileId == controller.state.me.id,
            )
            .toList(),
      _PlaceBoardFilter.partner =>
        places
            .where(
              (place) =>
                  place.createdByProfileId == controller.state.partner.id,
            )
            .toList(),
    };
  }
}

class _PlaceBoardModeToggle extends StatelessWidget {
  const _PlaceBoardModeToggle({
    required this.selected,
    required this.onChanged,
  });

  final _PlaceBoardMode selected;
  final ValueChanged<_PlaceBoardMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFCFCFA),
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(17),
      ),
      padding: const EdgeInsets.all(5),
      child: Row(
        children: [
          Expanded(
            child: _PlaceModeButton(
              label: '지도 중심',
              icon: Icons.map_outlined,
              selected: selected == _PlaceBoardMode.map,
              onTap: () => onChanged(_PlaceBoardMode.map),
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: _PlaceModeButton(
              label: '보드 중심',
              icon: Icons.view_agenda_outlined,
              selected: selected == _PlaceBoardMode.board,
              onTap: () => onChanged(_PlaceBoardMode.board),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaceModeButton extends StatelessWidget {
  const _PlaceModeButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AlagagiColors.sageDeep : Colors.transparent,
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        borderRadius: BorderRadius.circular(13),
        onTap: onTap,
        child: SizedBox(
          height: 36,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 15,
                color: selected ? Colors.white : AlagagiColors.sageDeep,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: sans(
                  size: 12,
                  weight: FontWeight.w800,
                  color: selected ? Colors.white : AlagagiColors.muted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlaceRouteBoard extends StatelessWidget {
  const _PlaceRouteBoard({
    required this.totalCount,
    required this.mutualCount,
    required this.filteredCount,
  });

  final int totalCount;
  final int mutualCount;
  final int filteredCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2E332B), Color(0xFF5F7156)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F2F2E2A),
            blurRadius: 24,
            offset: Offset(0, 13),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.13),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.13),
                  ),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.explore_rounded,
                  size: 21,
                  color: Color(0xFFEFD797),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DATE ROUTE BOARD',
                      style: sans(
                        size: 10.2,
                        weight: FontWeight.w900,
                        color: const Color(0xFFEFD797),
                        letterSpacing: 1.6,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      totalCount == 0
                          ? '첫 데이트 후보를 비워뒀어요'
                          : '$totalCount곳의 후보가 모였어요',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: serif(
                        context,
                        size: 19,
                        weight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _PlaceRouteMetric(
                  label: '담은 곳',
                  value: '$totalCount',
                  color: const Color(0xFFEFD797),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _PlaceRouteMetric(
                  label: '서로 관심',
                  value: '$mutualCount',
                  color: const Color(0xFFD8A49A),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _PlaceRouteMetric(
                  label: '현재 보기',
                  value: '$filteredCount',
                  color: const Color(0xFFCFE0C8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PlaceRouteMetric extends StatelessWidget {
  const _PlaceRouteMetric({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        border: Border.all(color: Colors.white.withValues(alpha: 0.13)),
        borderRadius: BorderRadius.circular(17),
      ),
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: sans(
              size: 10.5,
              color: Colors.white.withValues(alpha: 0.64),
              weight: FontWeight.w800,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: serif(
              context,
              size: 24,
              weight: FontWeight.w800,
              color: color,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaceBoardFocusSummary extends StatelessWidget {
  const _PlaceBoardFocusSummary({
    required this.totalCount,
    required this.mutualCount,
    required this.filteredCount,
  });

  final int totalCount;
  final int mutualCount;
  final int filteredCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AlagagiColors.creamPanel,
        border: Border.all(color: const Color(0x33B99856)),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AlagagiColors.goldSoft,
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.view_agenda_outlined,
                  size: 19,
                  color: AlagagiColors.gold,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '보드 중심 보기',
                      style: serif(context, size: 17, weight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '지도보다 후보 카드와 관심 상태를 먼저 볼 수 있어요.',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: sans(size: 11.6, color: AlagagiColors.muted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Row(
            children: [
              Expanded(
                child: AlagagiQuietMetric(label: '전체 장소', value: '$totalCount'),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AlagagiQuietMetric(
                  label: '서로 관심',
                  value: '$mutualCount',
                  muted: mutualCount == 0,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AlagagiQuietMetric(
                  label: '현재 보기',
                  value: '$filteredCount',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PlaceBoardFilterBar extends StatelessWidget {
  const _PlaceBoardFilterBar({required this.selected, required this.onChanged});

  final _PlaceBoardFilter selected;
  final ValueChanged<_PlaceBoardFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final filter in _PlaceBoardFilter.values) ...[
            AlagagiFilterPill(
              label: _placeFilterLabel(filter),
              selected: selected == filter,
              onTap: () => onChanged(filter),
            ),
            if (filter != _PlaceBoardFilter.values.last)
              const SizedBox(width: 7),
          ],
        ],
      ),
    );
  }
}

String _placeFilterLabel(_PlaceBoardFilter filter) {
  return switch (filter) {
    _PlaceBoardFilter.all => '전체',
    _PlaceBoardFilter.mutual => '서로 관심',
    _PlaceBoardFilter.mine => '내가 저장',
    _PlaceBoardFilter.partner => '상대 저장',
  };
}

String _placeFilterEmptyText(_PlaceBoardFilter filter) {
  return switch (filter) {
    _PlaceBoardFilter.all => '가보고 싶은 곳을 하나만 담아볼까요?',
    _PlaceBoardFilter.mutual => '서로 관심을 표시한 장소는 아직 없어요.',
    _PlaceBoardFilter.mine => '내가 저장한 장소는 아직 없어요.',
    _PlaceBoardFilter.partner => '상대가 저장한 장소는 아직 없어요.',
  };
}

class _PlaceMapPreview extends StatefulWidget {
  const _PlaceMapPreview({
    required this.controller,
    required this.mutualCount,
    required this.totalCount,
    required this.places,
    required this.overlayVisible,
  });

  final AlagagiController controller;
  final int mutualCount;
  final int totalCount;
  final List<SharedPlace> places;
  final bool overlayVisible;

  @override
  State<_PlaceMapPreview> createState() => _PlaceMapPreviewState();
}

class _PlaceMapPreviewState extends State<_PlaceMapPreview> {
  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final mutualCount = widget.mutualCount;
    final totalCount = widget.totalCount;
    final places = widget.places;
    final overlayVisible = widget.overlayVisible;
    final draftLatitude = controller.state.placeDraftLatitude;
    final draftLongitude = controller.state.placeDraftLongitude;
    final hasDraftLocation =
        controller.state.placeDraftVisible &&
        draftLatitude != null &&
        draftLongitude != null;
    final markers = [
      for (final place in places)
        if (place.latitude != null && place.longitude != null)
          KakaoMapMarkerData(
            id: place.id,
            title: place.name,
            latitude: place.latitude!,
            longitude: place.longitude!,
          ),
      if (hasDraftLocation)
        KakaoMapMarkerData(
          id: 'place-draft-preview',
          title: controller.state.placeDraftName.trim().isEmpty
              ? '선택한 장소'
              : controller.state.placeDraftName.trim(),
          latitude: draftLatitude,
          longitude: draftLongitude,
        ),
    ];
    final mapHeight = _placeBoardMapHeight(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final mapFrame = Container(
          decoration: BoxDecoration(
            color: const Color(0xFFE9EEE8),
            border: Border.all(color: AlagagiColors.line),
            borderRadius: BorderRadius.circular(24),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Positioned.fill(
                child: KakaoMapPanel(
                  centerLatitude: hasDraftLocation
                      ? draftLatitude
                      : _mapCenterLatitude,
                  centerLongitude: hasDraftLocation
                      ? draftLongitude
                      : _mapCenterLongitude,
                  level: hasDraftLocation ? 4 : 6,
                  markers: markers,
                  fallbackBuilder: (context, reason) => _PlaceMapFallback(
                    reason: reason,
                    mutualCount: mutualCount,
                    totalCount: totalCount,
                  ),
                ),
              ),
              if (overlayVisible) ...[
                Positioned(
                  left: 16,
                  top: 16,
                  right: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AlagagiColors.paper.withValues(alpha: 0.93),
                      border: Border.all(color: AlagagiColors.line),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: AlagagiColors.softSage,
                            borderRadius: BorderRadius.circular(13),
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.map_outlined,
                            size: 18,
                            color: AlagagiColors.sageDeep,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '장소 지도',
                                style: sans(
                                  size: 12.8,
                                  weight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                hasDraftLocation
                                    ? '선택한 장소가 큰 지도에 표시됐어요'
                                    : '저장한 장소를 한눈에 크게 봐요',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: sans(
                                  size: 11.2,
                                  color: hasDraftLocation
                                      ? AlagagiColors.sageDeep
                                      : AlagagiColors.muted,
                                  weight: hasDraftLocation
                                      ? FontWeight.w700
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AlagagiColors.paper.withValues(alpha: 0.94),
                      border: Border.all(color: AlagagiColors.line),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.fromLTRB(14, 12, 14, 13),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                totalCount == 0
                                    ? '아직 담은 장소가 없어요'
                                    : '$totalCount곳이 지도에 모였어요',
                                style: sans(size: 13, weight: FontWeight.w800),
                              ),
                            ),
                            const SizedBox(width: 8),
                            AlagagiSmallBadge(label: '지도'),
                          ],
                        ),
                        const SizedBox(height: 9),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: [
                            _MapSummaryPill(label: '서로 관심 $mutualCount'),
                            _MapSummaryPill(label: '담은 곳 $totalCount'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
        if (!constraints.hasBoundedWidth) {
          return SizedBox(height: mapHeight, child: mapFrame);
        }
        final expandedWidth =
            constraints.maxWidth + (_placeBoardMapHorizontalBleed * 2);
        return SizedBox(
          height: mapHeight,
          child: OverflowBox(
            alignment: Alignment.center,
            minWidth: expandedWidth,
            maxWidth: expandedWidth,
            child: SizedBox(
              width: expandedWidth,
              height: mapHeight,
              child: mapFrame,
            ),
          ),
        );
      },
    );
  }
}

class _PlaceMapOverlayButton extends StatelessWidget {
  const _PlaceMapOverlayButton({
    required this.visible,
    required this.onPressed,
  });

  final bool visible;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: visible ? '지도 정보 숨기기' : '지도 정보 보기',
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          visible ? Icons.visibility_off_rounded : Icons.visibility_rounded,
          size: 18,
        ),
        style: IconButton.styleFrom(
          fixedSize: const Size(36, 36),
          minimumSize: const Size(36, 36),
          padding: EdgeInsets.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          backgroundColor: AlagagiColors.paper.withValues(alpha: 0.94),
          foregroundColor: AlagagiColors.sageDeep,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
            side: const BorderSide(color: AlagagiColors.line),
          ),
        ),
      ),
    );
  }
}

class _PlaceMapFallback extends StatelessWidget {
  const _PlaceMapFallback({
    required this.reason,
    required this.mutualCount,
    required this.totalCount,
  });

  final String reason;
  final int mutualCount;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    final message = _kakaoMapFallbackMessage(reason);
    return Stack(
      children: [
        Positioned.fill(child: CustomPaint(painter: _QuietMapPainter())),
        const _MapPin(left: 238, top: 94, color: AlagagiColors.sageDeep),
        const _MapPin(left: 92, top: 126, color: AlagagiColors.lavender),
        const _MapPin(left: 174, top: 156, color: Color(0xFFB18472)),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36),
            child: Text(
              message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: sans(
                size: 10.8,
                color: const Color(0xFF7B7870),
                height: 1.35,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PlaceSearchEntryCard extends StatelessWidget {
  const _PlaceSearchEntryCard({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    return AlagagiPaperCard(
      radius: 24,
      padding: const EdgeInsets.all(18),
      highlightedBorder: const Color(0x228A9A7E),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'PLACE SEARCH',
            style: sans(
              size: 10.5,
              weight: FontWeight.w800,
              color: AlagagiColors.sageDeep,
              letterSpacing: 1.8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '지도에서 찾고\n둘의 보드에 담아요',
            style: serif(
              context,
              size: 22,
              weight: FontWeight.w800,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '장소를 검색해 선택하면 주소와 좌표가 저장되고, 지도에 바로 표시됩니다.',
            style: sans(size: 12.5, color: AlagagiColors.muted, height: 1.6),
          ),
          const SizedBox(height: 15),
          FilledButton.icon(
            key: placeAddButtonKey,
            onPressed: controller.startPlaceDraft,
            icon: const Icon(Icons.search_rounded, size: 18),
            label: const Text('장소 검색하기'),
            style: FilledButton.styleFrom(
              backgroundColor: AlagagiColors.sageDeep,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              textStyle: sans(size: 13, weight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaceDraftCard extends StatelessWidget {
  const _PlaceDraftCard({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final isEditing = controller.state.editingPlaceId != null;
    return AlagagiPaperCard(
      radius: 22,
      padding: const EdgeInsets.all(18),
      highlightedBorder: AlagagiColors.sage,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            isEditing ? '장소 정보를\n다듬어요.' : '가보고 싶은 곳을\n보드에 담아요.',
            style: serif(
              context,
              size: 20,
              weight: FontWeight.w800,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            isEditing
                ? '메모와 카테고리를 고치거나, 다른 지도 검색 결과로 장소를 바꿀 수 있어요.'
                : '지도에서 장소를 검색하고 결과를 선택하면 주소와 좌표가 함께 저장돼요.',
            style: sans(size: 12.5, color: AlagagiColors.muted, height: 1.6),
          ),
          const SizedBox(height: 14),
          _KakaoPlaceSearchPanel(controller: controller),
          const SizedBox(height: 12),
          _SelectedPlacePreview(controller: controller),
          const SizedBox(height: 10),
          _PlaceTextField(
            fieldKey: placeNoteFieldKey,
            label: 'NOTE',
            hint: '왜 같이 가보고 싶은지 한 줄로',
            initialValue: controller.state.placeDraftNote,
            maxLength: 120,
            minLines: 2,
            maxLines: 3,
            onChanged: (value) => controller.updatePlaceDraft(note: value),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final category in PlaceCategory.values)
                AlagagiFilterPill(
                  label: placeCategoryLabel(category),
                  selected: controller.state.placeDraftCategory == category,
                  onTap: () => controller.setPlaceDraftCategory(category),
                ),
            ],
          ),
          if (controller.state.placeDraftError != null) ...[
            const SizedBox(height: 10),
            _PlaceDraftErrorCard(message: controller.state.placeDraftError!),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              TextButton(
                onPressed: controller.cancelPlaceDraft,
                child: Text(
                  '취소',
                  style: sans(size: 13, color: AlagagiColors.muted),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AlagagiPrimaryButton(
                  label: isEditing ? '수정 저장하기' : '장소 보드에 담기',
                  buttonKey: placeSubmitButtonKey,
                  onPressed: controller.submitPlaceDraft,
                  color: AlagagiColors.sageDeep,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _KakaoPlaceSearchPanel extends StatefulWidget {
  const _KakaoPlaceSearchPanel({required this.controller});

  final AlagagiController controller;

  @override
  State<_KakaoPlaceSearchPanel> createState() => _KakaoPlaceSearchPanelState();
}

class _KakaoPlaceSearchPanelState extends State<_KakaoPlaceSearchPanel> {
  final TextEditingController _queryController = TextEditingController();
  List<KakaoPlaceSearchResult> _results = const [];
  bool _searching = false;
  String? _error;

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final keyword = _queryController.text.trim();
    if (keyword.length < 2) {
      setState(() {
        _results = const [];
        _error = '두 글자 이상 입력해주세요.';
      });
      return;
    }

    setState(() {
      _searching = true;
      _error = null;
    });
    try {
      final results = await searchKakaoPlaces(keyword);
      if (!mounted) {
        return;
      }
      setState(() {
        _results = results;
        _error = results.isEmpty ? '검색 결과가 없어요.' : null;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _results = const [];
        _error = '장소 검색을 불러오지 못했어요.';
      });
    } finally {
      if (mounted) {
        setState(() => _searching = false);
      }
    }
  }

  void _select(KakaoPlaceSearchResult result) {
    widget.controller.applyKakaoPlaceResult(
      providerPlaceId: result.id,
      name: result.name,
      address: result.roadAddress.isNotEmpty
          ? result.roadAddress
          : result.address,
      latitude: result.latitude,
      longitude: result.longitude,
      category: _placeCategoryFromKakaoResult(result),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedPlaceId = widget.controller.state.placeDraftProviderPlaceId;
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F4),
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(17),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  key: placeSearchFieldKey,
                  controller: _queryController,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (_) => _search(),
                  decoration: InputDecoration(
                    hintText: '장소명 검색',
                    prefixIcon: const Icon(Icons.search_rounded, size: 18),
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 11,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AlagagiColors.line),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AlagagiColors.line),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: AlagagiColors.sageDeep,
                      ),
                    ),
                  ),
                  style: sans(size: 13.2),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 44,
                child: FilledButton(
                  key: placeSearchButtonKey,
                  onPressed: _searching ? null : _search,
                  style: FilledButton.styleFrom(
                    backgroundColor: AlagagiColors.sageDeep,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    textStyle: sans(size: 12.5, weight: FontWeight.w800),
                  ),
                  child: Text(_searching ? '검색 중' : '검색'),
                ),
              ),
            ],
          ),
          if (_error != null) ...[
            const SizedBox(height: 9),
            if (_error!.contains('장소 검색'))
              _KakaoSearchHelpCard(message: _error!, onRetry: _search)
            else
              Text(
                _error!,
                style: sans(size: 11.5, color: AlagagiColors.muted),
              ),
          ],
          if (_results.isNotEmpty) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '검색 결과',
                    style: sans(size: 12.2, weight: FontWeight.w800),
                  ),
                ),
                Text(
                  '누르면 지도와 저장 미리보기가 바뀌어요',
                  style: sans(size: 10.5, color: AlagagiColors.muted),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Column(
              children: [
                for (final result in _results)
                  _KakaoPlaceResultRow(
                    result: result,
                    selected: result.id == selectedPlaceId,
                    onTap: () => _select(result),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _KakaoSearchHelpCard extends StatelessWidget {
  const _KakaoSearchHelpCard({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF4E9E4),
        border: Border.all(color: const Color(0x33B18472)),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.info_outline_rounded,
                size: 17,
                color: Color(0xFF8F5F50),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  message,
                  style: sans(
                    size: 12,
                    color: const Color(0xFF8F5F50),
                    weight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '개발자 콘솔의 Web 플랫폼에 현재 도메인과 JavaScript Key가 등록되어 있는지 확인해주세요.',
            style: sans(
              size: 11.4,
              color: const Color(0xFF7B6860),
              height: 1.45,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: const [
              _KakaoSetupChip('https://ieeh1016.github.io'),
              _KakaoSetupChip('http://127.0.0.1:8097'),
              _KakaoSetupChip('JavaScript Key'),
            ],
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded, size: 15),
            label: const Text('다시 검색하기'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF8F5F50),
              side: const BorderSide(color: Color(0x33B18472)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
              textStyle: sans(size: 12, weight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

class _KakaoSetupChip extends StatelessWidget {
  const _KakaoSetupChip(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.72),
        border: Border.all(color: const Color(0x22B18472)),
        borderRadius: BorderRadius.circular(999),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: Text(
        label,
        style: sans(
          size: 10.5,
          color: const Color(0xFF7B6860),
          weight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _KakaoPlaceResultRow extends StatelessWidget {
  const _KakaoPlaceResultRow({
    required this.result,
    required this.selected,
    required this.onTap,
  });

  final KakaoPlaceSearchResult result;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final address = result.roadAddress.isNotEmpty
        ? result.roadAddress
        : result.address;
    return Padding(
      padding: const EdgeInsets.only(top: 7),
      child: InkWell(
        key: placeSearchResultButtonKey(result.id),
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: selected ? AlagagiColors.sagePanel : Colors.white,
            border: Border.all(
              color: selected ? const Color(0x668A9A7E) : AlagagiColors.line,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: selected
                      ? AlagagiColors.sageDeep
                      : AlagagiColors.softSage,
                  borderRadius: BorderRadius.circular(13),
                ),
                alignment: Alignment.center,
                child: Icon(
                  selected ? Icons.check_rounded : Icons.place_outlined,
                  size: 17,
                  color: selected ? Colors.white : AlagagiColors.sageDeep,
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: sans(size: 12.7, weight: FontWeight.w800),
                    ),
                    if (address.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        address,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: sans(size: 10.8, color: AlagagiColors.muted),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: selected ? Colors.white : AlagagiColors.paper,
                  border: Border.all(color: const Color(0x336F7F63)),
                  borderRadius: BorderRadius.circular(999),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                child: Text(
                  selected ? '선택됨' : '선택',
                  style: sans(
                    size: 10.8,
                    color: AlagagiColors.sageDeep,
                    weight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectedPlacePreview extends StatelessWidget {
  const _SelectedPlacePreview({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final name = controller.state.placeDraftName.trim();
    final address = controller.state.placeDraftAddress.trim();
    final latitude = controller.state.placeDraftLatitude;
    final longitude = controller.state.placeDraftLongitude;
    final hasSelection =
        name.isNotEmpty && latitude != null && longitude != null;
    return Container(
      decoration: BoxDecoration(
        color: hasSelection ? AlagagiColors.paper : const Color(0xFFF8F8F4),
        border: Border.all(
          color: hasSelection ? const Color(0x668A9A7E) : AlagagiColors.line,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: hasSelection
                      ? AlagagiColors.sageDeep
                      : AlagagiColors.softSage,
                  borderRadius: BorderRadius.circular(13),
                ),
                alignment: Alignment.center,
                child: Icon(
                  hasSelection
                      ? Icons.check_rounded
                      : Icons.add_location_alt_outlined,
                  size: 18,
                  color: hasSelection ? Colors.white : AlagagiColors.sageDeep,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hasSelection ? '선택한 장소가 준비됐어요' : '검색 결과를 선택해주세요',
                      style: sans(size: 13.5, weight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      hasSelection
                          ? '저장하면 둘의 장소 보드와 지도에 함께 표시됩니다.'
                          : '검색 결과를 누르면 주소와 좌표가 자동으로 들어와요.',
                      style: sans(
                        size: 11.6,
                        color: AlagagiColors.muted,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              AlagagiSmallBadge(label: hasSelection ? '지도' : '대기'),
            ],
          ),
          const SizedBox(height: 12),
          _SelectedPlaceField(
            fieldKey: placeNameFieldKey,
            label: '선택한 장소',
            value: name,
            emptyText: '아직 선택된 장소가 없어요.',
          ),
          const SizedBox(height: 9),
          _SelectedPlaceField(
            fieldKey: placeAddressFieldKey,
            label: '주소',
            value: address,
            emptyText: '장소를 고르면 주소가 표시돼요.',
          ),
          if (hasSelection) ...[
            const SizedBox(height: 11),
            _SelectedPlaceMiniMap(
              name: name,
              latitude: latitude,
              longitude: longitude,
            ),
          ],
        ],
      ),
    );
  }
}

class _SelectedPlaceMiniMap extends StatelessWidget {
  const _SelectedPlaceMiniMap({
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  final String name;
  final double latitude;
  final double longitude;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _selectedPlaceMiniMapHeight,
      decoration: BoxDecoration(
        color: const Color(0xFFE9EEE8),
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: KakaoMapPanel(
        centerLatitude: latitude,
        centerLongitude: longitude,
        level: 4,
        markers: [
          KakaoMapMarkerData(
            id: 'selected-place-preview',
            title: name,
            latitude: latitude,
            longitude: longitude,
          ),
        ],
        fallbackBuilder: (context, reason) => Stack(
          children: [
            Positioned.fill(child: CustomPaint(painter: _QuietMapPainter())),
            const _MapPin(left: 154, top: 72, color: AlagagiColors.sageDeep),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  _kakaoMapFallbackMessage(reason),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: sans(
                    size: 10.5,
                    color: const Color(0xFF7B7870),
                    height: 1.35,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlaceDraftErrorCard extends StatelessWidget {
  const _PlaceDraftErrorCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF4E9E4),
        border: Border.all(color: const Color(0x33B18472)),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            size: 17,
            color: Color(0xFF8F5F50),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: sans(
                size: 12,
                color: const Color(0xFF8F5F50),
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectedPlaceField extends StatelessWidget {
  const _SelectedPlaceField({
    required this.fieldKey,
    required this.label,
    required this.value,
    required this.emptyText,
  });

  final Key fieldKey;
  final String label;
  final String value;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    final hasValue = value.trim().isNotEmpty;
    return Container(
      key: fieldKey,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F4),
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 11),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: sans(
              size: 10.5,
              weight: FontWeight.w800,
              color: AlagagiColors.sageDeep,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            hasValue ? value : emptyText,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: sans(
              size: 13.3,
              color: hasValue ? const Color(0xFF4D4B45) : AlagagiColors.muted,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaceTextField extends StatelessWidget {
  const _PlaceTextField({
    required this.fieldKey,
    required this.label,
    required this.hint,
    required this.initialValue,
    required this.maxLength,
    required this.onChanged,
    this.minLines = 1,
    this.maxLines = 1,
  });

  final Key fieldKey;
  final String label;
  final String hint;
  final String initialValue;
  final int maxLength;
  final ValueChanged<String> onChanged;
  final int minLines;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F4),
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.fromLTRB(14, 7, 14, 7),
      child: TextFormField(
        key: fieldKey,
        initialValue: initialValue,
        maxLength: maxLength,
        minLines: minLines,
        maxLines: maxLines,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          counterText: '',
          border: InputBorder.none,
        ),
        style: sans(size: 13.5, height: 1.45),
      ),
    );
  }
}

class _PlaceCard extends StatelessWidget {
  const _PlaceCard({
    required this.controller,
    required this.place,
    required this.onOpenExternalLink,
  });

  final AlagagiController controller;
  final SharedPlace place;
  final ValueChanged<String> onOpenExternalLink;

  @override
  Widget build(BuildContext context) {
    final isMine = place.createdByProfileId == controller.state.me.id;
    final likedByMe = place.interestedByProfileIds.contains(
      controller.state.me.id,
    );
    final placeBusy =
        controller.state.placeSaveStatus == SaveStatus.saving &&
        controller.isPlaceSaveTarget(place.id);
    final creator = isMine
        ? controller.state.me.nickname
        : controller.state.partner.nickname;
    final kakaoPlaceUrl = _kakaoPlaceUrl(place);
    return AlagagiPaperCard(
      radius: 19,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F2EB),
                  borderRadius: BorderRadius.circular(15),
                ),
                alignment: Alignment.center,
                child: Icon(
                  placeCategoryIcon(place.category),
                  size: 22,
                  color: AlagagiColors.sageDeep,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            place.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: sans(size: 14.5, weight: FontWeight.w800),
                          ),
                        ),
                        const SizedBox(width: 7),
                        AlagagiSmallBadge(
                          label: place.isMutual
                              ? '서로 관심'
                              : _providerLabel(place.provider),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${placeCategoryLabel(place.category)} · $creator 저장',
                      style: sans(size: 11.3, color: AlagagiColors.muted),
                    ),
                    if (place.address.isNotEmpty) ...[
                      const SizedBox(height: 5),
                      Text(
                        place.address,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: sans(size: 11.5, color: const Color(0xFF6F6C65)),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (place.note.isNotEmpty) ...[
            const SizedBox(height: 11),
            Text(
              place.note,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: sans(
                size: 12.3,
                color: const Color(0xFF5F5D57),
                height: 1.45,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (kakaoPlaceUrl != null)
                SizedBox(
                  height: 32,
                  child: OutlinedButton.icon(
                    onPressed: () => onOpenExternalLink(kakaoPlaceUrl),
                    icon: const Icon(Icons.open_in_new_rounded, size: 14),
                    label: const Text('지도에서 열기'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AlagagiColors.sageDeep,
                      side: const BorderSide(color: Color(0x336F7F63)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                      textStyle: sans(size: 11.5, weight: FontWeight.w800),
                    ),
                  ),
                ),
              SizedBox(
                height: 32,
                child: OutlinedButton.icon(
                  key: placeInterestButtonKey(place.id),
                  onPressed: placeBusy
                      ? null
                      : () => controller.togglePlaceInterest(place.id),
                  icon: Icon(
                    likedByMe
                        ? Icons.remove_circle_outline_rounded
                        : Icons.add_circle_outline_rounded,
                    size: 14,
                  ),
                  label: Text(likedByMe ? '관심 해제' : '관심 표시'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AlagagiColors.sageDeep,
                    disabledForegroundColor: AlagagiColors.muted,
                    side: const BorderSide(color: Color(0x336F7F63)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                    textStyle: sans(size: 11.5, weight: FontWeight.w800),
                  ),
                ),
              ),
              if (isMine)
                SizedBox(
                  height: 32,
                  child: OutlinedButton.icon(
                    key: placeEditButtonKey(place.id),
                    onPressed: placeBusy
                        ? null
                        : () => controller.startEditingPlace(place.id),
                    icon: const Icon(Icons.edit_outlined, size: 14),
                    label: const Text('수정'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AlagagiColors.sageDeep,
                      side: const BorderSide(color: Color(0x336F7F63)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                      textStyle: sans(size: 11.5, weight: FontWeight.w800),
                    ),
                  ),
                ),
              if (isMine)
                SizedBox(
                  height: 32,
                  child: OutlinedButton.icon(
                    key: placeDeleteButtonKey(place.id),
                    onPressed: placeBusy
                        ? null
                        : () => controller.deletePlace(place.id),
                    icon: const Icon(Icons.delete_outline_rounded, size: 14),
                    label: const Text('삭제'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFB18472),
                      side: const BorderSide(color: Color(0x33B18472)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                      textStyle: sans(size: 11.5, weight: FontWeight.w800),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MapPin extends StatelessWidget {
  const _MapPin({required this.left, required this.top, required this.color});

  final double left;
  final double top;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      child: Transform.rotate(
        angle: -0.78,
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
              bottomRight: Radius.circular(16),
              bottomLeft: Radius.circular(4),
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x26393934),
                blurRadius: 16,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: Container(
              width: 9,
              height: 9,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MapSummaryPill extends StatelessWidget {
  const _MapSummaryPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AlagagiColors.paper.withValues(alpha: 0.92),
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(999),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      child: Text(
        label,
        style: sans(
          size: 11,
          weight: FontWeight.w800,
          color: AlagagiColors.sageDeep,
        ),
      ),
    );
  }
}

class _QuietMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0x66CDD6C2)
      ..strokeWidth = 1;
    for (var x = 0.0; x < size.width; x += 54) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (var y = 0.0; y < size.height; y += 54) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
    final roadPaint = Paint()
      ..color = const Color(0xBFFFFFFA)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 18;
    canvas.drawLine(
      Offset(-20, size.height * .72),
      Offset(size.width + 20, size.height * .34),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width * .18, -10),
      Offset(size.width * .78, size.height + 10),
      roadPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

String? _kakaoPlaceUrl(SharedPlace place) {
  final providerPlaceId = place.providerPlaceId.trim();
  if (providerPlaceId.isNotEmpty) {
    return 'https://place.map.kakao.com/${Uri.encodeComponent(providerPlaceId)}';
  }
  final latitude = place.latitude;
  final longitude = place.longitude;
  if (latitude == null || longitude == null) {
    return null;
  }
  return 'https://map.kakao.com/link/map/'
      '${Uri.encodeComponent(place.name)},$latitude,$longitude';
}

String _kakaoMapFallbackMessage(String reason) {
  if (reason.contains('불러오지') || reason.contains('브릿지')) {
    return '지도를 불러오지 못했어요. 도메인 등록과 JavaScript Key를 확인해주세요.';
  }
  return reason.isEmpty ? '지도를 준비하고 있어요.' : reason;
}

String _providerLabel(MapApiProvider provider) {
  return switch (provider) {
    MapApiProvider.kakao => '지도 검색',
  };
}

PlaceCategory _placeCategoryFromKakaoResult(KakaoPlaceSearchResult result) {
  final text =
      '${result.categoryGroupCode} ${result.categoryName} ${result.name}'
          .toLowerCase();
  if (text.contains('ce7') || text.contains('카페') || text.contains('cafe')) {
    return PlaceCategory.cafe;
  }
  if (text.contains('fd6') ||
      text.contains('음식') ||
      text.contains('식당') ||
      text.contains('restaurant')) {
    return PlaceCategory.food;
  }
  if (text.contains('ct1') ||
      text.contains('문화') ||
      text.contains('전시') ||
      text.contains('미술') ||
      text.contains('museum') ||
      text.contains('gallery')) {
    return PlaceCategory.exhibition;
  }
  if (text.contains('at4') ||
      text.contains('관광') ||
      text.contains('공원') ||
      text.contains('산책')) {
    return PlaceCategory.walk;
  }
  return PlaceCategory.activity;
}
