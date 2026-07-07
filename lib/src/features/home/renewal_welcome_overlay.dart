import 'package:flutter/material.dart';

import '../../app/test_keys.dart';
import '../../domain/alagagi_controller.dart';
import '../../shared/ui_components.dart';
import '../../shared/ui_style.dart';

class RenewalWelcomeOverlay extends StatelessWidget {
  const RenewalWelcomeOverlay({super.key, required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final partner = controller.state.partner.nickname;
    return Positioned.fill(
      child: Material(
        color: Colors.transparent,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxSheetHeight = (constraints.maxHeight - 32).clamp(
              360.0,
              640.0,
            );
            return Container(
              color: AlagagiColors.ink.withValues(alpha: 0.22),
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: maxSheetHeight),
                child: Container(
                  key: renewalWelcomeSheetKey,
                  decoration: BoxDecoration(
                    color: AlagagiColors.paper,
                    border: Border.all(color: const Color(0x6686B9D6)),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x2686B9D6),
                        blurRadius: 44,
                        offset: Offset(0, 18),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
                  child: SingleChildScrollView(
                    child: SafeArea(
                      top: false,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Center(
                            child: Container(
                              width: 42,
                              height: 4,
                              decoration: BoxDecoration(
                                color: AlagagiColors.line,
                                borderRadius: BorderRadius.circular(999),
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Row(
                            children: [
                              _WelcomeMark(partner: partner),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'WELCOME',
                                      style: sans(
                                        size: 10.2,
                                        weight: FontWeight.w900,
                                        color: AlagagiColors.gold,
                                        letterSpacing: 1.7,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      '민영이 안뇽!',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: serif(
                                        context,
                                        size: 23,
                                        weight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFF7FCFF), Color(0xFFDDF0F9)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              border: Border.all(color: AlagagiColors.line),
                              borderRadius: BorderRadius.circular(22),
                            ),
                            padding: const EdgeInsets.fromLTRB(14, 14, 14, 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '민영이 안뇽! 이걸 리뉴얼 할 날을 무지 기다렸어 ㅎㅎ '
                                  '드디어 리뉴얼을 하게 되었네 우리의 시간들을 여기에 잘 기록하고 보존하자!!',
                                  style: sans(
                                    size: 14.2,
                                    weight: FontWeight.w800,
                                    color: AlagagiColors.ink,
                                    height: 1.56,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Row(
                            children: [
                              Expanded(
                                child: _WelcomeMiniCard(
                                  icon: Icons.favorite_rounded,
                                  label: '우리 기록',
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: _WelcomeMiniCard(
                                  icon: Icons.map_rounded,
                                  label: '데이트 장소',
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: _WelcomeMiniCard(
                                  icon: Icons.music_note_rounded,
                                  label: '같이 듣기',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          AlagagiPrimaryButton(
                            buttonKey: renewalWelcomeStartButtonKey,
                            label: '우리 둘 시작하기',
                            onPressed: controller.completeRenewalWelcome,
                            color: AlagagiColors.gold,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _WelcomeMark extends StatelessWidget {
  const _WelcomeMark({required this.partner});

  final String partner;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        color: const Color(0xFFDFF2FB),
        border: Border.all(color: const Color(0x6686B9D6)),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const Icon(
            Icons.favorite_rounded,
            size: 30,
            color: AlagagiColors.gold,
          ),
          Positioned(
            right: -8,
            bottom: -4,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AlagagiColors.line),
                borderRadius: BorderRadius.circular(999),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              child: Text(
                partner,
                style: sans(
                  size: 9.5,
                  weight: FontWeight.w900,
                  color: AlagagiColors.sageDeep,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WelcomeMiniCard extends StatelessWidget {
  const _WelcomeMiniCard({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: const Color(0xFFF5FCFF),
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: AlagagiColors.gold),
          const SizedBox(height: 6),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: sans(
              size: 10.6,
              weight: FontWeight.w900,
              color: AlagagiColors.sageDeep,
            ),
          ),
        ],
      ),
    );
  }
}
