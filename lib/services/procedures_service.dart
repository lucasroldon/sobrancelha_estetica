import '../models/procedure.dart';

class ProceduresService {
  // Dados mock de procedimentos
  static final List<Procedure> _procedures = [
    Procedure(
      id: '1',
      name: 'Nanoblading',
      description: 'Fios Naturais.',
      duration: 90, // 1 hora e 30 minutos
      price: 900.00,
    ),
    Procedure(
      id: '2',
      name: 'Design Personalizado',
      description: 'Design personalizado visando a harmonia facial.',
      duration: 30, // 30 minutos
      price: 75.00,
    ),
    Procedure(
      id: '3',
      name: 'Design Personalizado com Henna',
      description: 'Coloração temporária das sobrancelhas com henna.',
      duration: 40, // 40 minutos
      price: 100.00,
    ),
    Procedure(
      id: '4',
      name: 'Design Personalizado com Tintura',
      description: 'Coloração somente dos pelos.',
      duration: 40, // 40 minutos
      price: 125.00,
    ),
    Procedure(
      id: '5',
      name: 'Design Brow',
      description: 'Técnica que alinha e fixa os pelos das sobrancelhas.',
      duration: 60, // 1 hora
      price: 150.00,
    ),
    Procedure(
      id: '6',
      name: 'Lash Lifting',
      description: 'Cílios curvados e alongados de forma natural.',
      duration: 70, // 1 hora e 10 minutos
      price: 150.00,
    ),
    Procedure(
      id: '7',
      name: 'Depilação Egípcia',
      description: 'Depilação com linha sem agredir a pele.',
      duration: 30, // 30 minutos
      price: 75.00,
    ),
    Procedure(
      id: '8',
      name: 'Nutri Gloss',
      description: 'Microagulhamento para promover a hidratação profunda dos lábios.',
      duration: 30, // 30 minutos
      price: 200.00,
    ),
    Procedure(
      id: '9',
      name: 'Micropigmentação Labial',
      description: 'Revitalizar a cor natural dos lábios e definir o desenho.',
      duration: 60, // 1 hora
      price: 790.00,
    ),
    Procedure(
      id: '10',
      name: 'Remoção a Laser',
      description: 'Remover de micropigmentação antiga e tatuagem.',
      duration: 30, // 30 minutos
      price: 300.00,
    ),
  ];

  // Simular delay de rede
  Future<void> _simulateDelay() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  // Buscar todos os procedimentos
  Future<List<Procedure>> getAllProcedures() async {
    await _simulateDelay();
    return List.from(_procedures);
  }

  // Buscar procedimento por ID
  Future<Procedure?> getProcedureById(String id) async {
    await _simulateDelay();
    try {
      return _procedures.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  // Buscar procedimentos por nome (busca parcial)
  Future<List<Procedure>> searchProcedures(String query) async {
    await _simulateDelay();
    final lowerQuery = query.toLowerCase();
    return _procedures
        .where((p) =>
            p.name.toLowerCase().contains(lowerQuery) ||
            p.description.toLowerCase().contains(lowerQuery))
        .toList();
  }

  // Buscar procedimentos por faixa de preço
  Future<List<Procedure>> getProceduresByPriceRange({
    double? minPrice,
    double? maxPrice,
  }) async {
    await _simulateDelay();
    return _procedures.where((p) {
      if (minPrice != null && p.price < minPrice) return false;
      if (maxPrice != null && p.price > maxPrice) return false;
      return true;
    }).toList();
  }
}

