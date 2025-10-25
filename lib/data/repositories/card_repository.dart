import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tourdecks/models/card.dart';

final cardRepositoryProvider = Provider<CardRepository>(
  (ref) => CardRepository(),
);

class CardRepository {
  late Box<Card> _hive;
  late List<Card> _box;

  CardRepository();

  List<Card> getAllItems() {
    /// Fetch the Cards from the "cards" database
    _hive = Hive.box<Card>('cards');
    _box = _hive.values.toList();
    return _box;
  }

  /// Add Card to Database
  List<Card> addItem(Card deck) {
    _hive.add(deck);
    return _hive.values.toList();
  }

  Card? getItemByKey(int key) {
    return _hive.getAt(key);
  }

  /// Remove Particular X by id
  /*List<Card> removeCard(String id) {
    _hive.deleteAt(
        _hive.values.toList().indexWhere((element) => element. == id));
    return _hive.values.toList();
  }*/
  /// Update Card
  /*List<Card> updateTodo(int index, Card todo) {
    _hive.putAt(index, todo);
    return _hive.values.toList();
  }*/
}
