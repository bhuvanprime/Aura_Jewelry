import 'dart:math';
import 'package:flutter/foundation.dart';

/// A simulated email service that generates a 4-digit OTP and "sends" it.
/// Used for testing the BLoC flow before a live backend is integrated.
class MockEmailService {
  MockEmailService._();
  static final MockEmailService instance = MockEmailService._();

  String? _lastGeneratedOtp;

  /// Simulates sending an OTP to the given email/phone.
  Future<void> sendOtp(String target) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Generate 4 digit OTP
    final random = Random();
    _lastGeneratedOtp = (1000 + random.nextInt(9000)).toString();

    // Print to console for the developer to see and use
    debugPrint('====================================================');
    debugPrint('MOCK EMAIL SERVICE: OTP for $target is $_lastGeneratedOtp');
    debugPrint('====================================================');
  }

  /// Verifies if the provided OTP matches the last generated one.
  Future<bool> verifyOtp(String target, String inputOtp) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return inputOtp == _lastGeneratedOtp;
  }
}
