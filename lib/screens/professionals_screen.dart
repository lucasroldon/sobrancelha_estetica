import 'package:flutter/material.dart';
import '../models/professional.dart';
import '../services/professionals_service.dart';
import '../routes/app_routes.dart';

class ProfessionalsScreen extends StatelessWidget {
  const ProfessionalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final professionalsService = ProfessionalsService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profissionais'),
      ),
      body: FutureBuilder<List<Professional>>(
        future: professionalsService.getAllProfessionals(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Erro: ${snapshot.error}'),
            );
          }

          final professionals = snapshot.data ?? [];

          if (professionals.isEmpty) {
            return const Center(
              child: Text('Nenhum profissional encontrado'),
            );
          }

          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: professionals.length,
            itemBuilder: (context, index) {
              final professional = professionals[index];
              return _buildProfessionalCard(context, professional);
            },
          );
        },
      ),
    );
  }

  Widget _buildProfessionalCard(
    BuildContext context,
    Professional professional,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.professionalDetails,
            arguments: professional,
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Foto
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: professional.photoUrl != null
                    ? Image.network(
                        professional.photoUrl!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildPlaceholderAvatar(context),
                      )
                    : _buildPlaceholderAvatar(context),
              ),
              const SizedBox(width: 16),
              
              // Informações
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      professional.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Especialidades
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: professional.specialties.take(2).map((spec) {
                        return Chip(
                          label: Text(
                            spec,
                            style: const TextStyle(fontSize: 11),
                          ),
                          padding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 8),
                    
                    // Quantidade de clientes
                    Row(
                      children: [
                        Icon(
                          Icons.people,
                          color: Theme.of(context).colorScheme.primary,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'Mais de ${professional.formattedClientsCount} clientes atendidos',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ],
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

  Widget _buildPlaceholderAvatar(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        Icons.person,
        size: 40,
        color: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
    );
  }
}

