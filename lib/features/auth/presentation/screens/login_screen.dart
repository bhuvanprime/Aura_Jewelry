import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/global_loading.dart';
import '../../bloc/auth_bloc.dart';
import '../../bloc/auth_event.dart';
import '../../bloc/auth_state.dart';
import '../../../../core/constants/app_strings.dart';
import '../widgets/auth_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailPhoneController = TextEditingController();

  void _onLogin() {
    final input = _emailPhoneController.text.trim();
    if (input.isNotEmpty) {
      context.read<AuthBloc>().add(AuthLoginRequested(input));
    }
  }

  void _onGuestLogin() {
    context.read<AuthBloc>().add(AuthGuestRequested());
  }

  @override
  void dispose() {
    _emailPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const GlobalLoading(message: 'Verifying credentials...');
          }

          return Stack(
            children: [
              // Hero Gradient Background
              Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.heroGradient,
                ),
              ),
              // Content
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Container(
                      padding: const EdgeInsets.all(32.0),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            AppStrings.welcomeBack,
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                  color: AppColors.primary,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AppStrings.loginSubtitle,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                          ),
                          const SizedBox(height: 32),
                          AuthTextField(
                            controller: _emailPhoneController,
                            hintText: AppStrings.emailOrPhoneHint,
                            prefixIcon: Icons.person_outline,
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _onLogin,
                              child: const Text(AppStrings.continueText),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: _onGuestLogin,
                            child: Text(
                              AppStrings.continueAsGuest,
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: AppColors.primary,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
