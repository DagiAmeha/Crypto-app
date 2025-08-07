import 'package:crypto_app/Controller/provider/crypto_provider.dart';
import 'package:crypto_app/Model/crypto_data_model.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';

class CryptoListingScreen extends StatefulWidget {
  const CryptoListingScreen({super.key});

  @override
  State<CryptoListingScreen> createState() => _CryptoListingScreenState();
}

class _CryptoListingScreenState extends State<CryptoListingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5.h),
              Expanded(
                child: Consumer<CryptoProvider>(
                  builder: (context, cryptProvider, child) {
                    if (cryptProvider.isLoading == true) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: cryptProvider.cryptoData.length,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          CryptoDataModel currentCryptoData =
                              cryptProvider.cryptoData[index];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              radius: 5.w,
                              backgroundColor: Colors.white12,
                              child: Image.network(currentCryptoData.image!),
                            ),
                            title: Text(
                              currentCryptoData.name!,
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            trailing: Text(
                              currentCryptoData.currentPrice!.toStringAsFixed(
                                2,
                              ),
                              style: TextStyle(
                                color: currentCryptoData.priceChange24! > 0
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
