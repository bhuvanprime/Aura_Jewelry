import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/theme/app_theme.dart';
import 'core/firebase/firebase_service.dart' as core_firebase;
import 'core/crypto/encryption_service.dart';
import 'shared/widgets/bottom_nav_bar.dart';
import 'shared/widgets/global_loading.dart';

import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/bloc/auth_state.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/otp_verification_screen.dart';
import 'features/home/presentation/screens/home_screen.dart';
import 'features/categories/presentation/screens/categories_screen.dart';
import 'features/home/presentation/screens/wishlist_screen.dart';
import 'features/cart/presentation/screens/cart_screen.dart';
import 'features/profile/presentation/screens/profile_screen.dart';
import 'features/cart/bloc/cart_bloc.dart';
import 'features/admin/domain/repositories/admin_repository.dart';
import 'features/admin/data/repositories/admin_repository_impl.dart';
import 'features/admin/bloc/admin_bloc.dart';
import 'features/admin/presentation/screens/admin_dashboard_screen.dart';
import 'features/products/domain/repositories/product_repository.dart';
import 'features/products/data/repositories/product_repository_impl.dart';
import 'features/products/bloc/product_bloc.dart';
import 'features/products/bloc/product_event.dart';
import 'core/constants/app_strings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Hive.initFlutter();
  
  try {
    await core_firebase.FirebaseService.instance.initialize();
  } catch (e) {
    debugPrint("Firebase initialization skipped or failed: $e");
  }

  await EncryptionService.instance.initialize();

  // Initialize Repositories (can use GetIt in larger apps, passing down for now)
  final AuthRepository authRepository = AuthRepositoryImpl();
  final AdminRepository adminRepository = AdminRepositoryImpl();
  final ProductRepository productRepository = ProductRepositoryImpl();

  runApp(AuraLuxuryApp(
    authRepository: authRepository,
    adminRepository: adminRepository,
    productRepository: productRepository,
  ));
}

class AuraLuxuryApp extends StatelessWidget {
  final AuthRepository authRepository;
  final AdminRepository adminRepository;
  final ProductRepository productRepository;

  const AuraLuxuryApp({
    super.key,
    required this.authRepository,
    required this.adminRepository,
    required this.productRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(authRepository: authRepository),
        ),
        BlocProvider(
          create: (_) => CartBloc(),
        ),
        BlocProvider(
          create: (_) => AdminBloc(adminRepository: adminRepository),
        ),
        BlocProvider(
          create: (_) => ProductBloc(productRepository: productRepository)
            ..add(ProductSubscriptionRequested()),
        ),
      ],
      child: MaterialApp(
        title: AppStrings.appName,
        theme: AppTheme.lightTheme,
        home: const ScaffoldPlaceholder(),
      ),
    );
  }
}

/// Listens to AuthBloc state changes and routes to the correct screen.
class AuthRouter extends StatelessWidget {
  const AuthRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthInitial || state is AuthError) {
          return const LoginScreen();
        } else if (state is AuthOtpSent) {
          return OtpVerificationScreen(emailOrPhone: state.emailOrPhone);
        } else if (state is AuthAuthenticated) {
          if (state.user.role == 'admin') {
            return const AdminDashboardScreen();
          }
          return const ScaffoldPlaceholder(); // Navigate to Home
        }
        
        // AuthLoading or other transitional states
        return const Scaffold(
          body: GlobalLoading(message: 'Loading...'),
        );
      },
    );
  }
}

// -------------------------------------------------------------
// Placeholder Home Screen for Auth Testing
// -------------------------------------------------------------
class ScaffoldPlaceholder extends StatefulWidget {
  const ScaffoldPlaceholder({super.key});

  @override
  State<ScaffoldPlaceholder> createState() => _ScaffoldPlaceholderState();
}

class _ScaffoldPlaceholderState extends State<ScaffoldPlaceholder> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: StandardBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return const HomeScreen();
      case 1:
        return const CategoriesScreen();
      case 2:
        return const WishlistScreen();
      case 3:
        return const CartScreen();
      case 4:
        return const ProfileScreen();
      default:
        return const HomeScreen();
    }
  }
}
