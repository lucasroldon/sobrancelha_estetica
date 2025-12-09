import '../models/appointment.dart';

class AppointmentsService {
  // Armazenamento mock de agendamentos
  static final List<Appointment> _appointments = [];

  // Horários disponíveis padrão (9h às 18h, de hora em hora)
  static final List<String> _defaultAvailableTimes = [
    '09:00',
    '10:00',
    '11:00',
    '12:00',
    '13:00',
    '14:00',
    '15:00',
    '16:00',
    '17:00',
    '18:00',
  ];

  // Simular delay de rede (simulando backend)
  Future<void> _simulateDelay() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  // Simular validação de backend
  Future<bool> _validateAppointment(Appointment appointment) async {
    await _simulateDelay();
    
    // Validações básicas (permissivas para dados mock)
    if (appointment.professionalId.isEmpty || 
        appointment.procedureId.isEmpty ||
        appointment.time.isEmpty) {
      print('❌ Dados obrigatórios faltando');
      return false;
    }
    
    // Validar apenas se a data estiver muito no passado (mais de 1 dia)
    final now = DateTime.now();
    final appointmentDate = DateTime(
      appointment.date.year,
      appointment.date.month,
      appointment.date.day,
    );
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    
    if (appointmentDate.isBefore(yesterday)) {
      print('❌ Data muito no passado: ${appointmentDate}');
      return false;
    }
    
    return true;
  }

  // Marcar horário (salvar agendamento - mock)
  Future<bool> bookAppointment(Appointment appointment) async {
    try {
      // Simular validação de backend
      final isValid = await _validateAppointment(appointment);
      if (!isValid) {
        print('❌ Validação falhou para agendamento: ${appointment.id}');
        return false;
      }

      // Verificar se o horário já está ocupado
      final isAvailable = await isTimeAvailable(
        appointment.professionalId,
        appointment.date,
        appointment.time,
      );

      if (!isAvailable) {
        print('❌ Horário não disponível: ${appointment.time}');
        return false;
      }

      // Simular salvamento no backend
      await _simulateDelay();

      // Adicionar agendamento (mock storage)
      _appointments.add(appointment);

      // Simular log de sucesso
      print('✅ Agendamento salvo: ${appointment.id}');
      print('   Profissional: ${appointment.professionalId}');
      print('   Data: ${appointment.date}');
      print('   Horário: ${appointment.time}');

      return true;
    } catch (e) {
      print('❌ Erro ao salvar agendamento: $e');
      return false;
    }
  }

  // Verificar se um horário está disponível
  Future<bool> isTimeAvailable(
    String professionalId,
    DateTime date,
    String time,
  ) async {
    await _simulateDelay();

    final dateString = date.toIso8601String().split('T')[0];
    
    return !_appointments.any((apt) =>
        apt.professionalId == professionalId &&
        apt.date.toIso8601String().split('T')[0] == dateString &&
        apt.time == time);
  }

  // Retornar horários disponíveis por profissional e data
  List<String> getAvailableTimes(String professionalId, DateTime date) {
    final dateString = date.toIso8601String().split('T')[0];
    
    // Buscar agendamentos já marcados para este profissional nesta data
    final bookedTimes = _appointments
        .where((apt) =>
            apt.professionalId == professionalId &&
            apt.date.toIso8601String().split('T')[0] == dateString)
        .map((apt) => apt.time)
        .toSet();

    // Retornar horários disponíveis (não marcados)
    return _defaultAvailableTimes
        .where((time) => !bookedTimes.contains(time))
        .toList();
  }

  // Buscar todos os agendamentos
  Future<List<Appointment>> getAllAppointments() async {
    await _simulateDelay();
    return List.from(_appointments);
  }

  // Buscar agendamentos por profissional
  Future<List<Appointment>> getAppointmentsByProfessional(
    String professionalId,
  ) async {
    await _simulateDelay();
    return _appointments
        .where((apt) => apt.professionalId == professionalId)
        .toList();
  }

  // Buscar agendamentos por data
  Future<List<Appointment>> getAppointmentsByDate(DateTime date) async {
    await _simulateDelay();
    final dateString = date.toIso8601String().split('T')[0];
    return _appointments
        .where((apt) =>
            apt.date.toIso8601String().split('T')[0] == dateString)
        .toList();
  }

  // Cancelar agendamento
  Future<bool> cancelAppointment(String appointmentId) async {
    await _simulateDelay();
    final index = _appointments.indexWhere((apt) => apt.id == appointmentId);
    if (index != -1) {
      _appointments.removeAt(index);
      return true;
    }
    return false;
  }

  // Buscar agendamento por ID
  Future<Appointment?> getAppointmentById(String id) async {
    await _simulateDelay();
    try {
      return _appointments.firstWhere((apt) => apt.id == id);
    } catch (e) {
      return null;
    }
  }
}

