// Ignore for testing purposes
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokecard_dex/app/view/app_view.dart';
import 'package:pokecard_dex/pokemon_cards/bloc/pokemon_card_bloc.dart';
import 'package:pokecard_dex/pokemon_cards/domain/entities/pokemon_card.dart';
import 'package:pokecard_dex/pokemon_cards/domain/repositories/pokemon_card_repository.dart';
import 'package:pokecard_dex/pokemon_cards/view/cards_page.dart';

class MockPokemonCardRepository extends Mock implements PokemonCardRepository {}

void main() {
  group('App', () {
    late PokemonCardRepository pokemonCardRepository;
    late PokemonCardBloc pokemonCardBloc;

    setUp(() {
      pokemonCardRepository = MockPokemonCardRepository();
      when(
        () => pokemonCardRepository.getCards(page: any(named: 'page')),
      ).thenAnswer((_) async => <PokemonCard>[]);
      pokemonCardBloc = PokemonCardBloc(
        pokemonCardRepository: pokemonCardRepository,
      )..add(CardsFetched());
    });

    testWidgets('renders CardsPage', (tester) async {
      await tester.pumpWidget(
        BlocProvider.value(
          value: pokemonCardBloc,
          child: const AppView(),
        ),
      );
      expect(find.byType(CardsPage), findsOneWidget);
    });
  });
}
