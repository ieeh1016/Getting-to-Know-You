import 'package:flutter/material.dart';

import '../../domain/alagagi_controller.dart';
import '../../shared/ui_style.dart';

class HomePlusGrid extends StatelessWidget {
  const HomePlusGrid({super.key, required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final tileWidth = (constraints.maxWidth - 10) / 2;
        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            SizedBox(
              width: tileWidth,
              child: _PlusTile(
                icon: Icons.swap_horiz_rounded,
                title: '우리 선택',
                body: '다음 데이트 힌트',
                tone: AlagagiColors.sageSoft,
                iconColor: AlagagiColors.sageDeep,
                onTap: () => controller.goTo(AlagagiRoute.balance),
              ),
            ),
            SizedBox(
              width: tileWidth,
              child: _PlusTile(
                icon: Icons.person_outline_rounded,
                title: '서로 노트',
                body: '마음과 취향',
                tone: AlagagiColors.lavenderSoft,
                iconColor: AlagagiColors.lavender,
                onTap: () => controller.goTo(AlagagiRoute.profileCard),
              ),
            ),
            SizedBox(
              width: tileWidth,
              child: _PlusTile(
                icon: Icons.bookmark_border_rounded,
                title: '언젠가, 같이',
                body: '하고 싶은 것',
                tone: AlagagiColors.goldSoft,
                iconColor: AlagagiColors.gold,
                onTap: () => controller.goTo(AlagagiRoute.wishlist),
              ),
            ),
            SizedBox(
              width: tileWidth,
              child: _PlusTile(
                icon: Icons.map_outlined,
                title: '장소 보드',
                body: '가보고 싶은 곳',
                tone: AlagagiColors.blueSoft,
                iconColor: AlagagiColors.blue,
                onTap: () => controller.goTo(AlagagiRoute.places),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _PlusTile extends StatelessWidget {
  const _PlusTile({
    required this.icon,
    required this.title,
    required this.body,
    required this.tone,
    required this.iconColor,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String body;
  final Color tone;
  final Color iconColor;
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
          height: 140,
          decoration: BoxDecoration(
            border: Border.all(color: AlagagiColors.line),
            borderRadius: BorderRadius.circular(18),
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: tone,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    alignment: Alignment.center,
                    child: Icon(icon, size: 21, color: iconColor),
                  ),
                  const Spacer(),
                  Icon(Icons.arrow_outward_rounded, size: 17, color: iconColor),
                ],
              ),
              const Spacer(),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: serif(context, size: 17, weight: FontWeight.w800),
              ),
              const SizedBox(height: 5),
              Text(
                body,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: sans(size: 12.2, color: AlagagiColors.muted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
