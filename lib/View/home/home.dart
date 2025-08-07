import 'package:crypto_app/View/crypto_listing_screen.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(text: "Market"),
              Tab(text: "Wishlist"),
            ],
          ),
          title: const Text(
            'Hello!',
            style: TextStyle(
              fontSize: 30,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: const TabBarView(children: [CryptoListingScreen()]),
      ),
    );
  }
}
