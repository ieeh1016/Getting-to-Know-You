import 'package:flutter/material.dart';

import '../../domain/alagagi_controller.dart';
import '../../shared/ui_components.dart';

class QuestionViewSwitch extends StatelessWidget {
  const QuestionViewSwitch({super.key, required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final route = controller.state.route;
    return Row(
      children: [
        Expanded(
          child: AlagagiSegmentButton(
            label: '달력',
            selected: route == AlagagiRoute.archive,
            onTap: () => controller.goTo(AlagagiRoute.archive),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: AlagagiSegmentButton(
            label: '기록',
            selected: route == AlagagiRoute.records,
            onTap: () => controller.goTo(AlagagiRoute.records),
          ),
        ),
      ],
    );
  }
}
