import 'package:tourdecks/models/tourdeck.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class TourDeckRepository {
  List<TourDeck> getDecks() {
    final box = Hive.box<TourDeck>('decks');
    return box.values.toList();
  }

  //TourDeck getDeck(int id) {}

  //void deleteDeck(int id) {}

  //void addDeck(TourDeck deck) {}
}
