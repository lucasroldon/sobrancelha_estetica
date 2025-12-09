import '../models/professional.dart';

class ProfessionalsService {
  // Dados mock de profissionais
  static final List<Professional> _professionals = [
    Professional(
      id: '1',
      name: 'Beatriz Cardoso',
      photoUrl: 'https://i.pravatar.cc/150?img=1',
      specialties: [
        'Design Personalizado',
        'Design Personalizado com Henna',
        'Design Personalizado com Tintura',
        'Design Brow',
        'Lash Lifting',
        'Depilação Egípcia',
        'Nutri Gloss',
      ],
      clientsCount: 1000,
    ),
    Professional(
      id: '2',
      name: 'Anne Pavlova',
      photoUrl: 'https://i.pravatar.cc/150?img=2',
      specialties: [
        'Nanoblading',
        'Design Personalizado',
        'Design Personalizado com Henna',
        'Design Personalizado com Tintura',
        'Design Brow',
        'Lash Lifting',
        'Depilação Egípcia',
        'Micropigmentação Labial',
        'Remoção a laser',
        'Nutri Gloss',
      ],
      clientsCount: 5000,
    ),
  ];

  // Simular delay de rede
  Future<void> _simulateDelay() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  // Buscar todos os profissionais
  Future<List<Professional>> getAllProfessionals() async {
    await _simulateDelay();
    return List.from(_professionals);
  }

  // Buscar profissional por ID
  Future<Professional?> getProfessionalById(String id) async {
    await _simulateDelay();
    try {
      return _professionals.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  // Buscar profissionais por especialidade
  Future<List<Professional>> getProfessionalsBySpecialty(String specialty) async {
    await _simulateDelay();
    return _professionals
        .where((p) => p.specialties.contains(specialty))
        .toList();
  }

  // Buscar profissionais com mais clientes
  Future<List<Professional>> getTopProfessionals({int limit = 3}) async {
    await _simulateDelay();
    final sorted = List<Professional>.from(_professionals)
      ..sort((a, b) => b.clientsCount.compareTo(a.clientsCount));
    return sorted.take(limit).toList();
  }
}

