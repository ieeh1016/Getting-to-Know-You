import 'package:flutter/material.dart';

import '../domain/minyoung_pick_controller.dart';

class MinyoungPickApp extends StatelessWidget {
  const MinyoungPickApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '민영 Pick',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFEF6F6C),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF7FAFF),
        textTheme: ThemeData.light().textTheme.apply(
          bodyColor: const Color(0xFF18202F),
          displayColor: const Color(0xFF18202F),
        ),
      ),
      home: const MinyoungPickScreen(),
    );
  }
}

class MinyoungPickScreen extends StatefulWidget {
  const MinyoungPickScreen({super.key, this.controller});

  final MinyoungPickController? controller;

  @override
  State<MinyoungPickScreen> createState() => _MinyoungPickScreenState();
}

class _MinyoungPickScreenState extends State<MinyoungPickScreen> {
  late final MinyoungPickController _controller;
  late final bool _ownsController;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _controller = widget.controller ?? MinyoungPickController();
  }

  @override
  void dispose() {
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Scaffold(
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(child: _Header(controller: _controller)),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
                      sliver: SliverList.list(
                        children: [
                          _SectionTitle(
                            icon: Icons.calendar_month_rounded,
                            title: '다음 약속',
                          ),
                          const SizedBox(height: 10),
                          ..._controller.dateOptions.map(
                            (option) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _DateOptionTile(
                                option: option,
                                selected:
                                    _controller.state.selectedDateId ==
                                    option.id,
                                onTap: () => _controller.selectDate(option.id),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          _IdeaPanel(controller: _controller),
                          const SizedBox(height: 24),
                          _SectionTitle(
                            icon: Icons.favorite_border_rounded,
                            title: '취향',
                          ),
                          const SizedBox(height: 10),
                          ..._controller.preferencePrompts.map(
                            (prompt) => Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: _PreferenceRow(
                                prompt: prompt,
                                selectedChoice: _controller
                                    .state
                                    .selectedPreferences[prompt.id],
                                onSelected: (choice) => _controller
                                    .selectPreference(prompt.id, choice),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          _SectionTitle(
                            icon: Icons.local_activity_outlined,
                            title: '쿠폰함',
                          ),
                          const SizedBox(height: 10),
                          ..._controller.coupons.map(
                            (coupon) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _CouponTile(
                                coupon: coupon,
                                used: _controller.state.usedCouponIds.contains(
                                  coupon.id,
                                ),
                                onPressed: () =>
                                    _controller.toggleCoupon(coupon.id),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.controller});

  final MinyoungPickController controller;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBFE),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE4E8F2)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x140D1B2A),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const _RoundIcon(icon: Icons.auto_awesome_rounded),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '민영 Pick',
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '오늘은 민영이가 고르는 날',
            style: textTheme.titleMedium?.copyWith(
              color: const Color(0xFF536173),
              fontWeight: FontWeight.w600,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 18),
          const Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _SignalChip(icon: Icons.local_cafe_rounded, label: '카페'),
              _SignalChip(icon: Icons.directions_walk_rounded, label: '산책'),
              _SignalChip(icon: Icons.palette_outlined, label: '전시'),
            ],
          ),
        ],
      ),
    );
  }
}

class _RoundIcon extends StatelessWidget {
  const _RoundIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: const BoxDecoration(
        color: Color(0xFFEF6F6C),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white),
    );
  }
}

class _SignalChip extends StatelessWidget {
  const _SignalChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 18, color: const Color(0xFF1E7A78)),
      label: Text(label),
      labelStyle: const TextStyle(
        color: Color(0xFF263548),
        fontWeight: FontWeight.w700,
        letterSpacing: 0,
      ),
      backgroundColor: const Color(0xFFE9F7F4),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFFEF6F6C), size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: 0,
          ),
        ),
      ],
    );
  }
}

class _DateOptionTile extends StatelessWidget {
  const _DateOptionTile({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final DateOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: selected ? const Color(0xFFFFECEB) : Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 104),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selected
                  ? const Color(0xFFEF6F6C)
                  : const Color(0xFFE4E8F2),
              width: selected ? 1.4 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFFEF6F6C)
                      : const Color(0xFFE9F7F4),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.place_outlined,
                  color: selected ? Colors.white : const Color(0xFF1E7A78),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            option.title,
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                        if (selected)
                          const Text(
                            '선택됨',
                            style: TextStyle(
                              color: Color(0xFFEF6F6C),
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      option.subtitle,
                      style: textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF536173),
                        letterSpacing: 0,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _MetaPill(label: option.place),
                        _MetaPill(label: option.timeLabel),
                      ],
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

class _MetaPill extends StatelessWidget {
  const _MetaPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4FA),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF536173),
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
        ),
      ),
    );
  }
}

class _IdeaPanel extends StatelessWidget {
  const _IdeaPanel({required this.controller});

  final MinyoungPickController controller;

  @override
  Widget build(BuildContext context) {
    final idea = controller.activeIdea;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF263548),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.shuffle_rounded,
                color: Color(0xFFBFEDE5),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '오늘 뭐 할까',
                style: textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            idea.title,
            style: textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            idea.description,
            style: textTheme.bodyMedium?.copyWith(
              color: const Color(0xFFD8E1EF),
              height: 1.4,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: controller.showNextIdea,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('다른 픽 보기'),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFBFEDE5),
              foregroundColor: const Color(0xFF18202F),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PreferenceRow extends StatelessWidget {
  const _PreferenceRow({
    required this.prompt,
    required this.selectedChoice,
    required this.onSelected,
  });

  final PreferencePrompt prompt;
  final String? selectedChoice;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          prompt.title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: const Color(0xFF536173),
            fontWeight: FontWeight.w800,
            letterSpacing: 0,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final choice in prompt.choices)
              ChoiceChip(
                label: Text(choice),
                selected: selectedChoice == choice,
                onSelected: (_) => onSelected(choice),
                selectedColor: const Color(0xFFFFD4D2),
                backgroundColor: Colors.white,
                side: BorderSide(
                  color: selectedChoice == choice
                      ? const Color(0xFFEF6F6C)
                      : const Color(0xFFE4E8F2),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _CouponTile extends StatelessWidget {
  const _CouponTile({
    required this.coupon,
    required this.used,
    required this.onPressed,
  });

  final PickCoupon coupon;
  final bool used;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: used ? const Color(0xFF1E7A78) : const Color(0xFFE4E8F2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            used ? Icons.check_circle_rounded : Icons.local_activity_outlined,
            color: used ? const Color(0xFF1E7A78) : const Color(0xFFEF6F6C),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  coupon.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  coupon.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF536173),
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: onPressed,
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(used ? '되돌리기' : '사용'),
          ),
        ],
      ),
    );
  }
}
