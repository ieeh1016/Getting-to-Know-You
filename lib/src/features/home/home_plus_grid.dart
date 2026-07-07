import 'package:flutter/material.dart';

import '../../domain/alagagi_controller.dart';
import '../../shared/ui_components.dart';
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
      color: Colors.white.withValues(alpha: 0.76),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          height: 82,
          decoration: BoxDecoration(
            border: Border.all(color: AlagagiColors.line),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.fromLTRB(12, 11, 12, 10),
          child: Row(
            children: [
              AlagagiSymbolMark(
                icon: icon,
                size: 38,
                iconSize: 18,
                tone: tone,
                iconColor: iconColor,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: sans(size: 13, weight: FontWeight.w900),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      body,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: sans(size: 10.8, color: AlagagiColors.muted),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
