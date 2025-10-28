import 'dart:io';

import 'package:flutter/material.dart' hide Card;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tourdecks/models/card.dart';
import 'package:tourdecks/ui/common/background_pattern.dart';
import 'package:tourdecks/ui/maindecks_page/maindecks_viewmodel.dart';
import 'package:tourdecks/ui/tourdeck_page/tourdeck_viewmodel.dart';
import 'package:tourdecks/ui/tourdeck_page/widgets/animated_card.dart';

class TourDeckPage extends ConsumerWidget {
  final int deckKey;
  const TourDeckPage({super.key, required this.deckKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Card> items = ref.watch(cardsProvider);
    final pageController = PageController(viewportFraction: 0.73);
    String documentsPath = ref.watch(filesPathProvider).value ?? '';
    final tourdeck = ref.read(tourDecksProvider.notifier).getTourDeckByKey(deckKey);

    return CustomPaint(
      painter: DotBackground(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              // Header with back button and title
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(30, 30),
                        elevation: 0,
                        backgroundColor: const Color.fromARGB(255, 255, 110, 110),
                      ),
                      child: const Icon(Icons.arrow_back, size: 18, color: Colors.white),
                    ),
                    const SizedBox(width: 1),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 0,
                      children: [
                        Container(
                          width: 310,
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            tourdeck != null ? tourdeck.name : 'Something went wrong',
                            maxLines: 2,
                            style: const TextStyle(
                              fontFamily: 'Petrona',
                              height: 1.2,
                              fontSize: 35,
                              color: Color.fromARGB(184, 0, 0, 0),
                            ),
                          ),
                        ),
                        Text(
                          tourdeck != null ? tourdeck.location : '',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0,
                            fontFamily: 'Roboto',
                            color: Color.fromARGB(184, 0, 0, 0),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Card carousel
              Expanded(
                child: PageView.builder(
                  controller: pageController,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return AnimatedCard(
                      pageController: pageController,
                      index: index,
                      item: item,
                      documentsPath: documentsPath,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          padding: EdgeInsets.zero,
          color: Colors.white,
          shape: AutomaticNotchedShape(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
      ),
    );
  }
}
