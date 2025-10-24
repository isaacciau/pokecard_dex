import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pokecard_dex/pokemon_cards/domain/entities/pokemon_card.dart';
import 'package:pokecard_dex/pokemon_cards/domain/repositories/pokemon_card_repository.dart';

part 'card_detail_event.dart';
part 'card_detail_state.dart';

class CardDetailBloc extends Bloc<CardDetailEvent, CardDetailState> {
  CardDetailBloc({required PokemonCardRepository pokemonCardRepository})
    : _pokemonCardRepository = pokemonCardRepository,
      super(const CardDetailState()) {
    on<CardDetailFetched>(_onCardDetailFetched);
  }

  final PokemonCardRepository _pokemonCardRepository;

  Future<void> _onCardDetailFetched(
    CardDetailFetched event,
    Emitter<CardDetailState> emit,
  ) async {
    emit(state.copyWith(status: CardDetailStatus.loading));
    try {
      final card = await _pokemonCardRepository.getCardById(id: event.id);
      emit(
        state.copyWith(
          status: CardDetailStatus.success,
          card: card,
        ),
      );
    } on Exception catch (_) {
      emit(state.copyWith(status: CardDetailStatus.failure));
    }
  }
}
