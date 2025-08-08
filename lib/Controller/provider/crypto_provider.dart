import 'dart:developer';

import 'package:crypto_app/Controller/service/LocalStorage/local_storage.dart';
import 'package:crypto_app/Controller/service/get_market_data.dart';
import 'package:crypto_app/Model/crypto_data_model.dart';
import 'package:flutter/material.dart';

class CryptoProvider extends ChangeNotifier {
  bool isLoading = true;
  List<CryptoDataModel> cryptoData = [];
  CryptoDataModel? currentCrypto;
  bool fetchingCurrentCrypto = true;
  List<String> wishlist = [];

  CryptoProvider() {
    fetchData();
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

  updateWishlist(String id, CryptoDataModel crypto) async {
    if (wishlist.contains(id)) {
      wishlist.remove(id);
      int indexOfCrypto = cryptoData.indexOf(crypto);
      cryptoData[indexOfCrypto].addedToWishlist = false;
      await LocalStorage.removeFromWishlist(id);
      notifyListeners();
    } else {
      wishlist.add(id);
      int indexOfCrypto = cryptoData.indexOf(crypto);
      cryptoData[indexOfCrypto].addedToWishlist = true;
      await LocalStorage.addToWishlist(id);
      notifyListeners();
    }
  }

  Future<void> fetchData() async {
    List<dynamic> markets = await API.getCryptoMarketData();
    wishlist = await LocalStorage.fetchWishlist();
    notifyListeners();
    log(wishlist.toString());
    List<CryptoDataModel> temp = [];
    for (var market in markets) {
      CryptoDataModel newCrypto = CryptoDataModel.fromJSON(market);
      if (wishlist.contains(newCrypto.id)) {
        newCrypto.addedToWishlist = true;
      }
      temp.add(newCrypto);
    }

    cryptoData = temp;
    isLoading = false;
    notifyListeners();
  }
}
