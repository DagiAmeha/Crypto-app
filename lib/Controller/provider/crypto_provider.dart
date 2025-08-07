import 'package:crypto_app/Controller/service/get_market_data.dart';
import 'package:crypto_app/Model/crypto_data_model.dart';
import 'package:flutter/material.dart';

class CryptoProvider extends ChangeNotifier {
  bool isLoading = true;
  List<CryptoDataModel> cryptoData = [];
  CryptoDataModel currentCrypto = CryptoDataModel();
  bool fetchingCurrentCrypto = true;

  CryptoProvider() {
    fetchData();
  }

  Future<void> fetchData() async {
    List<dynamic> cryptoDataResponse = await API.getCryptoMarketData();

    List<CryptoDataModel> temp = [];
    for (var market in cryptoDataResponse) {
      CryptoDataModel newCrypto = CryptoDataModel.fromJSON(market);

      temp.add(newCrypto);
    }

    cryptoData = temp;
    isLoading = false;
    notifyListeners();
  }

  updateFetchingCurrentCryptoStatus(bool data) {
    fetchingCurrentCrypto = data;
    notifyListeners();
  }

  fetchCryptoById(String id) {
    updateFetchingCurrentCryptoStatus(true);
    CryptoDataModel crypto = cryptoData
        .where((element) => element.id == id)
        .toList()[0];
    currentCrypto = crypto;
    notifyListeners();
    updateFetchingCurrentCryptoStatus(false);
  }
}
