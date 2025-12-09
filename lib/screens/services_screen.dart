import 'package:flutter/material.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Serviços'),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nossos Serviços',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            _buildServiceCard(
              context,
              'Design de Sobrancelhas',
              'Criação de design personalizado para realçar sua beleza natural',
              Icons.brush_outlined,
            ),
            const SizedBox(height: 16),
            _buildServiceCard(
              context,
              'Micropigmentação',
              'Técnica avançada de pigmentação para resultados duradouros',
              Icons.colorize_outlined,
            ),
            const SizedBox(height: 16),
            _buildServiceCard(
              context,
              'Henna',
              'Coloração temporária com henna natural',
              Icons.eco_outlined,
            ),
            const SizedBox(height: 16),
            _buildServiceCard(
              context,
              'Remoção de Pelos',
              'Depilação com linha ou pinça para acabamento perfeito',
              Icons.content_cut_outlined,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 32,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

