import 'package:crypto_app/Controller/provider/crypto_provider.dart';
import 'package:crypto_app/Model/crypto_data_model.dart';
import 'package:crypto_app/View/widgets/crypto_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CryptoProvider>(
      builder: (context, marketProvider, child) {
        List<CryptoDataModel> wishlist = marketProvider.cryptoData
            .where((element) => element.addedToWishlist == true)
            .toList();

        if (wishlist.isNotEmpty) {
          return RefreshIndicator(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              itemBuilder: (context, index) {
                CryptoDataModel currentCrypto = wishlist[index];
                return CryptoTile(crypto: currentCrypto);
              },
            ),

            onRefresh: () async {
              await marketProvider.fetchData();
            },
          );
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text('No currency is bookmarked')],
          );
        }
      },
    );
  }
}
