import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'WallpaperApp/quote_grd_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: new WallScreen(analytics: analytics, observer: observer),
      home: new QuoteScreen(),
    );
  }
}