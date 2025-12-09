class Procedure {
  final String id;
  final String name;
  final String description;
  final int duration; // em minutos
  final double price;

  Procedure({
    required this.id,
    required this.name,
    required this.description,
    required this.duration,
    required this.price,
  });

  // Construtor para criar a partir de JSON
  factory Procedure.fromJson(Map<String, dynamic> json) {
    return Procedure(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      duration: json['duration'] as int,
      price: (json['price'] as num).toDouble(),
    );
  }

  // Método para converter para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'duration': duration,
      'price': price,
    };
  }

  // Cópia com alterações
  Procedure copyWith({
    String? id,
    String? name,
    String? description,
    int? duration,
    double? price,
  }) {
    return Procedure(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      duration: duration ?? this.duration,
      price: price ?? this.price,
    );
  }

  // Método auxiliar para formatar duração
  String get formattedDuration {
    if (duration < 60) {
      return '$duration min';
    }
    final hours = duration ~/ 60;
    final minutes = duration % 60;
    if (minutes == 0) {
      return '$hours h';
    }
    return '$hours h $minutes min';
  }

  // Método auxiliar para formatar preço
  String get formattedPrice {
    return 'R\$ ${price.toStringAsFixed(2).replaceAll('.', ',')}';
  }
}

