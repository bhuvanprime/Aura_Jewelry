import '../models/user_model.dart';

abstract class AuthRepository {
  /// Initiates the login process using an email or phone number.
  /// If it's an email, it should dispatch a mocked OTP.
  Future<void> initiateLogin(String emailOrPhone);

  /// Verifies the OTP provided by the user.
  /// Returns the [UserModel] on success.
  Future<UserModel> verifyOtp(String emailOrPhone, String otp);

  /// Authenticates the user as a guest.
  Future<UserModel> continueAsGuest();

  /// Logs out the current user.
  Future<void> logout();

  /// Returns the current authenticated user, if any.
  Future<UserModel?> getCurrentUser();
}
