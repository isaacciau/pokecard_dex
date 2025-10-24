part of 'card_detail_bloc.dart';

enum CardDetailStatus { initial, loading, success, failure }

final class CardDetailState extends Equatable {
  const CardDetailState({
    this.status = CardDetailStatus.initial,
    this.card,
  });

  final CardDetailStatus status;
  final PokemonCard? card; // La carta puede ser nula al inicio

  CardDetailState copyWith({
    CardDetailStatus? status,
    PokemonCard? card,
  }) {
    return CardDetailState(
      status: status ?? this.status,
      card: card ?? this.card,
    );
  }

  @override
  List<Object?> get props => [status, card];
}
