class CryptoGraphDataModel {
  DateTime? date;
  double? price;

  CryptoGraphDataModel({this.date, this.price});

  CryptoGraphDataModel.fromList(List<dynamic> list) {
    date = DateTime.fromMillisecondsSinceEpoch(list[0]);
    price = list[1].toDouble();
  }
}
