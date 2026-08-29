import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/crypto/admin_credentials.dart';
import '../domain/models/user_model.dart';
import '../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository}) 
      : _authRepository = authRepository, 
        super(AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthPasswordLoginRequested>(_onPasswordLogin);
    on<AuthSignUpRequested>(_onSignUp);
    on<AuthOtpSubmitted>(_onOtpSubmitted);
    on<AuthGuestRequested>(_onGuestRequested);
    on<AuthGoogleSignInRequested>(_onGoogleSignIn);
    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onGoogleSignIn(AuthGoogleSignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.signInWithGoogle();
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onPasswordLogin(AuthPasswordLoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 600));

      final cleanInput = event.emailOrPhone.trim();
      final cleanPassword = event.password.trim();

      // Check if user is attempting Admin login
      if (AdminCredentials.isAdminEmail(cleanInput)) {
        if (AdminCredentials.verify(cleanInput, cleanPassword)) {
          final adminUser = UserModel(
            uid: 'admin_master_001',
            emailOrPhone: 'Admin@acj.com',
            role: 'admin',
          );
          emit(AuthAuthenticated(adminUser));
          return;
        } else {
          emit(const AuthError('Invalid credentials for Admin access.'));
          return;
        }
      }

      if (cleanPassword.length < 4) {
        emit(const AuthError('Password must be at least 4 characters.'));
        return;
      }

      final user = UserModel(
        uid: 'user_${DateTime.now().millisecondsSinceEpoch}',
        emailOrPhone: cleanInput,
        role: 'customer',
      );
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignUp(AuthSignUpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      // Mock: create a new user
      await Future.delayed(const Duration(milliseconds: 800));
      if (event.password.length < 4) {
        emit(const AuthError('Password must be at least 4 characters.'));
        return;
      }
      final user = UserModel(
        uid: 'user_${DateTime.now().millisecondsSinceEpoch}',
        emailOrPhone: event.emailOrPhone,
        role: 'customer',
      );
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLoginRequested(AuthLoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _authRepository.initiateLogin(event.emailOrPhone);
      emit(AuthOtpSent(event.emailOrPhone));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onOtpSubmitted(AuthOtpSubmitted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.verifyOtp(event.emailOrPhone, event.otp);
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError('Failed to verify OTP. Please try again.'));
    }
  }

  Future<void> _onGuestRequested(AuthGuestRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.continueAsGuest();
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(AuthLogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _authRepository.logout();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
