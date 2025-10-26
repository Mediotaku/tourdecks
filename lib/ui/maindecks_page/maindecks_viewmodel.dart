import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tourdecks/data/repositories/tourdeck_repository.dart';
import 'package:tourdecks/models/tourdeck.dart';
import 'package:tourdecks/ui/tourdeck_page/tourdeck_viewmodel.dart';

final filesPathProvider = FutureProvider.autoDispose<String>((ref) async {
  return (await getApplicationDocumentsDirectory()).path;
});

final tourDecksProvider = StateNotifierProvider<TourdecksNotifier, List<TourDeck>>(
  (ref) => TourdecksNotifier(ref),
);

class TourdecksNotifier extends StateNotifier<List<TourDeck>> {
  TourdecksNotifier(this.ref) : super([]) {
    repo = ref.read(tourDeckRepositoryProvider);
    fetchTourdecks();
  }
  late TourDeckRepository? repo;
  final StateNotifierProviderRef ref;

  ///fetch all Tourdecks from to Hive storage
  void fetchTourdecks() {
    state = List.from(repo!.getAllItems());
    setPlaceholdersFill();
  }

  ///add Tourdeck to Hive Storage
  void addTourDeck(TourDeck newItem) {
    state = repo!.addItem(newItem);
    setPlaceholdersFill();
  }

  void setPlaceholdersFill() {
    // Remove all null values from the state
    state = state.where((item) => !item.isPlaceholder).toList();

    // If list has less than 6 items, fill with null values until length is 6
    if (state.length < 6) {
      int requiredPlaceholders = 6 - state.length;
      for (var j = 0; j < requiredPlaceholders; j++) {
        state.add(TourDeck.createPlaceholder());
      }
    }
  }

  String getFirstCardImagePath(TourDeck item) {
    if (item.cardIds.isEmpty) {
      return '';
    }
    final cardKey = item.cardIds.first;
    final card = ref.read(cardsProvider.notifier).getCardById(cardKey);
    return card?.filename ?? '';
  }

  TourDeck? getTourDeckByKey(int key) {
    return repo!.getItemByKey(key);
  }

  ///remove todo from local Storage
  /*void removeTodo(String id) {
    state = repo!.removeTodo(id);
  }

  ///Update  current todo from local Storage

  void updateTodo(int index, Todo todo) {
    state = repo!.updateTodo(index, todo);
  }*/
}

/// Holds the currently selected TourDeck (nullable).
final selectedTourDeckProvider = StateNotifierProvider<SelectedTourDeckNotifier, TourDeck?>(
  (ref) => SelectedTourDeckNotifier(),
);

class SelectedTourDeckNotifier extends StateNotifier<TourDeck?> {
  SelectedTourDeckNotifier() : super(null);

  void select(TourDeck deck) => state = deck;
  void clear() => state = null;
  TourDeck? get selected => state;
}
