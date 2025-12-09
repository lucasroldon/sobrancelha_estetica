import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../routes/app_routes.dart';
import '../services/coupon_service.dart';
import '../models/coupon.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Coupon? _coupon;

  @override
  void initState() {
    super.initState();
    _initializeCoupon();
  }

  Future<void> _initializeCoupon() async {
    final couponService = CouponService();
    // Criar cupom se não existir (primeira vez abrindo o app)
    await couponService.createFirstCouponIfNeeded();
    // Carregar cupom atual
    await _loadCoupon();
  }

  Future<void> _loadCoupon() async {
    final couponService = CouponService();
    final coupon = await couponService.getCurrentCoupon();
    if (mounted) {
      setState(() {
        _coupon = coupon;
      });
    }
  }

  void _exitApp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair do App'),
        content: const Text('Deseja realmente sair do aplicativo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              SystemNavigator.pop();
            },
            child: const Text('Sair'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasCoupon = _coupon != null && !_coupon!.isUsed;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Brow App'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Banner do Cupom
            if (hasCoupon)
              Container(
                margin: const EdgeInsets.only(bottom: 24),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.primaryContainer,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.local_offer,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 32,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Promoção Especial!',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.onPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _coupon!.description,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.onPrimary,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            // Botão Agendar Horário
            _buildActionButton(
              context,
              'Agendar Horário',
              Icons.calendar_today,
              Colors.blue,
              () => Navigator.pushNamed(context, AppRoutes.professionals),
            ),
            const SizedBox(height: 12),

            // Botão Procedimentos
            _buildActionButton(
              context,
              'Procedimentos',
              Icons.spa,
              Colors.purple,
              () => Navigator.pushNamed(context, AppRoutes.procedures),
            ),
            const SizedBox(height: 12),

            // Botão Profissionais
            _buildActionButton(
              context,
              'Profissionais',
              Icons.people,
              Colors.orange,
              () => Navigator.pushNamed(context, AppRoutes.professionals),
            ),
            const SizedBox(height: 24),

            // Botão Sair
            OutlinedButton.icon(
              onPressed: _exitApp,
              icon: const Icon(Icons.exit_to_app),
              label: const Text('Sair do App'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 20,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
