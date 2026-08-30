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
import '../../../admin/domain/models/order_model.dart';
import '../../../profile/domain/models/address_model.dart';
import '../../../profile/presentation/screens/addresses_screen.dart';
import '../../bloc/cart_bloc.dart';
import '../../bloc/cart_event.dart';
import '../../bloc/cart_state.dart';
import 'checkout_success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final FirebaseFirestore _firestore = FirebaseService.instance.firestore;
  AddressModel? _selectedAddress;
  String _paymentMethod = 'UPI / NetBanking';
  bool _isPlacingOrder = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState is! AuthAuthenticated) {
          return _buildAuthRequiredScreen(context);
        }

        final user = authState.user;

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
              'Secure Checkout',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.maroonDeep,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          body: BlocBuilder<CartBloc, CartState>(
            builder: (context, cartState) {
              if (cartState.items.isEmpty) {
                return const Center(child: Text('Your bag is empty.'));
              }

              return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: _firestore.collection('users').doc(user.uid).collection('addresses').snapshots(),
                builder: (context, addressSnapshot) {
                  final docs = addressSnapshot.data?.docs ?? [];
                  final addresses = docs.map((d) {
                    final data = d.data();
                    data['id'] = d.id;
                    return AddressModel.fromJson(data);
                  }).toList();

                  // Auto-select primary address if not chosen
                  if (_selectedAddress == null && addresses.isNotEmpty) {
                    _selectedAddress = addresses.firstWhere(
                      (a) => a.isPrimary,
                      orElse: () => addresses.first,
                    );
                  }

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. Mandatory Shipping Address Section
                        _buildSectionHeader('1. Delivery Address (Mandatory)'),
                        const SizedBox(height: AppSpacing.sm),
                        _buildAddressSelector(context, addresses),
                        const SizedBox(height: AppSpacing.xl),

                        // 2. Insured Armored Delivery Card
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.maroonDeep, AppColors.maroonBlack],
                            ),
                            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                            border: Border.all(color: AppColors.auraGold),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.shield_outlined, color: AppColors.auraGoldLight, size: 28),
                              SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '100% Insured Armored Doorstep Transit',
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                                    ),
                                    Text(
                                      'Tamper-proof security vault box with GPS tracking & OTP delivery confirmation.',
                                      style: TextStyle(color: AppColors.auraGoldLight, fontSize: 11),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xl),

                        // 3. Payment Method
                        _buildSectionHeader('2. Payment Method'),
                        const SizedBox(height: AppSpacing.sm),
                        _buildPaymentSelector(),
                        const SizedBox(height: AppSpacing.xl),

                        // 4. Order Summary Breakdown
                        _buildSectionHeader('3. Order Summary (${cartState.itemCount} items)'),
                        const SizedBox(height: AppSpacing.sm),
                        _buildOrderSummary(cartState),
                        const SizedBox(height: 120),
                      ],
                    ),
                  );
                },
              );
            },
          ),
          bottomSheet: BlocBuilder<CartBloc, CartState>(
            builder: (context, cartState) {
              return Container(
                padding: EdgeInsets.only(
                  left: AppSpacing.xl,
                  right: AppSpacing.xl,
                  top: AppSpacing.md,
                  bottom: MediaQuery.of(context).padding.bottom + AppSpacing.md,
                ),
                decoration: BoxDecoration(
                  color: AppColors.warmWhite,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Total Amount', style: TextStyle(color: AppColors.charcoalMuted, fontSize: 12)),
                        Text(
                          '₹${cartState.total.toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: AppColors.maroonDeep,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.auraGold,
                        foregroundColor: AppColors.maroonBlack,
                        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
                      ),
                      onPressed: _isPlacingOrder ? null : () => _placeOrder(context, user, cartState),
                      child: _isPlacingOrder
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.maroonBlack),
                            )
                          : const Text(
                              'Place Royal Order',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.maroonDeep,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );
  }

  Widget _buildAddressSelector(BuildContext context, List<AddressModel> addresses) {
    if (addresses.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.warmWhite,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(color: Colors.redAccent.withValues(alpha: 0.5)),
        ),
        child: Column(
          children: [
            const Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'No shipping address found. A valid delivery address is mandatory to place your order.',
                    style: TextStyle(color: AppColors.charcoal, fontSize: 13),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            ElevatedButton.icon(
              icon: const Icon(Icons.add_location_alt_outlined),
              label: const Text('Add Shipping Address'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.maroonDeep,
                foregroundColor: AppColors.warmWhite,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => AddressesScreen(
                      isSelectionMode: true,
                      onAddressSelected: (addr) {
                        setState(() => _selectedAddress = addr);
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      );
    }

    final addr = _selectedAddress ?? addresses.first;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.warmWhite,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.auraGold),
        boxShadow: AppShadows.whisper,
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
                ),
                child: Text(
                  addr.label.toUpperCase(),
                  style: const TextStyle(color: AppColors.maroonDeep, fontWeight: FontWeight.bold, fontSize: 10),
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => AddressesScreen(
                        isSelectionMode: true,
                        onAddressSelected: (selected) {
                          setState(() => _selectedAddress = selected);
                        },
                      ),
                    ),
                  );
                },
                child: const Text(
                  'Change Address',
                  style: TextStyle(color: AppColors.maroonDeep, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Text(
            addr.fullName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.charcoal),
          ),
          const SizedBox(height: 4),
          Text(
            addr.formattedAddress,
            style: const TextStyle(color: AppColors.charcoalMuted, fontSize: 13, height: 1.35),
          ),
          const SizedBox(height: 4),
          Text(
            '📞 ${addr.phoneNumber}',
            style: const TextStyle(color: AppColors.charcoalMuted, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSelector() {
    final methods = [
      {'id': 'UPI / NetBanking', 'title': 'Instant UPI / NetBanking / Cards', 'sub': 'Secure 256-bit encrypted gateway'},
      {'id': 'COD', 'title': 'Cash on Armored Delivery', 'sub': 'Pay upon doorstep verification & OTP'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.warmWhite,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.hairlineLight),
      ),
      child: Column(
        children: methods.map((m) {
          final isSel = _paymentMethod == m['id'];
          return RadioListTile<String>(
            activeColor: AppColors.maroonDeep,
            title: Text(m['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            subtitle: Text(m['sub']!, style: const TextStyle(color: AppColors.charcoalMuted, fontSize: 12)),
            value: m['id']!,
            groupValue: _paymentMethod,
            onChanged: (val) {
              if (val != null) setState(() => _paymentMethod = val);
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildOrderSummary(CartState cart) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.warmWhite,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.hairlineLight),
      ),
      child: Column(
        children: [
          ...cart.items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${item.quantity}x ${item.product.name}',
                        style: const TextStyle(fontSize: 13, color: AppColors.charcoal),
                      ),
                    ),
                    Text(
                      '₹${item.totalPrice.toStringAsFixed(0)}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ],
                ),
              )),
          const Divider(),
          _buildRow('Subtotal', '₹${cart.subtotal.toStringAsFixed(0)}'),
          const SizedBox(height: 6),
          _buildRow('Insured Armored Shipping', cart.shipping == 0 ? 'FREE' : '₹${cart.shipping.toStringAsFixed(0)}'),
          const Divider(),
          _buildRow('Grand Total', '₹${cart.total.toStringAsFixed(0)}', isTotal: true),
        ],
      ),
    );
  }

  Widget _buildRow(String title, String val, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            fontSize: isTotal ? 16 : 13,
            color: isTotal ? AppColors.maroonDeep : AppColors.charcoalMuted,
          ),
        ),
        Text(
          val,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: isTotal ? 17 : 13,
            color: isTotal ? AppColors.maroonDeep : AppColors.charcoal,
          ),
        ),
      ],
    );
  }

  Future<void> _placeOrder(BuildContext context, dynamic user, CartState cart) async {
    if (_selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text('Please select or add a valid shipping delivery address.'),
        ),
      );
      return;
    }

    setState(() => _isPlacingOrder = true);

    try {
      final orderId = 'ord_${DateTime.now().millisecondsSinceEpoch}';
      final orderNumber = 'AUR-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
      final order = OrderModel(
        id: orderId,
        orderNumber: orderNumber,
        customerName: user.name.toString().isNotEmpty ? user.name.toString() : 'Royal Patron',
        customerEmail: user.email.toString(),
        customerPhone: _selectedAddress!.phoneNumber,
        shippingAddress: _selectedAddress!.formattedAddress,
        items: cart.items
            .map((i) => OrderItemModel(
                  productId: i.product.id,
                  productName: i.product.name,
                  imageUrl: i.product.imageUrl,
                  unitPrice: i.product.price,
                  quantity: i.quantity,
                  size: i.selectedSize ?? 'Standard',
                  karat: i.product.karat,
                  grossWeightGrams: i.product.grossWeightGrams,
                ))
            .toList(),
        subtotal: cart.subtotal,
        discountAmount: 0,
        taxAmount: 0,
        totalAmount: cart.total,
        status: OrderLifecycleStatus.pending,
        paymentMethod: _paymentMethod,
        paymentStatus: _paymentMethod == 'COD' ? 'Pending' : 'Paid',
        orderDate: DateTime.now(),
      );

      // Save directly to Cloud Firestore /orders and /users/{uid}/orders
      await _firestore.collection('orders').doc(order.id).set(order.toJson());
      await _firestore
          .collection('users')
          .doc(user.uid.toString())
          .collection('orders')
          .doc(order.id)
          .set(order.toJson());

      if (!mounted) return;

      // Clear the Cart
      context.read<CartBloc>().add(CartCleared());

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (ctx) => const CheckoutSuccessScreen(),
        ),
      );
    } catch (e) {
      setState(() => _isPlacingOrder = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text('Failed to place order: $e'),
        ),
      );
    }
  }

  Widget _buildAuthRequiredScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.sandal,
      appBar: AppBar(
        backgroundColor: AppColors.sandal,
        surfaceTintColor: AppColors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.maroonDeep, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Sign In Required'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline, size: 70, color: AppColors.maroonDeep),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Sign In to Place Your Order',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.maroonDeep,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: AppSpacing.sm),
              const Text(
                'Signing in is mandatory to link your order history, jewelry certificates, and insured delivery tracking in Cloud Firestore.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.charcoalMuted, height: 1.4),
              ),
              const SizedBox(height: AppSpacing.xl),
              ElevatedButton.icon(
                icon: const Icon(Icons.login),
                label: const Text('Sign In with Google / Phone'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.maroonDeep,
                  foregroundColor: AppColors.warmWhite,
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (ctx) => const LoginScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
