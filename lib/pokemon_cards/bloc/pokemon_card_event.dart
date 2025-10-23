part of 'pokemon_card_bloc.dart'; // Dará error hasta crear el siguiente archivo

sealed class PokemonCardEvent extends Equatable {
  const PokemonCardEvent();

  @override
  List<Object> get props => [];
}

// El único evento que necesitamos por ahora
final class CardsFetched extends PokemonCardEvent {}
