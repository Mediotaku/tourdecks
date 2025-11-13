import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tourdecks/data/repositories/card_repository.dart';
import 'package:tourdecks/models/card.dart';
import 'package:tourdecks/ui/maindecks_page/maindecks_viewmodel.dart';

//Edit mode toggle provider
final isEditModeProvider = StateProvider<bool>((ref) => false);

//Card on focus index provider
final focusedCardIndexProvider = StateProvider<int>((ref) => 0);

/// Repository provider to manage the list of Cards in the current TourDeck
final cardsProvider = StateNotifierProvider<CardsNotifier, List<Card>>((ref) => CardsNotifier(ref));

class CardsNotifier extends StateNotifier<List<Card>> {
  CardsNotifier(this.ref) : super([]) {
    repo = ref.read(cardRepositoryProvider);
    fetchCards();
  }
  late CardRepository? repo;
  final StateNotifierProviderRef ref;

  ///fetch all Cards from to Hive storage that belong to the current TourDeck
  void fetchCards() {
    state = List.from(repo!.getAllItems());
  }

  ///add Card to Hive Storage
  void addCard(Card newItem) {
    repo!.addItem(newItem);
  }

  Card? getCardById(int id) {
    return repo!.getItemByKey(id);
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

/// Provider that observes the cardIds list from the selected TourDeck
final cardIdsProvider = Provider<List<int>>((ref) {
  final deck = ref.watch(selectedTourDeckProvider);
  // Return a new List to avoid silent in-place mutations
  return deck == null ? <int>[] : List<int>.from(deck.cardIds);
});
