import 'package:flutter/material.dart';

import '../../app/test_keys.dart';
import '../../domain/alagagi_controller.dart';
import '../../shared/text_editing_sync.dart';
import '../../shared/ui_style.dart';

/// 담아둔 여행 사진을 화면 가득 열어 본다.
///
/// 격자의 작은 조각으로만 보이면 정작 사진을 볼 수가 없다. 좌우로 넘기고
/// 손가락으로 확대할 수 있어야 사진을 담아둔 의미가 산다.
/// [visiblePhotoIds]는 방금 보고 있던 목록의 순서 그대로다. 넘기면 뷰어도
/// 그 범위만 넘긴다. 날짜로 걸러 보다가 뷰어에서 전체가 나오면 어디까지가
/// 오늘 사진인지 알 수 없다.
Future<void> showTripPhotoViewer(
  BuildContext context, {
  required AlagagiController controller,
  required String tripId,
  required String initialPhotoId,
  List<String>? visiblePhotoIds,
}) {
  return Navigator.of(context).push<void>(
    PageRouteBuilder<void>(
      opaque: false,
      barrierColor: Colors.black87,
      pageBuilder: (_, _, _) => TripPhotoViewer(
        controller: controller,
        tripId: tripId,
        initialPhotoId: initialPhotoId,
        visiblePhotoIds: visiblePhotoIds,
      ),
      transitionsBuilder: (_, animation, _, child) =>
          FadeTransition(opacity: animation, child: child),
    ),
  );
}

class TripPhotoViewer extends StatefulWidget {
  const TripPhotoViewer({
    super.key,
    required this.controller,
    required this.tripId,
    required this.initialPhotoId,
    this.visiblePhotoIds,
  });

  final AlagagiController controller;
  final String tripId;
  final String initialPhotoId;
  final List<String>? visiblePhotoIds;

  @override
  State<TripPhotoViewer> createState() => _TripPhotoViewerState();
}

class _TripPhotoViewerState extends State<TripPhotoViewer> {
  late final PageController _pageController;
  late final ImeSafeTextEditingController _captionController;
  late int _index;
  bool _zoomed = false;
  bool _editingCaption = false;
  String? _captionError;

  List<TripPhoto> get _photos {
    final all = widget.controller.tripPhotosFor(widget.tripId);
    final order = widget.visiblePhotoIds;
    if (order == null) {
      return all;
    }
    final byId = {for (final photo in all) photo.id: photo};
    return [
      for (final id in order)
        if (byId[id] != null) byId[id]!,
    ];
  }

  @override
  void initState() {
    super.initState();
    final photos = _photos;
    final initial = photos.indexWhere(
      (photo) => photo.id == widget.initialPhotoId,
    );
    _index = initial < 0 ? 0 : initial;
    _pageController = PageController(initialPage: _index);
    _captionController = ImeSafeTextEditingController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _captionController.dispose();
    super.dispose();
  }

  void _startCaptionEdit(TripPhoto photo) {
    setState(() {
      _editingCaption = true;
      _captionError = null;
      _captionController.text = photo.caption;
    });
  }

  void _submitCaption(TripPhoto photo) {
    final error = widget.controller.updateTripPhotoCaption(
      photo.id,
      _captionController.text,
    );
    setState(() {
      _captionError = error;
      if (error == null) {
        _editingCaption = false;
      }
    });
  }

  void _deleteCurrent(TripPhoto photo) {
    final remaining = _photos.length - 1;
    widget.controller.deleteTripPhoto(photo.id);
    if (remaining <= 0) {
      Navigator.of(context).pop();
      return;
    }
    setState(() {
      _index = _index.clamp(0, remaining - 1);
      _editingCaption = false;
      if (_pageController.hasClients) {
        _pageController.jumpToPage(_index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final photos = _photos;
        if (photos.isEmpty) {
          return const SizedBox.shrink();
        }
        final index = _index.clamp(0, photos.length - 1);
        final photo = photos[index];
        final isMine =
            photo.createdByProfileId == widget.controller.state.me.id;

        return Scaffold(
          key: tripPhotoViewerKey,
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Column(
              children: [
                _ViewerTopBar(
                  position: index + 1,
                  total: photos.length,
                  canDelete: isMine,
                  onDelete: () => _deleteCurrent(photo),
                  onClose: () => Navigator.of(context).pop(),
                ),
                Expanded(
                  child: PageView.builder(
                    key: tripPhotoViewerPagerKey,
                    controller: _pageController,
                    // 확대한 동안에는 손가락 움직임이 사진 이동에 쓰여야 한다.
                    physics: _zoomed
                        ? const NeverScrollableScrollPhysics()
                        : const PageScrollPhysics(),
                    itemCount: photos.length,
                    onPageChanged: (next) => setState(() {
                      _index = next;
                      _zoomed = false;
                      _editingCaption = false;
                      _captionError = null;
                    }),
                    itemBuilder: (context, itemIndex) {
                      return _ZoomablePhoto(
                        key: ValueKey(photos[itemIndex].id),
                        photo: photos[itemIndex],
                        onZoomChanged: (zoomed) {
                          if (_zoomed != zoomed) {
                            setState(() => _zoomed = zoomed);
                          }
                        },
                      );
                    },
                  ),
                ),
                _ViewerCaptionBar(
                  photo: photo,
                  isMine: isMine,
                  editing: _editingCaption,
                  controller: _captionController,
                  error: _captionError,
                  onStartEdit: () => _startCaptionEdit(photo),
                  onSubmit: () => _submitCaption(photo),
                  onCancel: () => setState(() {
                    _editingCaption = false;
                    _captionError = null;
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// 손가락으로 확대/이동할 수 있는 한 장.
///
/// 확대하지 않은 동안에는 pan을 꺼 둔다. 켜 두면 좌우로 넘기려는 손짓을
/// 사진이 먼저 먹어버려 다음 사진으로 넘어가지 않는다.
class _ZoomablePhoto extends StatefulWidget {
  const _ZoomablePhoto({
    super.key,
    required this.photo,
    required this.onZoomChanged,
  });

  final TripPhoto photo;
  final ValueChanged<bool> onZoomChanged;

  @override
  State<_ZoomablePhoto> createState() => _ZoomablePhotoState();
}

class _ZoomablePhotoState extends State<_ZoomablePhoto> {
  late final TransformationController _transformController;
  bool _zoomed = false;

  @override
  void initState() {
    super.initState();
    _transformController = TransformationController()
      ..addListener(_handleTransform);
  }

  @override
  void dispose() {
    _transformController
      ..removeListener(_handleTransform)
      ..dispose();
    super.dispose();
  }

  void _handleTransform() {
    final scale = _transformController.value.getMaxScaleOnAxis();
    final zoomed = scale > 1.01;
    if (zoomed == _zoomed) {
      return;
    }
    setState(() => _zoomed = zoomed);
    widget.onZoomChanged(zoomed);
  }

  /// 두 번 누르면 확대와 원래 크기를 오간다.
  void _toggleZoom(TapDownDetails details) {
    if (_zoomed) {
      _transformController.value = Matrix4.identity();
      return;
    }
    final position = details.localPosition;
    _transformController.value = Matrix4.identity()
      ..translateByDouble(-position.dx, -position.dy, 0, 1)
      ..scaleByDouble(2, 2, 1, 1);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTapDown: _toggleZoom,
      onDoubleTap: () {},
      child: InteractiveViewer(
        transformationController: _transformController,
        minScale: 1,
        maxScale: 4,
        panEnabled: _zoomed,
        child: Center(
          child: Image.network(
            widget.photo.imageDataUrl,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.image_not_supported_outlined,
              size: 28,
              color: Colors.white54,
            ),
          ),
        ),
      ),
    );
  }
}

class _ViewerTopBar extends StatelessWidget {
  const _ViewerTopBar({
    required this.position,
    required this.total,
    required this.canDelete,
    required this.onDelete,
    required this.onClose,
  });

  final int position;
  final int total;
  final bool canDelete;
  final VoidCallback onDelete;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
      child: Row(
        children: [
          _ViewerIconButton(
            buttonKey: tripPhotoViewerCloseButtonKey,
            icon: Icons.close_rounded,
            tooltip: '닫기',
            onTap: onClose,
          ),
          Expanded(
            child: Center(
              child: Text(
                '$position / $total',
                style: sans(
                  size: 12.5,
                  weight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          if (canDelete)
            _ViewerIconButton(
              buttonKey: tripPhotoViewerDeleteButtonKey,
              icon: Icons.delete_outline_rounded,
              tooltip: '지우기',
              onTap: onDelete,
            )
          else
            const SizedBox(width: 38),
        ],
      ),
    );
  }
}

class _ViewerIconButton extends StatelessWidget {
  const _ViewerIconButton({
    required this.buttonKey,
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final Key buttonKey;
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        key: buttonKey,
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 38,
          height: 38,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.16),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 18, color: Colors.white),
        ),
      ),
    );
  }
}

/// 사진 아래 설명 줄. 올린 사람은 여기서 바로 고친다.
class _ViewerCaptionBar extends StatelessWidget {
  const _ViewerCaptionBar({
    required this.photo,
    required this.isMine,
    required this.editing,
    required this.controller,
    required this.error,
    required this.onStartEdit,
    required this.onSubmit,
    required this.onCancel,
  });

  final TripPhoto photo;
  final bool isMine;
  final bool editing;
  final TextEditingController controller;
  final String? error;
  final VoidCallback onStartEdit;
  final VoidCallback onSubmit;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (editing) ...[
            TextField(
              key: tripPhotoViewerCaptionFieldKey,
              controller: controller,
              maxLength: kTripPhotoMaxCaptionLength,
              maxLines: 2,
              minLines: 1,
              style: sans(size: 13, color: Colors.white),
              decoration: InputDecoration(
                counterText: '',
                hintText: '이 사진에 한 줄 남기기',
                hintStyle: sans(size: 13, color: Colors.white54),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white24),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                ),
              ),
            ),
            if (error != null) ...[
              const SizedBox(height: 6),
              Text(
                error!,
                style: sans(size: 12, color: const Color(0xFFFFB4A2)),
              ),
            ],
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: onCancel,
                  style: TextButton.styleFrom(foregroundColor: Colors.white70),
                  child: const Text('취소'),
                ),
                const SizedBox(width: 4),
                FilledButton(
                  key: tripPhotoViewerCaptionSaveButtonKey,
                  onPressed: onSubmit,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AlagagiColors.ink,
                    textStyle: sans(size: 12.5, weight: FontWeight.w800),
                  ),
                  child: const Text('저장'),
                ),
              ],
            ),
          ] else
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    photo.caption.isEmpty
                        ? (isMine ? '설명을 남겨볼까요?' : '')
                        : photo.caption,
                    style: sans(
                      size: 13,
                      height: 1.5,
                      color: photo.caption.isEmpty
                          ? Colors.white54
                          : Colors.white,
                    ),
                  ),
                ),
                if (isMine) ...[
                  const SizedBox(width: 8),
                  _ViewerIconButton(
                    buttonKey: tripPhotoViewerCaptionEditButtonKey,
                    icon: Icons.edit_outlined,
                    tooltip: '설명 고치기',
                    onTap: onStartEdit,
                  ),
                ],
              ],
            ),
        ],
      ),
    );
  }
}
