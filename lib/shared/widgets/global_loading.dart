import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_animations.dart';

/// Elegant gold pulsing loading indicator.
///
/// Replaces the default CircularProgressIndicator with a refined,
/// brand-aligned loading animation — three gold dots that pulse
/// in sequence for a calm, luxurious loading experience.
class GlobalLoading extends StatefulWidget {
  final String? message;

  const GlobalLoading({super.key, this.message});

  @override
  State<GlobalLoading> createState() => _GlobalLoadingState();
}

class _GlobalLoadingState extends State<GlobalLoading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppAnimations.shimmer,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Three pulsing gold dots
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(3, (index) {
                  // Stagger the animation for each dot
                  final delay = index * 0.2;
                  final t = (_controller.value + delay) % 1.0;
                  // Smooth pulse: scale up then down
                  final scale = 0.6 + 0.4 * (1.0 - (2.0 * t - 1.0).abs());
                  final opacity = 0.4 + 0.6 * (1.0 - (2.0 * t - 1.0).abs());

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Transform.scale(
                      scale: scale,
                      child: Opacity(
                        opacity: opacity,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.auraGold,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              );
            },
          ),
          if (widget.message != null) ...[
            const SizedBox(height: 20),
            Text(
              widget.message!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.charcoalMuted,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}
