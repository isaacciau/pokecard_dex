import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokecard_dex/pokemon_cards/bloc/pokemon_card_bloc.dart';
import 'package:pokecard_dex/pokemon_cards/widgets/bottom_loader.dart';
import 'package:pokecard_dex/pokemon_cards/widgets/card_list_item.dart';

class CardsView extends StatefulWidget {
  const CardsView({super.key});

  @override
  State<CardsView> createState() => _CardsViewState();
}

class _CardsViewState extends State<CardsView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // 1. Añadimos el listener al scroll
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PokéCard Dex')),
      body: BlocBuilder<PokemonCardBloc, PokemonCardState>(
        builder: (context, state) {
          // Usamos un switch para manejar todos los estados
          switch (state.status) {
            case PokemonCardStatus.failure:
              return const Center(child: Text('Fallo al obtener las cartas'));

            case PokemonCardStatus.success:
              if (state.cards.isEmpty) {
                return const Center(child: Text('No se encontraron cartas'));
              }
              // 4. El ListView.builder que construye la lista
              return ListView.builder(
                controller: _scrollController,
                itemCount: state.hasReachedMax
                    ? state
                          .cards
                          .length // Si llegó al final, solo muestra las cartas
                    : state.cards.length +
                          1, // Si no, añade espacio para el loader
                itemBuilder: (BuildContext context, int index) {
                  return index >= state.cards.length
                      ? const BottomLoader() // Muestra el loader al final
                      : CardListItem(
                          card: state.cards[index],
                        ); // Muestra la carta
                },
              );

            case PokemonCardStatus.initial:
              // 3. Muestra un loader mientras carga por primera vez
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    // 5. Limpiamos el controlador para evitar fugas de memoria
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  // 2. La lógica que se dispara al hacer scroll
  void _onScroll() {
    if (_isBottom) context.read<PokemonCardBloc>().add(CardsFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    // Dispara el evento cuando está al 90% del final
    return currentScroll >= (maxScroll * 0.9);
  }
}
