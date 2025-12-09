class Professional {
  final String id;
  final String name;
  final String? photoUrl;
  final List<String> specialties;
  final int clientsCount;

  Professional({
    required this.id,
    required this.name,
    this.photoUrl,
    required this.specialties,
    required this.clientsCount,
  });

  // Construtor para criar a partir de JSON
  factory Professional.fromJson(Map<String, dynamic> json) {
    return Professional(
      id: json['id'] as String,
      name: json['name'] as String,
      photoUrl: json['photoUrl'] as String?,
      specialties: List<String>.from(json['specialties'] as List),
      clientsCount: json['clientsCount'] as int,
    );
  }

  // Método para converter para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'photoUrl': photoUrl,
      'specialties': specialties,
      'clientsCount': clientsCount,
    };
  }

  // Cópia com alterações
  Professional copyWith({
    String? id,
    String? name,
    String? photoUrl,
    List<String>? specialties,
    int? clientsCount,
  }) {
    return Professional(
      id: id ?? this.id,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      specialties: specialties ?? this.specialties,
      clientsCount: clientsCount ?? this.clientsCount,
    );
  }

  // Método auxiliar para formatar quantidade de clientes
  String get formattedClientsCount {
    if (clientsCount >= 1000) {
      final thousands = clientsCount / 1000;
      if (thousands % 1 == 0) {
        return '${thousands.toInt()} mil';
      }
      return '${thousands.toStringAsFixed(1)} mil';
    }
    return clientsCount.toString();
  }
}

