import 'package:crypto_app/Controller/service/get_market_data.dart';
import 'package:crypto_app/Model/crypto_graph_data_model.dart';
import 'package:flutter/material.dart';

class GraphProvider extends ChangeNotifier {
  List<CryptoGraphDataModel> graphPoints = [];

  Future<void> fetchCryptoGraph(String id, int days) async {
    graphPoints = [];
    notifyListeners();
    List<dynamic> priceData = await API.fetchGraphData(id, days);

    List<CryptoGraphDataModel> temp = [];
    for (var pricePoint in priceData) {
      CryptoGraphDataModel graphPoint = CryptoGraphDataModel.fromList(
        pricePoint,
      );
      temp.add(graphPoint);
    }

    graphPoints = temp;
    notifyListeners();
  }
}
