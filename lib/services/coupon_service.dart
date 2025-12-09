import 'package:shared_preferences/shared_preferences.dart';
import '../models/coupon.dart';

class CouponService {
  static const String _keyHasUsedCoupon = 'hasUsedCoupon';
  static const String _keyCouponCreated = 'couponCreated';
  static const String _keyCouponId = 'couponId';
  static const String _keyCouponDescription = 'couponDescription';
  static const String _keyCouponDiscountPercent = 'couponDiscountPercent';

  // Criar cupom no primeiro uso
  Future<void> createFirstCouponIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Verificar se o cupom já foi criado
    final couponCreated = prefs.getBool(_keyCouponCreated) ?? false;
    
    if (!couponCreated) {
      // Criar cupom de 10% OFF
      final coupon = Coupon(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        description: '10% OFF no primeiro procedimento',
        discountPercent: 10.0,
        isUsed: false,
      );

      // Salvar no SharedPreferences
      await prefs.setBool(_keyCouponCreated, true);
      await prefs.setBool(_keyHasUsedCoupon, false);
      await prefs.setString(_keyCouponId, coupon.id);
      await prefs.setString(_keyCouponDescription, coupon.description);
      await prefs.setDouble(_keyCouponDiscountPercent, coupon.discountPercent);
    }
  }

  // Buscar cupom atual
  Future<Coupon?> getCurrentCoupon() async {
    final prefs = await SharedPreferences.getInstance();
    
    final couponCreated = prefs.getBool(_keyCouponCreated) ?? false;
    if (!couponCreated) {
      return null;
    }

    final hasUsedCoupon = prefs.getBool(_keyHasUsedCoupon) ?? false;
    final id = prefs.getString(_keyCouponId) ?? '';
    final description = prefs.getString(_keyCouponDescription) ?? '';
    final discountPercent = prefs.getDouble(_keyCouponDiscountPercent) ?? 0.0;

    return Coupon(
      id: id,
      description: description,
      discountPercent: discountPercent,
      isUsed: hasUsedCoupon,
    );
  }

  // Verificar se o cupom foi usado
  Future<bool> hasUsedCoupon() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyHasUsedCoupon) ?? false;
  }

  // Verificar se o cupom foi criado
  Future<bool> isCouponCreated() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyCouponCreated) ?? false;
  }

  // Usar o cupom
  Future<bool> useCoupon() async {
    final prefs = await SharedPreferences.getInstance();
    
    final hasUsed = prefs.getBool(_keyHasUsedCoupon) ?? false;
    if (hasUsed) {
      return false; // Cupom já foi usado
    }

    await prefs.setBool(_keyHasUsedCoupon, true);
    return true;
  }

  // Resetar cupom (útil para testes)
  Future<void> resetCoupon() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyHasUsedCoupon);
    await prefs.remove(_keyCouponCreated);
    await prefs.remove(_keyCouponId);
    await prefs.remove(_keyCouponDescription);
    await prefs.remove(_keyCouponDiscountPercent);
  }

  // Aplicar desconto do cupom em um preço
  Future<double> applyCouponDiscount(double originalPrice) async {
    final coupon = await getCurrentCoupon();
    
    if (coupon == null || coupon.isUsed) {
      return originalPrice; // Sem desconto
    }

    return coupon.calculateFinalPrice(originalPrice);
  }

  // Retornar cupom disponível (não usado)
  Future<Coupon?> getAvailableCoupon() async {
    final coupon = await getCurrentCoupon();
    
    if (coupon == null || coupon.isUsed) {
      return null; // Sem cupom disponível
    }

    return coupon;
  }
}

