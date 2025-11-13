import 'dart:io';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tourdecks/models/card.dart';
import 'package:tourdecks/ui/maindecks_page/maindecks_viewmodel.dart';
import 'package:tourdecks/ui/tourdeck_page/tourdeck_viewmodel.dart';

class AnimatedCard extends ConsumerWidget {
  const AnimatedCard({
    super.key,
    required this.pageController,
    required this.index,
    required this.item,
    required this.documentsPath,
    required this.editMode,
  });

  final PageController pageController;
  final int index;
  final Card item;
  final String documentsPath;
  final bool editMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focusedIndex = ref.watch(focusedCardIndexProvider);

    return AnimatedBuilder(
      animation: pageController,
      builder: (context, child) {
        final bool showEditButtons = editMode && focusedIndex == index;

        double value =
            pageController.position.haveDimensions
                ? pageController.page! - index
                : index.toDouble();
        double shadowValue = Curves.easeOut.transform((1 - value.abs()).clamp(0.0, 1.0));
        value = Curves.easeOut.transform((1 - (value.abs() * .4)).clamp(0.0, 1.0));

        return Center(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Hero(
                tag: 'cardImageTag${item.key}',
                child: Material(
                  type: MaterialType.transparency,
                  child: Container(
                    height: value * 350,
                    width: value * 300,
                    margin: const EdgeInsets.fromLTRB(15, 0, 15, 60),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red, width: 2),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(153, 0, 0, 0),
                          offset: Offset(shadowValue * 2, shadowValue * 33),
                          blurRadius: shadowValue * 72.2,
                          spreadRadius: shadowValue * -8,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Container(
                            color: Colors.grey[300],
                            child: Image.file(
                              File(documentsPath + item.filename),
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) =>
                                      Icon(Icons.broken_image, size: 60, color: Colors.grey[600]),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [Colors.black.withOpacity(0.9), Colors.transparent],
                                stops: const [0.0, 0.25],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 16,
                            left: 16,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  overflow: TextOverflow.ellipsis,
                                  item.name,
                                  style: const TextStyle(
                                    fontFamily: 'Petrona',
                                    fontSize: 17,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  overflow: TextOverflow.ellipsis,
                                  item.location,
                                  style: const TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Previous button (left edge)
              Positioned(
                left: -14, // align with card's left margin
                top: 0,
                bottom: 60, // match card bottom margin space
                child: Center(
                  child: AnimatedScale(
                    scale: !showEditButtons ? 0.0 : 1.0,
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutBack,
                    child: IgnorePointer(
                      ignoring: !showEditButtons,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        iconSize: 32,
                        style: IconButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6E6E),
                          shape: const CircleBorder(),
                          padding: EdgeInsets.fromLTRB(0, 0, 2, 0),
                        ),
                        icon: const Icon(Icons.keyboard_double_arrow_left, color: Colors.white),
                        onPressed: () {
                          ref
                              .read(tourDecksProvider.notifier)
                              .moveCardInsideTourdeck(
                                ref.read(selectedTourDeckProvider)!.key,
                                index,
                                index - 1,
                              );

                          pageController.animateToPage(
                            index - 1,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              // Next button (right edge)
              Positioned(
                right: -14, // align with card's right margin
                top: 0,
                bottom: 60,
                child: Center(
                  child: AnimatedScale(
                    scale: !showEditButtons ? 0.0 : 1.0,
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutBack,
                    child: IgnorePointer(
                      ignoring: !showEditButtons,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        iconSize: 32,
                        style: IconButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6E6E),
                          shape: const CircleBorder(),
                          padding: EdgeInsets.fromLTRB(2, 0, 0, 0),
                        ),
                        icon: const Icon(Icons.keyboard_double_arrow_right, color: Colors.white),
                        onPressed: () {
                          ref
                              .read(tourDecksProvider.notifier)
                              .moveCardInsideTourdeck(
                                ref.read(selectedTourDeckProvider)!.key,
                                index,
                                index + 1,
                              );

                          pageController.animateToPage(
                            index + 1,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
