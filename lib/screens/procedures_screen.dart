import 'package:flutter/material.dart';
import '../models/procedure.dart';
import '../services/procedures_service.dart';
import '../routes/app_routes.dart';

class ProceduresScreen extends StatelessWidget {
  const ProceduresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final proceduresService = ProceduresService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Procedimentos'),
      ),
      body: FutureBuilder<List<Procedure>>(
        future: proceduresService.getAllProcedures(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Erro: ${snapshot.error}'),
            );
          }

          final procedures = snapshot.data ?? [];

          if (procedures.isEmpty) {
            return const Center(
              child: Text('Nenhum procedimento encontrado'),
            );
          }

          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: procedures.length,
            itemBuilder: (context, index) {
              final procedure = procedures[index];
              return _buildProcedureCard(context, procedure);
            },
          );
        },
      ),
    );
  }

  Widget _buildProcedureCard(BuildContext context, Procedure procedure) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    procedure.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    procedure.formattedPrice,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimaryContainer,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              procedure.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 18,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Text(
                  procedure.formattedDuration,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                const Spacer(),
                FilledButton(
                  onPressed: () {
                    // Ir para escolher profissional
                    Navigator.pushNamed(context, AppRoutes.professionals);
                  },
                  child: const Text('Agendar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

