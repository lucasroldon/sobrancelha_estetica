class Appointment {
  final String id;
  final String professionalId;
  final String procedureId;
  final String clientName;
  final String clientPhone;
  final DateTime date;
  final String time; // formato HH:mm

  Appointment({
    required this.id,
    required this.professionalId,
    required this.procedureId,
    required this.clientName,
    required this.clientPhone,
    required this.date,
    required this.time,
  });

  // Construtor para criar a partir de JSON
  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'] as String,
      professionalId: json['professionalId'] as String,
      procedureId: json['procedureId'] as String,
      clientName: json['clientName'] as String,
      clientPhone: json['clientPhone'] as String,
      date: DateTime.parse(json['date'] as String),
      time: json['time'] as String,
    );
  }

  // Método para converter para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'professionalId': professionalId,
      'procedureId': procedureId,
      'clientName': clientName,
      'clientPhone': clientPhone,
      'date': date.toIso8601String().split('T')[0], // apenas a data (YYYY-MM-DD)
      'time': time,
    };
  }

  // Cópia com alterações
  Appointment copyWith({
    String? id,
    String? professionalId,
    String? procedureId,
    String? clientName,
    String? clientPhone,
    DateTime? date,
    String? time,
  }) {
    return Appointment(
      id: id ?? this.id,
      professionalId: professionalId ?? this.professionalId,
      procedureId: procedureId ?? this.procedureId,
      clientName: clientName ?? this.clientName,
      clientPhone: clientPhone ?? this.clientPhone,
      date: date ?? this.date,
      time: time ?? this.time,
    );
  }

  // Método auxiliar para obter DateTime completo
  DateTime get dateTime {
    final timeParts = time.split(':');
    return DateTime(
      date.year,
      date.month,
      date.day,
      int.parse(timeParts[0]),
      int.parse(timeParts[1]),
    );
  }

  // Método auxiliar para verificar se o agendamento já passou
  bool get isPast {
    return dateTime.isBefore(DateTime.now());
  }
}

