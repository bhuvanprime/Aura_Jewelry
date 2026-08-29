import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/constants/app_strings.dart';

/// Premium hero banner with Rajwada maroon gradient and jaali lattice motif.
///
/// Features:
/// - Maroon deep → maroon black gradient (150°)
/// - Gold-tinted border frame around content
/// - Jaali/lattice decorative diamond pattern dividers
/// - "NEW COLLECTION" eyebrow in gold
/// - Cormorant Garamond serif headline in ivory
/// - Gold gradient CTA pill button
class HeroBanner extends StatelessWidget {
  final VoidCallback onShopNowTap;

  const HeroBanner({super.key, required this.onShopNowTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(22, 22, 22, 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment(-0.3, -0.8),
          end: Alignment(0.3, 1.0),
          colors: [AppColors.maroonDeep, AppColors.maroonBlack],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(4),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.auraGoldLight.withValues(alpha: 0.35),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
        child: Stack(
          children: [
            // Radial gold glow overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: RadialGradient(
                    center: const Alignment(-0.4, -0.6),
                    radius: 1.2,
                    colors: [
                      AppColors.auraGoldLight.withValues(alpha: 0.16),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top jaali divider
                _JaaliDivider(),
                const SizedBox(height: 14),
                // Eyebrow tag
                Text(
                  AppStrings.festiveEditSubtitle.toUpperCase(),
                  style: AppTypography.eyebrow,
                ),
                const SizedBox(height: 10),
                // Main headline
                Text(
                  AppStrings.festiveEdit,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: AppColors.sandal,
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                        height: 1.35,
                      ),
                ),
                const SizedBox(height: 18),
                // CTA button
                GestureDetector(
                  onTap: onShopNowTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 26,
                      vertical: 11,
                    ),
                    decoration: BoxDecoration(
                      gradient: AppColors.goldCta,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Text(
                      AppStrings.shopNow,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: AppColors.maroonBlack,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            letterSpacing: 0.3,
                          ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                // Bottom jaali divider
                _JaaliDivider(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Jaali/lattice diamond pattern decorative divider
class _JaaliDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 12,
      child: CustomPaint(
        size: const Size(double.infinity, 12),
        painter: _JaaliPainter(color: AppColors.auraGoldLight.withValues(alpha: 0.55)),
      ),
    );
  }
}

class _JaaliPainter extends CustomPainter {
  final Color color;
  _JaaliPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    // Horizontal line
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      linePaint,
    );

    // Diamond shapes along the line
    final diamondPaint = Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final double diamondSpacing = 30.0;
    final double diamondSize = 5.0;
    final double centerY = size.height / 2;

    for (double x = 15; x < size.width - 10; x += diamondSpacing) {
      final path = Path()
        ..moveTo(x, centerY - diamondSize)
        ..lineTo(x + diamondSize, centerY)
        ..lineTo(x, centerY + diamondSize)
        ..lineTo(x - diamondSize, centerY)
        ..close();
      canvas.drawPath(path, diamondPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
