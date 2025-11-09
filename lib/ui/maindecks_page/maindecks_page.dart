import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tourdecks/data/services/image_storage_service.dart';
import 'package:tourdecks/global/labels.dart';
import 'package:tourdecks/models/tourdeck.dart';
import 'package:tourdecks/ui/common/background_pattern.dart';
import 'package:tourdecks/ui/maindecks_page/maindecks_viewmodel.dart';
import 'package:tourdecks/ui/tourdeck_page/tourdeck_page.dart';
import 'package:tourdecks/ui/maindecks_page/widgets/small_card.dart';
import 'package:tourdecks/ui/maindecks_page/widgets/small_card_placeholder.dart';
import 'package:tourdecks/utils/test_data.dart';

class MainDecksPage extends ConsumerWidget {
  const MainDecksPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<TourDeck> items = ref.watch(tourDecksProvider);
    final imageService = ref.read(imageStorageServiceProvider);
    final String documentsPath = ref.watch(filesPathProvider).value ?? '';

    return Scaffold(
      backgroundColor: const Color.fromARGB(245, 245, 245, 245),
      body: CustomPaint(
        painter: DotBackground(),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(12.0),
            physics: const BouncingScrollPhysics(),
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Row(
                  spacing: 5,
                  children: [
                    Text(
                      Labels.MainPageTitle,
                      style: const TextStyle(
                        fontFamily: 'Petrona',
                        fontSize: 35,
                        color: Color.fromARGB(184, 0, 0, 0),
                      ),
                    ),
                  ],
                ),
              ),
              /*ElevatedButton(
                onPressed: () async {
                  await imageService.storeTestingImages();
                  generateTestTourDecks(ref);
                },
                child: const Text('Generate Test Data'),
              ),*/
              GridView.builder(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return item.isPlaceholder
                      ? const SmallCardPlaceholder()
                      : SmallCard(item: item, documentsPath: documentsPath);
                },
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 0.80,
                  crossAxisCount: 2,
                  mainAxisSpacing: 25,
                  crossAxisSpacing: 28,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.large(
        elevation: 6.5,
        onPressed: () {
          // FAB action
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        backgroundColor: const Color(0xFFFF6E6E),
        child: const Icon(Icons.near_me_outlined, size: 55, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.zero,
        color: Colors.white,
        shape: AutomaticNotchedShape(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: SvgPicture.asset("assets/images/decks_icon.svg", width: 35, height: 35),
                  padding: EdgeInsets.zero,
                  onPressed: () {},
                ),
                const Text('Decks', style: TextStyle(fontSize: 12)),
              ],
            ),
            const SizedBox(width: 50),
            Column(
              spacing: 0,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.cast_outlined,
                    size: 40,
                    color: Color.fromARGB(255, 249, 60, 60),
                  ),
                  padding: EdgeInsets.zero,
                  onPressed: () {},
                ),
                const Text('Cast', style: TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/* ValueListenableBuilder<Box<TourDeck>>(
              valueListenable: TourDeckRepository.getDecksBox().listenable(),
              builder: (context, box, _) {
                final todos = box.values.toList().cast<TourDeck>();
                return buildContent(todos, todoModel);
              },
            ),}*/
/*ElevatedButton(
                  onPressed: () {
                    final test = TourDeck(
                      name: "Imperial Garden",
                      location: "Tokyo,Japan",
                      cardIds: [],
                      isMine: true,
                    );
                    ref.read(tourDecksProvider.notifier).addTourDeck(test);
                  },
                  child: const Text('Add Tourdeck'),
                ),*/
