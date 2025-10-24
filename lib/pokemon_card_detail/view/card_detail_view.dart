import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokecard_dex/pokemon_card_detail/bloc/card_detail_bloc.dart';

class CardDetailView extends StatelessWidget {
  const CardDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalles de la Carta')),
      // 1. Escuchamos los cambios del BLoC
      body: BlocBuilder<CardDetailBloc, CardDetailState>(
        builder: (context, state) {
          // 2. Manejamos los diferentes estados
          switch (state.status) {
            case CardDetailStatus.initial:
            case CardDetailStatus.loading:
              // Muestra un loader mientras carga
              return const Center(child: CircularProgressIndicator());

            case CardDetailStatus.failure:
              // Muestra un error si falla
              return const Center(child: Text('Error al cargar la carta'));

            case CardDetailStatus.success:
              // 3. Muestra los detalles de la carta
              final card = state.card;
              if (card == null) {
                return const Center(child: Text('No se encontró la carta'));
              }

              // Un widget simple para mostrar la imagen y los datos
              return Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          card.name,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'HP: ${card.hp ?? 'N/A'} - '
                          'Tipo: ${card.supertype ?? 'N/A'}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 24),
                        // Mostramos la imagen grande
                        Image.network(
                          card.imageUrl,
                          fit: BoxFit.contain,
                          loadingBuilder:
                              (
                                BuildContext context,
                                Widget child,
                                ImageChunkEvent? loadingProgress,
                              ) {
                                if (loadingProgress == null) return child;
                                return const CircularProgressIndicator();
                              },
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.error, size: 50),
                        ),
                      ],
                    ),
                  ),
                ),
              );
          }
        },
      ),
    );
  }
}
