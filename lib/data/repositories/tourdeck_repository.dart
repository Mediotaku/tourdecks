import 'package:tourdecks/models/tourdeck.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tourDeckRepositoryProvider = Provider<TourDeckRepository>((ref) => TourDeckRepository());

class TourDeckRepository {
  late Box<TourDeck> _hive;
  late List<TourDeck> _box;

  TourDeckRepository();

  List<TourDeck> getAllItems() {
    /// Fetch the Tourdecks from the "decks" database
    _hive = Hive.box<TourDeck>('decks');
    _box = _hive.values.toList();
    return _box;
  }

  /// Add Tourdeck to Database
  List<TourDeck> addItem(TourDeck deck) {
    _hive.add(deck);
    return _hive.values.toList();
  }

  TourDeck? getItemByKey(int key) {
    return _hive.getAt(key);
  }

  /// Remove Particular X by id
  /*List<TourDeck> removeTourDeck(String id) {
    _hive.deleteAt(
        _hive.values.toList().indexWhere((element) => element. == id));
    return _hive.values.toList();
  }*/

  /// Update TourDeck by Index
  List<TourDeck> updateItemByIndex(int index, TourDeck todo) {
    _hive.putAt(index, todo);
    return _hive.values.toList();
  }

  /// Update TourDeck by Key
  List<TourDeck> updateItemByKey(int key, TourDeck todo) {
    _hive.put(key, todo);
    return _hive.values.toList();
  }
}
