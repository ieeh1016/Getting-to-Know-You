import 'package:flutter/material.dart';

import '../../domain/alagagi_controller.dart';
import '../../shared/ui_style.dart';

class HomePlusGrid extends StatelessWidget {
  const HomePlusGrid({super.key, required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _PlusTile(
          icon: Icons.swap_horiz_rounded,
          title: '우리 선택',
          body: '다음 데이트 힌트가 되는 선택',
          onTap: () => controller.goTo(AlagagiRoute.balance),
        ),
        const SizedBox(height: 10),
        _PlusTile(
          icon: Icons.person_outline_rounded,
          title: '서로 노트',
          body: '편한 만큼 마음과 취향 남기기',
          onTap: () => controller.goTo(AlagagiRoute.profileCard),
        ),
        const SizedBox(height: 10),
        _PlusTile(
          icon: Icons.bookmark_border_rounded,
          title: '언젠가, 같이',
          body: '같이 해보고 싶은 것 담기',
          onTap: () => controller.goTo(AlagagiRoute.wishlist),
        ),
      ],
    );
  }
}

class _PlusTile extends StatelessWidget {
  const _PlusTile({
    required this.icon,
    required this.title,
    required this.body,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String body;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AlagagiColors.paper,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: AlagagiColors.line),
            borderRadius: BorderRadius.circular(18),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AlagagiColors.sageSoft,
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: Icon(icon, size: 22, color: AlagagiColors.sageDeep),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: serif(context, size: 17, weight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      body,
                      style: sans(size: 12.5, color: AlagagiColors.muted),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_rounded,
                size: 17,
                color: AlagagiColors.sageDeep,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
