import 'package:flutter/material.dart' hide Card;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tourdecks/data/repositories/tourdeck_repository.dart';
import 'package:tourdecks/ui/maindecks_page/maindecks_page.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:tourdecks/hive/hive_registrar.g.dart';
import 'package:tourdecks/models/card.dart';
import 'package:tourdecks/models/tourdeck.dart';
import 'package:flutter/rendering.dart';
import 'package:tourdecks/ui/tourdeck_page/tourdeck_page.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  //Slow down animations for easier debugging
  timeDilation = 1;

  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Hive database and open the boxes
  await Hive.initFlutter();
  Hive.registerAdapters();
  final decks = await Hive.openBox<TourDeck>('decks');
  final cards = await Hive.openBox<Card>('cards');
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MainDecksPage(),
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
    );
  }
}
