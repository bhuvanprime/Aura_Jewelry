import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_animations.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../auth/bloc/auth_bloc.dart';
import '../../../auth/bloc/auth_event.dart';
import '../../../auth/bloc/auth_state.dart';
import '../../../admin/presentation/screens/admin_dashboard_screen.dart';
import '../../../../core/crypto/admin_credentials.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.sandal,
      appBar: AppBar(
        backgroundColor: AppColors.sandal,
        surfaceTintColor: AppColors.transparent,
        title: Text(
          AppStrings.myAccount,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthAuthenticated && !state.user.isGuest) {
            return _AuthenticatedProfileView(
              userIdentifier: state.user.emailOrPhone,
            );
          }
          // Not logged in — show Sign In prompt
          return const _SignInPromptView();
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Sign In Prompt (shown when not logged in)
// ─────────────────────────────────────────────

class _SignInPromptView extends StatelessWidget {
  const _SignInPromptView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Aura icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.sandal,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.auraGoldMuted,
                  width: 2,
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.person_outline,
                  color: AppColors.auraGold,
                  size: 40,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            Text(
              AppStrings.welcomeToAura,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              AppStrings.signInSubtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.charcoalMuted,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xxl * 1.5),
            // Sign In button
            SizedBox(
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                  gradient: AppColors.maroonCta,
                  borderRadius: AppSpacing.borderRadiusPill,
                  boxShadow: AppShadows.whisper,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      AuraPageRoute(page: const _LoginScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.transparent,
                    shadowColor: AppColors.transparent,
                    foregroundColor: AppColors.warmWhite,
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  ),
                  child: const Text(AppStrings.signIn),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: const Icon(Icons.g_mobiledata, color: Color(0xFF4285F4), size: 22),
                ),
                label: const Text('Continue with Google (Optional)'),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.hairlineLight),
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                ),
                onPressed: () {
                  context.read<AuthBloc>().add(AuthGoogleSignInRequested());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Login Screen (email/phone + password)
// ─────────────────────────────────────────────

class _LoginScreen extends StatefulWidget {
  final String? defaultEmail;
  const _LoginScreen({this.defaultEmail});

  @override
  State<_LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<_LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isSignUp = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.defaultEmail ?? '');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (_isSignUp) {
      context.read<AuthBloc>().add(AuthSignUpRequested(email, password));
    } else {
      context.read<AuthBloc>().add(AuthPasswordLoginRequested(email, password));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.sandal,
      appBar: AppBar(
        backgroundColor: AppColors.sandal,
        surfaceTintColor: AppColors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.charcoal, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            // Pop back to profile — the BlocBuilder there will show the authenticated view
            Navigator.pop(context);
          }
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.xxl),
                // Title
                Text(
                  _isSignUp ? AppStrings.createAccount : AppStrings.signIn,
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  _isSignUp ? AppStrings.createAccountSubtitle : AppStrings.signInSubtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.charcoalMuted,
                      ),
                ),
                const SizedBox(height: AppSpacing.xxl * 1.5),

                // Email / Phone field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: Theme.of(context).textTheme.bodyLarge,
                  decoration: InputDecoration(
                    labelText: AppStrings.emailOrPhone,
                    labelStyle: TextStyle(color: AppColors.charcoalMuted),
                    prefixIcon: const Icon(Icons.person_outline, color: AppColors.maroonDeep),
                    filled: true,
                    fillColor: AppColors.sandal,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      borderSide: const BorderSide(color: AppColors.hairline),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      borderSide: const BorderSide(color: AppColors.hairline),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      borderSide: const BorderSide(color: AppColors.maroonDeep, width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return AppStrings.pleaseEnterEmailOrPhone;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.xl),

                // Password field
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  style: Theme.of(context).textTheme.bodyLarge,
                  decoration: InputDecoration(
                    labelText: AppStrings.password,
                    labelStyle: TextStyle(color: AppColors.charcoalMuted),
                    prefixIcon: const Icon(Icons.lock_outline, color: AppColors.maroonDeep),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: AppColors.charcoalFaint,
                      ),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    filled: true,
                    fillColor: AppColors.sandal,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      borderSide: const BorderSide(color: AppColors.hairline),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      borderSide: const BorderSide(color: AppColors.hairline),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      borderSide: const BorderSide(color: AppColors.maroonDeep, width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return AppStrings.pleaseEnterPassword;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.xxl * 1.5),

                // Submit button
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    final isLoading = state is AuthLoading;
                    return SizedBox(
                      width: double.infinity,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: AppColors.maroonCta,
                          borderRadius: AppSpacing.borderRadiusPill,
                          boxShadow: AppShadows.whisper,
                        ),
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.transparent,
                            shadowColor: AppColors.transparent,
                            foregroundColor: AppColors.warmWhite,
                            disabledBackgroundColor: AppColors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.charcoal,
                                  ),
                                )
                              : Text(_isSignUp ? AppStrings.signUp : AppStrings.signIn),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.xxl),

                // Toggle Sign In / Sign Up
                Center(
                  child: GestureDetector(
                    onTap: () => setState(() => _isSignUp = !_isSignUp),
                    child: RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.charcoalMuted,
                            ),
                        children: [
                          TextSpan(
                            text: _isSignUp
                                ? AppStrings.alreadyHaveAccount
                                : AppStrings.dontHaveAccount,
                          ),
                          TextSpan(
                            text: _isSignUp ? AppStrings.signIn : AppStrings.signUp,
                            style: const TextStyle(
                              color: AppColors.auraGold,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Authenticated Profile View
// ─────────────────────────────────────────────

class _AuthenticatedProfileView extends StatelessWidget {
  final String userIdentifier;

  const _AuthenticatedProfileView({required this.userIdentifier});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      children: [
        // Profile Header
        Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.auraGoldMuted,
              child: Text(
                userIdentifier.isNotEmpty ? userIdentifier[0].toUpperCase() : 'U',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: AppColors.charcoal,
                    ),
              ),
            ),
            const SizedBox(width: AppSpacing.xl),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.welcomeBackPrefix,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.charcoalMuted,
                        ),
                  ),
                  Text(
                    userIdentifier,
                    style: Theme.of(context).textTheme.titleLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xxl * 2),

        // Admin Portal Quick Tile (Only visible to Master Admin)
        if (AdminCredentials.isAdminEmail(userIdentifier))
          Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.lg),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.maroonDeep, AppColors.maroonBlack],
              ),
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              border: Border.all(color: AppColors.auraGold),
            ),
            child: ListTile(
              leading: const Icon(Icons.admin_panel_settings, color: AppColors.auraGoldLight),
              title: const Text(
                'Store Admin Dashboard',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                'Items, Categories, Orders, Offers & Analytics',
                style: TextStyle(color: AppColors.auraGoldLight, fontSize: 11),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, color: AppColors.auraGoldLight, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (ctx) => const AdminDashboardScreen()),
                );
              },
            ),
          ),

        // Settings Tiles
        _SettingsTile(
          icon: Icons.inventory_2_outlined,
          title: AppStrings.orderHistory,
          onTap: () {},
        ),
        _SettingsTile(
          icon: Icons.location_on_outlined,
          title: AppStrings.shippingAddresses,
          onTap: () {},
        ),
        _SettingsTile(
          icon: Icons.credit_card_outlined,
          title: AppStrings.paymentMethods,
          onTap: () {},
        ),
        _SettingsTile(
          icon: Icons.notifications_outlined,
          title: AppStrings.notifications,
          onTap: () {},
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
          child: Divider(color: AppColors.hairlineLight),
        ),
        _SettingsTile(
          icon: Icons.help_outline,
          title: AppStrings.helpSupport,
          onTap: () {},
        ),
        _SettingsTile(
          icon: Icons.privacy_tip_outlined,
          title: AppStrings.privacySettings,
          onTap: () {},
        ),

        const SizedBox(height: AppSpacing.xxl * 2),

        // Logout Button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              context.read<AuthBloc>().add(AuthLogoutRequested());
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              side: const BorderSide(color: AppColors.error),
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              shape: RoundedRectangleBorder(
                borderRadius: AppSpacing.borderRadiusPill,
              ),
            ),
            child: const Text(AppStrings.logOut),
          ),
        ),
        const SizedBox(height: 100), // bottom nav padding
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Settings Tile
// ─────────────────────────────────────────────

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.auraGold),
      title: Text(title, style: Theme.of(context).textTheme.bodyLarge),
      trailing: const Icon(Icons.chevron_right, color: AppColors.hairline),
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
    );
  }
}
