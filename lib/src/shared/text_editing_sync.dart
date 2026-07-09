import 'package:flutter/widgets.dart';

class ImeSafeTextEditingController extends TextEditingController {
  ImeSafeTextEditingController({
    super.text,
    this.onCommittedChanged,
    this.onLocalChanged,
  }) {
    _lastDispatchedText = text;
    addListener(_handleChanged);
  }

  ValueChanged<String>? onCommittedChanged;
  VoidCallback? onLocalChanged;
  late String _lastDispatchedText;
  bool _syncingText = false;

  bool get isComposing => isTextEditingComposing(this);

  void _handleChanged() {
    onLocalChanged?.call();
    if (_syncingText || isComposing) {
      return;
    }
    dispatchCurrentText();
  }

  void dispatchCurrentText() {
    final nextText = text;
    if (nextText == _lastDispatchedText) {
      return;
    }
    _lastDispatchedText = nextText;
    onCommittedChanged?.call(nextText);
  }

  bool syncText(String text, {FocusNode? focusNode, bool force = false}) {
    _syncingText = true;
    final synced = syncTextEditingControllerText(
      this,
      text,
      focusNode: focusNode,
      force: force,
    );
    _syncingText = false;
    if (synced) {
      _lastDispatchedText = this.text;
    }
    return synced;
  }

  @override
  void dispose() {
    removeListener(_handleChanged);
    super.dispose();
  }
}

bool isTextEditingComposing(TextEditingController controller) {
  final composing = controller.value.composing;
  return composing.isValid && !composing.isCollapsed;
}

VoidCallback dispatchTextOnFocusLost(
  ImeSafeTextEditingController controller,
  FocusNode focusNode,
) {
  void handleFocusChange() {
    if (!focusNode.hasFocus) {
      controller.dispatchCurrentText();
    }
  }

  focusNode.addListener(handleFocusChange);
  return () => focusNode.removeListener(handleFocusChange);
}

bool syncTextEditingControllerText(
  TextEditingController controller,
  String text, {
  FocusNode? focusNode,
  bool force = false,
}) {
  if (controller.text == text) {
    return true;
  }
  if (!force &&
      ((focusNode?.hasFocus ?? false) || isTextEditingComposing(controller))) {
    return false;
  }
  controller.value = TextEditingValue(
    text: text,
    selection: TextSelection.collapsed(offset: text.length),
  );
  return true;
}
