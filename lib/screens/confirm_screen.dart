import 'package:flutter/material.dart';
import '../models/professional.dart';
import '../models/procedure.dart';
import '../models/appointment.dart';
import '../services/appointments_service.dart';
import '../services/coupon_service.dart';
import '../routes/app_routes.dart';

class ConfirmScreen extends StatefulWidget {
  const ConfirmScreen({super.key});

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  late Professional _professional;
  late Procedure _procedure;
  late DateTime _selectedDate;
  late String _selectedTime;
  bool _hasCoupon = false;
  double _finalPrice = 0.0;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    _professional = args['professional'] as Professional;
    _procedure = args['procedure'] as Procedure;
    _selectedDate = args['date'] as DateTime;
    _selectedTime = args['time'] as String;
    _calculatePrice();
  }

  Future<void> _calculatePrice() async {
    final couponService = CouponService();
    final coupon = await couponService.getCurrentCoupon();
    final hasCoupon = coupon != null && !coupon.isUsed;

    double finalPrice = _procedure.price;
    if (hasCoupon) {
      finalPrice = await couponService.applyCouponDiscount(_procedure.price);
    }

    if (mounted) {
      setState(() {
        _hasCoupon = hasCoupon;
        _finalPrice = finalPrice;
      });
    }
  }

  Future<void> _finalizeAppointment() async {
    setState(() {
      _loading = true;
    });

    try {
      final appointmentsService = AppointmentsService();
      final couponService = CouponService();

      // Criar agendamento
      final appointment = Appointment(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        professionalId: _professional.id,
        procedureId: _procedure.id,
        clientName: 'Cliente', // TODO: pegar do formulário
        clientPhone: '(00) 00000-0000', // TODO: pegar do formulário
        date: _selectedDate,
        time: _selectedTime,
      );

      final success = await appointmentsService.bookAppointment(appointment);

      if (!success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Erro ao agendar. Tente novamente.'),
            ),
          );
        }
        return;
      }

      // Marcar cupom como usado se aplicável
      if (_hasCoupon) {
        await couponService.useCoupon();
      }

      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.success,
          arguments: appointment,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro: $e'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmar Agendamento'),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card de resumo
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Resumo do Agendamento',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 24),
                    _buildInfoRow(
                      context,
                      Icons.person,
                      'Profissional',
                      _professional.name,
                    ),
                    const Divider(height: 32),
                    _buildInfoRow(
                      context,
                      Icons.spa,
                      'Procedimento',
                      _procedure.name,
                    ),
                    const Divider(height: 32),
                    _buildInfoRow(
                      context,
                      Icons.calendar_today,
                      'Data',
                      _formatDate(_selectedDate),
                    ),
                    const Divider(height: 32),
                    _buildInfoRow(
                      context,
                      Icons.access_time,
                      'Horário',
                      _selectedTime,
                    ),
                    const Divider(height: 32),
                    if (_hasCoupon) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.attach_money,
                                size: 20,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Preço Original',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                          Text(
                            _procedure.formattedPrice,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                  decoration: TextDecoration.lineThrough,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.local_offer,
                                color: Colors.green,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Desconto (10%)',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                          Text(
                            '- R\$ ${(_procedure.price - _finalPrice).toStringAsFixed(2).replaceAll('.', ',')}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                      const Divider(height: 32),
                    ],
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.payments,
                              size: 24,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Total',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        Text(
                          'R\$ ${_finalPrice.toStringAsFixed(2).replaceAll('.', ',')}',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Botão Finalizar
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _loading ? null : _finalizeAppointment,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Confirmar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Fev',
      'Mar',
      'Abr',
      'Mai',
      'Jun',
      'Jul',
      'Ago',
      'Set',
      'Out',
      'Nov',
      'Dez',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

