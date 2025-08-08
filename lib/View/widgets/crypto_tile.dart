import 'package:crypto_app/Model/crypto_data_model.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CryptoTile extends StatelessWidget {
  const CryptoTile({super.key, required this.crypto});
  final CryptoDataModel crypto;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: 5.w,
        backgroundColor: Colors.white12,
        child: Image.network(crypto.image!),
      ),
      title: Text(
        crypto.name!,
        style: const TextStyle(
          fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Text(
        crypto.currentPrice!.toStringAsFixed(2),
        style: TextStyle(
          color: crypto.priceChange24! > 0 ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}
