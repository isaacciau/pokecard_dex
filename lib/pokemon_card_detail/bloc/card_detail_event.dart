part of 'card_detail_bloc.dart';

sealed class CardDetailEvent extends Equatable {
  const CardDetailEvent();
  @override
  List<Object> get props => [];
}

// Evento para cuando la página carga y necesita buscar la carta
final class CardDetailFetched extends CardDetailEvent {
  const CardDetailFetched({required this.id});
  final String id;
  @override
  List<Object> get props => [id];
}
