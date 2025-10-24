import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // 1. Importa go_router
import 'package:pokecard_dex/pokemon_cards/domain/entities/pokemon_card.dart';

class CardListItem extends StatelessWidget {
  const CardListItem({required this.card, super.key});

  final PokemonCard card;

  @override
  Widget build(BuildContext context) {
    // 2. Envuelve el Card con un InkWell
    return InkWell(
      onTap: () {
        // 3. Navega a la ruta de detalle.
        //    Pasamos el ID de la carta en la URL.
        context.go('/card/${card.id}');
      },
      child: Card(
        // El Card original va adentro
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListTile(
          leading: Image.network(
            card.imageUrl,
            width: 50,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const SizedBox(
                width: 50,
                height: 50,
                child: Center(child: CircularProgressIndicator()),
              );
            },
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.error),
          ),
          title: Text(card.name),
          subtitle: Text('HP: ${card.hp ?? 'N/A'} - ${card.supertype ?? ''}'),
          dense: true,
        ),
      ),
    );
  }
}
