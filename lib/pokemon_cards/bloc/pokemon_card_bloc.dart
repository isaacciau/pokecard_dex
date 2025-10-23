import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:pokecard_dex/pokemon_cards/domain/entities/pokemon_card.dart';
import 'package:pokecard_dex/pokemon_cards/domain/repositories/pokemon_card_repository.dart';
import 'package:stream_transform/stream_transform.dart';

part 'pokemon_card_event.dart';
part 'pokemon_card_state.dart';

// Duración para evitar el spam de peticiones al hacer scroll
const _throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class PokemonCardBloc extends Bloc<PokemonCardEvent, PokemonCardState> {
  PokemonCardBloc({required PokemonCardRepository pokemonCardRepository})
    : _pokemonCardRepository = pokemonCardRepository,
      super(const PokemonCardState()) {
    on<CardsFetched>(
      _onCardsFetched,
      // Usamos el 'transformer' para el throttle
      transformer: throttleDroppable(_throttleDuration),
    );
  }

  final PokemonCardRepository _pokemonCardRepository;
  int _currentPage = 1; // Variable interna para paginación

  Future<void> _onCardsFetched(
    CardsFetched event,
    Emitter<PokemonCardState> emit,
  ) async {
    // Si ya llegamos al final, no hacemos nada
    if (state.hasReachedMax) return;

    try {
      // Si es la primera vez que carga (initial)
      if (state.status == PokemonCardStatus.initial) {
        final cards = await _pokemonCardRepository.getCards(page: _currentPage);
        _currentPage++;
        return emit(
          state.copyWith(
            status: PokemonCardStatus.success,
            cards: cards,
            hasReachedMax: false,
          ),
        );
      }

      // Si no es la primera vez (cargando más)
      final cards = await _pokemonCardRepository.getCards(page: _currentPage);
      _currentPage++;

      if (cards.isEmpty) {
        // Ya no hay más cartas
        emit(state.copyWith(hasReachedMax: true));
      } else {
        // Añadimos las nuevas cartas a la lista existente
        emit(
          state.copyWith(
            status: PokemonCardStatus.success,
            cards: List.of(state.cards)..addAll(cards),
            hasReachedMax: false,
          ),
        );
      }
    } on Exception catch (_) {
      emit(state.copyWith(status: PokemonCardStatus.failure));
    }
  }
}
