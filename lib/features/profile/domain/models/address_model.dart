import 'package:equatable/equatable.dart';

/// Model representing a customer's shipping address stored in Cloud Firestore.
class AddressModel extends Equatable {
  final String id;
  final String fullName;
  final String phoneNumber;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String state;
  final String pincode;
  final String label; // 'Home', 'Work', 'Other'
  final bool isPrimary;

  const AddressModel({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.addressLine1,
    this.addressLine2 = '',
    required this.city,
    required this.state,
    required this.pincode,
    this.label = 'Home',
    this.isPrimary = false,
  });

  AddressModel copyWith({
    String? id,
    String? fullName,
    String? phoneNumber,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? state,
    String? pincode,
    String? label,
    bool? isPrimary,
  }) {
    return AddressModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      city: city ?? this.city,
      state: state ?? this.state,
      pincode: pincode ?? this.pincode,
      label: label ?? this.label,
      isPrimary: isPrimary ?? this.isPrimary,
    );
  }

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      addressLine1: json['addressLine1'] ?? '',
      addressLine2: json['addressLine2'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      pincode: json['pincode'] ?? '',
      label: json['label'] ?? 'Home',
      isPrimary: json['isPrimary'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'city': city,
      'state': state,
      'pincode': pincode,
      'label': label,
      'isPrimary': isPrimary,
    };
  }

  String get formattedAddress {
    final buffer = StringBuffer();
    buffer.write(addressLine1);
    if (addressLine2.isNotEmpty) {
      buffer.write(', $addressLine2');
    }
    buffer.write(', $city, $state - $pincode');
    return buffer.toString();
  }

  @override
  List<Object?> get props => [
        id,
        fullName,
        phoneNumber,
        addressLine1,
        addressLine2,
        city,
        state,
        pincode,
        label,
        isPrimary,
      ];
}
