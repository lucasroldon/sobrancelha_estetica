class Coupon {
  final String id;
  final String description;
  final double discountPercent;
  final bool isUsed;

  Coupon({
    required this.id,
    required this.description,
    required this.discountPercent,
    this.isUsed = false,
  });

  // Construtor para criar a partir de JSON
  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      id: json['id'] as String,
      description: json['description'] as String,
      discountPercent: (json['discountPercent'] as num).toDouble(),
      isUsed: json['isUsed'] as bool? ?? false,
    );
  }

  // Método para converter para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'discountPercent': discountPercent,
      'isUsed': isUsed,
    };
  }

  // Cópia com alterações
  Coupon copyWith({
    String? id,
    String? description,
    double? discountPercent,
    bool? isUsed,
  }) {
    return Coupon(
      id: id ?? this.id,
      description: description ?? this.description,
      discountPercent: discountPercent ?? this.discountPercent,
      isUsed: isUsed ?? this.isUsed,
    );
  }

  // Método auxiliar para calcular desconto em um valor
  double calculateDiscount(double originalPrice) {
    return originalPrice * (discountPercent / 100);
  }

  // Método auxiliar para calcular preço final com desconto
  double calculateFinalPrice(double originalPrice) {
    return originalPrice - calculateDiscount(originalPrice);
  }

  // Método auxiliar para formatar percentual de desconto
  String get formattedDiscount {
    return '${discountPercent.toStringAsFixed(0)}%';
  }
}

