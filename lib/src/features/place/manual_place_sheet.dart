import 'package:flutter/material.dart';

import '../../app/test_keys.dart';
import '../../domain/alagagi_controller.dart';
import '../../shared/text_editing_sync.dart';
import '../../shared/ui_components.dart';
import '../../shared/ui_style.dart';
import 'place_common.dart';

/// 지도 검색 없이 장소를 직접 담는 sheet.
///
/// 카카오 검색은 국내만 다뤄 해외에서는 결과가 나오지 않는다. 이름만으로도
/// 담을 수 있게 하고, 지도 앱에서 복사한 링크를 붙여두면 나중에 그 링크로 연다.
Future<void> showManualPlaceSheet(
  BuildContext context, {
  required AlagagiController controller,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
        ),
        child: SafeArea(
          child: Container(
            key: placeManualSheetKey,
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(sheetContext).size.height * 0.86,
            ),
            decoration: BoxDecoration(
              color: AlagagiColors.paper,
              border: Border.all(color: AlagagiColors.line),
              borderRadius: BorderRadius.circular(26),
            ),
            clipBehavior: Clip.antiAlias,
            child: _ManualPlaceForm(
              controller: controller,
              sheetContext: sheetContext,
            ),
          ),
        ),
      );
    },
  );
}

class _ManualPlaceForm extends StatefulWidget {
  const _ManualPlaceForm({
    required this.controller,
    required this.sheetContext,
  });

  final AlagagiController controller;
  final BuildContext sheetContext;

  @override
  State<_ManualPlaceForm> createState() => _ManualPlaceFormState();
}

class _ManualPlaceFormState extends State<_ManualPlaceForm> {
  late final ImeSafeTextEditingController _nameController;
  late final ImeSafeTextEditingController _addressController;
  late final ImeSafeTextEditingController _noteController;
  late final ImeSafeTextEditingController _linkController;
  PlaceCategory _category = PlaceCategory.food;
  String? _error;

  @override
  void initState() {
    super.initState();
    _nameController = ImeSafeTextEditingController();
    _addressController = ImeSafeTextEditingController();
    _noteController = ImeSafeTextEditingController();
    _linkController = ImeSafeTextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _noteController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  void _submit() {
    final error = widget.controller.saveManualPlace(
      name: _nameController.text,
      category: _category,
      address: _addressController.text,
      note: _noteController.text,
      mapLink: _linkController.text,
    );
    if (error != null) {
      setState(() => _error = error);
      return;
    }
    Navigator.of(widget.sheetContext).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        Container(
          width: 38,
          height: 4,
          decoration: BoxDecoration(
            color: const Color(0xFFD7D0BD),
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 14, 10, 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '직접 담기',
                      style: serif(context, size: 18, weight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '지도 검색에 없는 해외 장소도 이렇게 담아요',
                      style: sans(size: 12, color: AlagagiColors.muted),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 44,
                height: 44,
                child: IconButton(
                  onPressed: () => Navigator.of(widget.sheetContext).pop(),
                  icon: const Icon(
                    Icons.close_rounded,
                    size: 20,
                    color: AlagagiColors.muted,
                  ),
                ),
              ),
            ],
          ),
        ),
        Flexible(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 4, 18, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '어떤 곳',
                  style: sans(size: 11.5, color: AlagagiColors.muted),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 7,
                  runSpacing: 7,
                  children: [
                    for (final category in PlaceCategory.values)
                      AlagagiFilterPill(
                        key: placeManualCategoryButtonKey(category.name),
                        label: placeCategoryLabel(category),
                        selected: _category == category,
                        onTap: () => setState(() => _category = category),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                _ManualField(
                  fieldKey: placeManualNameFieldKey,
                  controller: _nameController,
                  label: '장소 이름',
                  hint: '예: Ramen Nagi',
                  maxLength: 40,
                ),
                const SizedBox(height: 10),
                _ManualField(
                  fieldKey: placeManualAddressFieldKey,
                  controller: _addressController,
                  label: '주소 (선택)',
                  hint: '예: Shinjuku, Tokyo',
                  maxLength: 120,
                ),
                const SizedBox(height: 10),
                _ManualField(
                  fieldKey: placeManualLinkFieldKey,
                  controller: _linkController,
                  label: '지도 링크 (선택)',
                  hint: '지도 앱에서 공유한 링크를 붙여넣기',
                  maxLength: 500,
                ),
                const SizedBox(height: 10),
                _ManualField(
                  fieldKey: placeManualNoteFieldKey,
                  controller: _noteController,
                  label: '메모 (선택)',
                  hint: '왜 가보고 싶은지',
                  maxLength: 120,
                  maxLines: 3,
                ),
                if (_error != null) ...[
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0x14B35A49),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                    child: Text(
                      _error!,
                      style: sans(
                        size: 12.3,
                        height: 1.5,
                        color: const Color(0xFFB35A49),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                SizedBox(
                  height: 50,
                  child: FilledButton(
                    key: placeManualSubmitButtonKey,
                    onPressed: _submit,
                    style: FilledButton.styleFrom(
                      backgroundColor: AlagagiColors.ink,
                      foregroundColor: AlagagiColors.appBackground,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      textStyle: sans(size: 13, weight: FontWeight.w800),
                    ),
                    child: const Text('장소 담기'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ManualField extends StatelessWidget {
  const _ManualField({
    required this.fieldKey,
    required this.controller,
    required this.label,
    required this.hint,
    required this.maxLength,
    this.maxLines = 1,
  });

  final Key fieldKey;
  final TextEditingController controller;
  final String label;
  final String hint;
  final int maxLength;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AlagagiColors.skyPanel,
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.fromLTRB(14, 7, 14, 7),
      child: TextField(
        key: fieldKey,
        controller: controller,
        maxLength: maxLength,
        minLines: maxLines,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          counterText: '',
          border: InputBorder.none,
        ),
        style: sans(size: 13.5, height: 1.5),
      ),
    );
  }
}
