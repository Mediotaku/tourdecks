import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tourdecks/data/repositories/card_repository.dart';
import 'package:tourdecks/models/card.dart';
import 'package:tourdecks/ui/maindecks_page/maindecks_viewmodel.dart';

final currentPageProvider = StateProvider<int>((ref) {
  return 0;
});

final cardsProvider = StateNotifierProvider<CardsNotifier, List<Card>>((ref) => CardsNotifier(ref));

class CardsNotifier extends StateNotifier<List<Card>> {
  CardsNotifier(this.ref) : super([]) {
    repo = ref.read(cardRepositoryProvider);
    cardIds = ref.watch(selectedTourDeckProvider)?.cardIds ?? [];
    fetchCards();
  }
  late CardRepository? repo;
  final StateNotifierProviderRef ref;
  late List<int> cardIds = [];

  ///fetch all Cards from to Hive storage that belong to the current TourDeck
  void fetchCards() {
    state = repo!.getAllItems().where((card) => cardIds.contains(card.key)).toList();
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
