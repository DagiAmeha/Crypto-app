import 'package:crypto_app/Controller/provider/crypto_provider.dart';

import 'package:crypto_app/View/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, _, __) {
        return MultiProvider(
          providers: [ChangeNotifierProvider(create: (_) => CryptoProvider())],
          child: MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData.dark(),
            home: const Home(),
          ),
        );
      },
    );
  }
}
