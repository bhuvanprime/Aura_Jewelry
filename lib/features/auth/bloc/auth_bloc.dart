import 'package:flutter_bloc/flutter_bloc.dart';
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
    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onPasswordLogin(AuthPasswordLoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      // Mock: accept any password with 4+ characters
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
