import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String uid;
  final String emailOrPhone; // This will be encrypted in DB, but plain in memory
  final String role;
  final bool isGuest;

  const UserModel({
    required this.uid,
    required this.emailOrPhone,
    required this.role,
    this.isGuest = false,
  });

  String get id => uid;
  String get email => emailOrPhone;
  String get name => emailOrPhone.contains('@')
      ? emailOrPhone.split('@').first
      : (emailOrPhone.isNotEmpty ? emailOrPhone : 'Patron');

  factory UserModel.guest() {
    return const UserModel(
      uid: 'guest_uid',
      emailOrPhone: 'guest',
      role: 'customer',
      isGuest: true,
    );
  }

  @override
  List<Object?> get props => [uid, emailOrPhone, role, isGuest];
}
