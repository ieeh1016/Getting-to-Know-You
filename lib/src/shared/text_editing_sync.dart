import 'package:flutter/widgets.dart';

bool isTextEditingComposing(TextEditingController controller) {
  final composing = controller.value.composing;
  return composing.isValid && !composing.isCollapsed;
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
