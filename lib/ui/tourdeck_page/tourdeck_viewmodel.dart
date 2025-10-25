import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tourdecks/data/repositories/card_repository.dart';
import 'package:tourdecks/models/card.dart';

final currentPageProvider = StateProvider<int>((ref) {
  return 0;
});

final cardsProvider = StateNotifierProvider<CardsNotifier, List<Card>>((ref) => CardsNotifier(ref));

class CardsNotifier extends StateNotifier<List<Card>> {
  CardsNotifier(this.ref) : super([]) {
    repo = ref.read(cardRepositoryProvider);
    fetchCards();
  }
  late CardRepository? repo;
  final StateNotifierProviderRef ref;

  ///fetch all Cards from to Hive storage
  void fetchCards() {
    state = List.from(repo!.getAllItems());
    //setPlaceholdersFill();
  }

  ///add Card to Hive Storage
  void addCard(Card newItem) {
    state = repo!.addItem(newItem);
    //setPlaceholdersFill();
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
