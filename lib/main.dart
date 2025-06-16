import 'package:flutter/material.dart' hide Card;
import 'package:tourdecks/data/repositories/tourdeck_repository.dart';
import 'package:tourdecks/ui/maindecks/maindecks_page.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:tourdecks/hive/hive_registrar.g.dart';
import 'package:tourdecks/models/card.dart';
import 'package:tourdecks/models/tourdeck.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive database and open the boxes
  await Hive.initFlutter();
  Hive.registerAdapters();
  final decks = await Hive.openBox<TourDeck>('decks');
  final cards = await Hive.openBox<Card>('cards');

  //Test initialization
  if (TourDeckRepository().getDecks().isEmpty) {
    decks.add(
      TourDeck(
        name: "Imperial Palace",
        location: "Tokyo,Japan",
        cardIds: [],
        isMine: true,
      ),
    );
    decks.add(
      TourDeck(
        name: "Tokyo Islands",
        location: "Tokyo,Japan",
        cardIds: [],
        isMine: true,
      ),
    );
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MainDecksPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
