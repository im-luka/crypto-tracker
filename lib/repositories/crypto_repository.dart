import 'dart:convert';

import 'package:cryptocurrency_api/models/coin_model.dart';
import 'package:cryptocurrency_api/models/failure.dart';
import 'package:http/http.dart' as http;

class CryptoRepository {
  static const String _baseUrl = 'https://min-api.cryptocompare.com';
  static const int perPage = 20;

  final http.Client _httpClient;

  CryptoRepository({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  Future<List<Coin>> getTopCoins({required int page}) async {
    final requestUrl =
        '${_baseUrl}/data/top/totalvolfull?limit=$perPage&tsym=USD&page=$page';

    try {
      final response = await _httpClient.get(Uri.parse(requestUrl));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        final coinList = List.from(data['Data']);
        return coinList.map((item) => Coin.fromMap(item)).toList();
      }
      return [];
    } catch (error) {
      print(error);
      throw Failure(message: error.toString());
    }
  }

  Future<Coin> getSelectedCoins(String coinName) async {
    final requestUrl = '${_baseUrl}/data/all/coinlist?fsym=$coinName';

    try {
      final response = await _httpClient.get(Uri.parse(requestUrl));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        Coin coin = Coin.selectedCoin(data['Data'], coinName);

        final requestPrice =
            '${requestUrl}/data/price?fsym=$coinName&tsyms=USD';
        try {
          final priceResponse = await _httpClient.get(Uri.parse(requestPrice));
          if (priceResponse.statusCode == 200) {
            Map<String, dynamic> priceData = jsonDecode(priceResponse.body);
            double price = double.parse(priceData['USD']);
            coin.price = price;
            print(coin);
          }
        } catch (error) {
          throw Failure(message: error.toString());
        }

        return coin;
      }
      return Coin(
          name: 'Error', fullName: 'Error when getting the coin', price: 0);
    } catch (error) {
      throw Failure(message: error.toString());
    }
  }
}
