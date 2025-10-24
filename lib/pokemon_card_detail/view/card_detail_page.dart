import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokecard_dex/pokemon_card_detail/bloc/card_detail_bloc.dart';
import 'package:pokecard_dex/pokemon_card_detail/view/card_detail_view.dart';
import 'package:pokecard_dex/pokemon_cards/data/repositories/pokemon_card_repository_impl.dart';

class CardDetailPage extends StatelessWidget {
  const CardDetailPage({
    required this.cardId,
    super.key,
  });

  final String cardId;

  @override
  Widget build(BuildContext context) {
    // 1. Creamos y proveemos el nuevo BLoC
    return BlocProvider(
      create: (context) =>
          CardDetailBloc(
            // Reutilizamos el mismo repositorio que ya teníamos
            pokemonCardRepository: PokemonCardRepositoryImpl(),
          )..add(
            CardDetailFetched(id: cardId),
          ), // 2. Disparamos el evento inicial con el ID
      child: const CardDetailView(), // 3. Mostramos la vista
    );
  }
}
