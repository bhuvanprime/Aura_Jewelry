import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/firebase/firebase_service.dart';
import '../../../auth/bloc/auth_bloc.dart';
import '../../../auth/bloc/auth_state.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import '../../domain/models/address_model.dart';

class AddressesScreen extends StatefulWidget {
  final bool isSelectionMode;
  final ValueChanged<AddressModel>? onAddressSelected;

  const AddressesScreen({
    super.key,
    this.isSelectionMode = false,
    this.onAddressSelected,
  });

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  final FirebaseFirestore _firestore = FirebaseService.instance.firestore;

  String? _getUserId(BuildContext context) {
    final state = context.read<AuthBloc>().state;
    if (state is AuthAuthenticated) {
      return state.user.id;
    }
    return null;
  }

  void _showAddEditAddressSheet({AddressModel? existingAddress}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.sandal,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusXl)),
      ),
      builder: (ctx) => _AddEditAddressForm(
        existingAddress: existingAddress,
        onSave: (address) async {
          final uid = _getUserId(context);
          if (uid != null) {
            final col = _firestore.collection('users').doc(uid).collection('addresses');
            if (address.isPrimary) {
              // Unset other primary addresses
              final all = await col.get();
              for (final doc in all.docs) {
                if (doc.id != address.id && doc.data()['isPrimary'] == true) {
                  await doc.reference.update({'isPrimary': false});
                }
              }
            }
            await col.doc(address.id).set(address.toJson(), SetOptions(merge: true));
          }
          if (mounted) {
            Navigator.pop(ctx);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: AppColors.maroonDeep,
                content: Text(existingAddress == null ? 'Address added successfully!' : 'Address updated!'),
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> _setAsPrimary(AddressModel address) async {
    final uid = _getUserId(context);
    if (uid == null) return;

    final col = _firestore.collection('users').doc(uid).collection('addresses');
    final all = await col.get();
    for (final doc in all.docs) {
      await doc.reference.update({'isPrimary': doc.id == address.id});
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.maroonDeep,
          content: Text('${address.label} set as Primary Delivery Address.'),
        ),
      );
    }
  }

  Future<void> _deleteAddress(String addressId) async {
    final uid = _getUserId(context);
    if (uid == null) return;

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('addresses')
        .doc(addressId)
        .delete();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.maroonDeep,
          content: Text('Address removed.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final isAuthenticated = authState is AuthAuthenticated;
        final uid = isAuthenticated ? authState.user.id : null;

        return Scaffold(
          backgroundColor: AppColors.sandal,
          appBar: AppBar(
            backgroundColor: AppColors.sandal,
            surfaceTintColor: AppColors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.maroonDeep, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              widget.isSelectionMode ? 'Select Delivery Address' : 'Shipping Addresses',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.maroonDeep,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          body: !isAuthenticated
              ? _buildLoginPrompt(context)
              : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: _firestore.collection('users').doc(uid).collection('addresses').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(color: AppColors.maroonDeep),
                      );
                    }

                    final docs = snapshot.data?.docs ?? [];
                    final addresses = docs.map((d) {
                      final data = d.data();
                      data['id'] = d.id;
                      return AddressModel.fromJson(data);
                    }).toList();

                    if (addresses.isEmpty) {
                      return _buildEmptyAddresses();
                    }

                    // Sort primary first
                    addresses.sort((a, b) => (b.isPrimary ? 1 : 0).compareTo(a.isPrimary ? 1 : 0));

                    return ListView.separated(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      itemCount: addresses.length,
                      separatorBuilder: (ctx, idx) => const SizedBox(height: AppSpacing.md),
                      itemBuilder: (ctx, idx) {
                        final addr = addresses[idx];
                        return _buildAddressCard(addr);
                      },
                    );
                  },
                ),
          floatingActionButton: isAuthenticated
              ? FloatingActionButton.extended(
                  backgroundColor: AppColors.auraGold,
                  foregroundColor: AppColors.maroonBlack,
                  icon: const Icon(Icons.add_location_alt_outlined),
                  label: const Text(
                    'Add New Address',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () => _showAddEditAddressSheet(),
                )
              : null,
        );
      },
    );
  }

  Widget _buildLoginPrompt(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline, size: 64, color: AppColors.maroonDeep),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Sign In Required',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.maroonDeep,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppSpacing.sm),
            const Text(
              'Please sign in with your account to view, save, and manage your delivery addresses in Cloud Firestore.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.charcoalMuted, height: 1.4),
            ),
            const SizedBox(height: AppSpacing.xl),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.maroonDeep,
                foregroundColor: AppColors.warmWhite,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (ctx) => const LoginScreen()),
                );
              },
              child: const Text('Sign In to Continue'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyAddresses() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_off_outlined, size: 70, color: AppColors.charcoalFaint),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'No Saved Addresses',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.maroonDeep,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppSpacing.sm),
            const Text(
              'Add your delivery address for insured armored doorstep jewelry deliveries.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.charcoalMuted),
            ),
            const SizedBox(height: AppSpacing.xl),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Add Delivery Address'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.auraGold,
                foregroundColor: AppColors.maroonBlack,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
              onPressed: () => _showAddEditAddressSheet(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressCard(AddressModel address) {
    return GestureDetector(
      onTap: () {
        if (widget.isSelectionMode && widget.onAddressSelected != null) {
          widget.onAddressSelected!(address);
          Navigator.pop(context);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.warmWhite,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(
            color: address.isPrimary ? AppColors.auraGold : AppColors.hairlineLight,
            width: address.isPrimary ? 1.5 : 1.0,
          ),
          boxShadow: address.isPrimary ? AppShadows.soft : AppShadows.whisper,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.sandal,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.hairlineLight),
                  ),
                  child: Text(
                    address.label.toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.maroonDeep,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                if (address.isPrimary) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      gradient: AppColors.goldCta,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'PRIMARY',
                      style: TextStyle(
                        color: AppColors.maroonBlack,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 18, color: AppColors.charcoalMuted),
                  onPressed: () => _showAddEditAddressSheet(existingAddress: address),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 18, color: Colors.redAccent),
                  onPressed: () => _deleteAddress(address.id),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              address.fullName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: AppColors.charcoal,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              address.formattedAddress,
              style: const TextStyle(
                color: AppColors.charcoalMuted,
                fontSize: 13,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.phone_outlined, size: 14, color: AppColors.charcoalFaint),
                const SizedBox(width: 4),
                Text(
                  address.phoneNumber,
                  style: const TextStyle(color: AppColors.charcoalMuted, fontSize: 12),
                ),
              ],
            ),
            if (!address.isPrimary) ...[
              const Divider(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  icon: const Icon(Icons.check_circle_outline, size: 16, color: AppColors.maroonDeep),
                  label: const Text(
                    'Set as Primary',
                    style: TextStyle(
                      color: AppColors.maroonDeep,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  onPressed: () => _setAsPrimary(address),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AddEditAddressForm extends StatefulWidget {
  final AddressModel? existingAddress;
  final ValueChanged<AddressModel> onSave;

  const _AddEditAddressForm({this.existingAddress, required this.onSave});

  @override
  State<_AddEditAddressForm> createState() => _AddEditAddressFormState();
}

class _AddEditAddressFormState extends State<_AddEditAddressForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _line1Ctrl;
  late TextEditingController _line2Ctrl;
  late TextEditingController _cityCtrl;
  late TextEditingController _stateCtrl;
  late TextEditingController _pincodeCtrl;
  String _label = 'Home';
  bool _isPrimary = false;

  @override
  void initState() {
    super.initState();
    final a = widget.existingAddress;
    _nameCtrl = TextEditingController(text: a?.fullName ?? '');
    _phoneCtrl = TextEditingController(text: a?.phoneNumber ?? '');
    _line1Ctrl = TextEditingController(text: a?.addressLine1 ?? '');
    _line2Ctrl = TextEditingController(text: a?.addressLine2 ?? '');
    _cityCtrl = TextEditingController(text: a?.city ?? 'Jaipur');
    _stateCtrl = TextEditingController(text: a?.state ?? 'Rajasthan');
    _pincodeCtrl = TextEditingController(text: a?.pincode ?? '');
    _label = a?.label ?? 'Home';
    _isPrimary = a?.isPrimary ?? false;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _line1Ctrl.dispose();
    _line2Ctrl.dispose();
    _cityCtrl.dispose();
    _stateCtrl.dispose();
    _pincodeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.xl,
        right: AppSpacing.xl,
        top: AppSpacing.xl,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.existingAddress == null ? 'Add Delivery Address' : 'Edit Address',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppColors.maroonDeep,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Full Name *', prefixIcon: Icon(Icons.person_outline)),
                validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Contact Phone Number *', prefixIcon: Icon(Icons.phone_outlined)),
                validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _line1Ctrl,
                decoration: const InputDecoration(labelText: 'House / Flat / Street Address *', prefixIcon: Icon(Icons.home_outlined)),
                validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _line2Ctrl,
                decoration: const InputDecoration(labelText: 'Area / Landmark (Optional)', prefixIcon: Icon(Icons.pin_drop_outlined)),
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _cityCtrl,
                      decoration: const InputDecoration(labelText: 'City *'),
                      validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: TextFormField(
                      controller: _stateCtrl,
                      decoration: const InputDecoration(labelText: 'State *'),
                      validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _pincodeCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Pincode (6-digit) *', prefixIcon: Icon(Icons.markunread_mailbox_outlined)),
                validator: (v) => v == null || v.trim().length != 6 ? 'Enter valid 6-digit pincode' : null,
              ),
              const SizedBox(height: AppSpacing.md),
              // Address Type Selector
              Row(
                children: ['Home', 'Work', 'Villa'].map((type) {
                  final isSel = _label == type;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(type),
                      selected: isSel,
                      selectedColor: AppColors.auraGold,
                      onSelected: (val) {
                        if (val) setState(() => _label = type);
                      },
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSpacing.sm),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Make this my Primary Delivery Address'),
                value: _isPrimary,
                activeColor: AppColors.maroonDeep,
                onChanged: (val) {
                  setState(() => _isPrimary = val ?? false);
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.maroonDeep,
                    foregroundColor: AppColors.warmWhite,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
                  ),
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      final id = widget.existingAddress?.id ?? 'addr_${DateTime.now().millisecondsSinceEpoch}';
                      final addr = AddressModel(
                        id: id,
                        fullName: _nameCtrl.text.trim(),
                        phoneNumber: _phoneCtrl.text.trim(),
                        addressLine1: _line1Ctrl.text.trim(),
                        addressLine2: _line2Ctrl.text.trim(),
                        city: _cityCtrl.text.trim(),
                        state: _stateCtrl.text.trim(),
                        pincode: _pincodeCtrl.text.trim(),
                        label: _label,
                        isPrimary: _isPrimary,
                      );
                      widget.onSave(addr);
                    }
                  },
                  child: Text(
                    widget.existingAddress == null ? 'Save Address' : 'Update Address',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
