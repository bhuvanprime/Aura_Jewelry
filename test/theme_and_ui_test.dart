import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aura_luxury_jewelry/core/theme/app_colors.dart';
import 'package:aura_luxury_jewelry/core/theme/app_theme.dart';
import 'package:aura_luxury_jewelry/core/constants/app_strings.dart';

void main() {
  group('Rajwada Design System Tests', () {
    test('AppColors contains expected royal palette constants', () {
      expect(AppColors.maroonDeep, const Color(0xFF5C0F1E));
      expect(AppColors.maroonBlack, const Color(0xFF2B0710));
      expect(AppColors.auraGold, const Color(0xFFB8863B));
      expect(AppColors.auraGoldLight, const Color(0xFFE4C77E));
      expect(AppColors.sandal, const Color(0xFFF8F1E0));
      expect(AppColors.charcoal, const Color(0xFF241812));
    });

    test('AppStrings contains updated headlines while preserving app name', () {
      expect(AppStrings.appName, 'Aura Luxury Jewelry');
      expect(AppStrings.goldRateLabel, "TODAY'S RATE · 22K GOLD");
      expect(AppStrings.festiveEdit, 'Timeless elegance,\nhandcrafted heritage');
    });

    testWidgets('AppTheme builds without error and applies royal palette', (tester) async {
      final theme = AppTheme.lightTheme;

      expect(theme.scaffoldBackgroundColor, AppColors.sandal);
      expect(theme.primaryColor, AppColors.auraGold);
      expect(theme.colorScheme.primary, AppColors.auraGold);
      expect(theme.colorScheme.surface, AppColors.sandal);

      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: Scaffold(
            appBar: AppBar(title: const Text('Test Title')),
            body: const Center(
              child: Text('Timeless Elegance'),
            ),
          ),
        ),
      );

      expect(find.text('Test Title'), findsOneWidget);
      expect(find.text('Timeless Elegance'), findsOneWidget);
    });
  });
}
