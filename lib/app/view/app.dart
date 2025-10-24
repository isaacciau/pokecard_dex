import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokecard_dex/app/view/app_view.dart';
import 'package:pokecard_dex/pokemon_cards/bloc/pokemon_card_bloc.dart';
import 'package:pokecard_dex/pokemon_cards/data/repositories/pokemon_card_repository_impl.dart';
import 'package:pokecard_dex/pokemon_cards/domain/repositories/pokemon_card_repository.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<PokemonCardRepository>(
      create: (context) => PokemonCardRepositoryImpl(),
      child: BlocProvider(
        create: (context) => PokemonCardBloc(
          pokemonCardRepository: context.read<PokemonCardRepository>(),
        )..add(CardsFetched()),
        child: const AppView(),
      ),
    );
  }
}
