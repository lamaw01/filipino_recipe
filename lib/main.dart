import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'locator.dart';
import 'provider/category_provider.dart';
import 'provider/featured_provider.dart';
import 'provider/random_provider.dart';
import 'view/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) async {
    await Firebase.initializeApp();
    await setup();
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<FeaturedProvider>(
            create: (_) => FeaturedProvider(),
          ),
          ChangeNotifierProvider<CategoryProvider>(
            create: (_) => CategoryProvider(),
          ),
          ChangeNotifierProvider<RandomProvider>(
            create: (_) => RandomProvider(),
          ),
        ],
        child: const MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Filipino Recipe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(),
    );
  }
}
