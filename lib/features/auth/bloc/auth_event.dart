import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthLoginRequested extends AuthEvent {
  final String emailOrPhone;
  const AuthLoginRequested(this.emailOrPhone);

  @override
  List<Object?> get props => [emailOrPhone];
}

class AuthPasswordLoginRequested extends AuthEvent {
  final String emailOrPhone;
  final String password;
  const AuthPasswordLoginRequested(this.emailOrPhone, this.password);

  @override
  List<Object?> get props => [emailOrPhone, password];
}

class AuthSignUpRequested extends AuthEvent {
  final String emailOrPhone;
  final String password;
  const AuthSignUpRequested(this.emailOrPhone, this.password);

  @override
  List<Object?> get props => [emailOrPhone, password];
}

class AuthOtpSubmitted extends AuthEvent {
  final String emailOrPhone;
  final String otp;
  
  const AuthOtpSubmitted(this.emailOrPhone, this.otp);

  @override
  List<Object?> get props => [emailOrPhone, otp];
}

class AuthGuestRequested extends AuthEvent {}

class AuthLogoutRequested extends AuthEvent {}
