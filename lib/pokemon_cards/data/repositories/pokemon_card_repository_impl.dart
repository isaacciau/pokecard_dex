import 'package:dio/dio.dart';
import 'package:pokecard_dex/pokemon_cards/data/models/pokemon_card_model.dart';
import 'package:pokecard_dex/pokemon_cards/domain/entities/pokemon_card.dart';
import 'package:pokecard_dex/pokemon_cards/domain/repositories/pokemon_card_repository.dart';

class PokemonCardRepositoryImpl implements PokemonCardRepository {
  PokemonCardRepositoryImpl({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;
  // OJO: La URL en la guía tiene un error de markdown. Esta es la correcta:
  final String _baseUrl = 'https://api.pokemontcg.io/v2';

  @override
  Future<List<PokemonCard>> getCards({
    required int page,
    int pageSize = 20,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '$_baseUrl/cards',
        queryParameters: {
          'page': page,
          'pageSize': pageSize,
          'orderBy': 'name',
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final results = response.data!['data'] as List;
        final cards = results
            .map(
              (cardData) => PokemonCardModel.fromJson(
                cardData as Map<String, dynamic>,
              ).toEntity(),
            ) // Convertimos Modelo -> Entidad
            .toList();
        return cards;
      } else {
        throw Exception('Failed to load Pokémon cards');
      }
    } on DioException catch (e) {
      // Manejar errores específicos de Dio (ej. problemas de red)
      throw Exception('Failed to load Pokémon cards: ${e.message}');
    } catch (e) {
      // Captura cualquier otro error
      throw Exception('An unknown error occurred: $e');
    }
  }

  @override
  Future<PokemonCard> getCardById({required String id}) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '$_baseUrl/cards/$id',
      );

      if (response.statusCode == 200 && response.data != null) {
        // La API envuelve la carta en un objeto 'data'
        final cardData = response.data!['data'] as Map<String, dynamic>;
        final card = PokemonCardModel.fromJson(cardData).toEntity();
        return card;
      } else {
        throw Exception('Failed to load card details');
      }
    } on DioException catch (e) {
      throw Exception('Failed to load card details: ${e.message}');
    } catch (e) {
      throw Exception('An unknown error occurred: $e');
    }
  }
}
