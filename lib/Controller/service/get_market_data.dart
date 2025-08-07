import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;

import 'package:crypto_app/Controller/service/API/apis.dart';
import 'package:http/http.dart' as http;

class API {
  static Future getCryptoMarketData() async {
    final api = Uri.parse(cryptoMarketDataAPI);

    try {
      var response = await http
          .get(api, headers: {'Content-Type': 'application/json'})
          .timeout(
            const Duration(seconds: 60),
            onTimeout: () {
              throw TimeoutException('Connection Timed out');
            },
          );
      dev.log(response.statusCode.toString());
      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        // dev.log(decodedResponse.toString());
        List<dynamic> products = decodedResponse as List<dynamic>;
        // dev.log();
        return products;
      }
    } catch (e) {
      dev.log(e.toString());
    }
  }

  static Future<List<dynamic>> fetchGraphData(String id, int days) async {
    try {
      Uri requestPath = Uri.parse(
        'https://api.coingecko.com/api/v3/coins/$id/market_chart?vs_currency=$id&days=$days',
      );
      var response = await http.get(requestPath);
      var decodedResponse = jsonDecode(response.body);
      dev.log(response.statusCode.toString());

      List<dynamic> prices = decodedResponse["prices"];
      // dev.log();
      return prices;
    } catch (e) {
      return [];
    }
  }
}
