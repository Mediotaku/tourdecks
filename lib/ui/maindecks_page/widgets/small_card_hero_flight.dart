import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tourdecks/models/tourdeck.dart';
import 'package:tourdecks/ui/maindecks_page/maindecks_viewmodel.dart';

class SmallCardHeroFlight extends ConsumerWidget {
  const SmallCardHeroFlight({
    super.key,
    required this.item,
    required this.documentsPath,
    required this.animation,
  });

  final TourDeck item;
  final String documentsPath;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DecorationTween decorationTween = DecorationTween(
      begin: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      end: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(153, 0, 0, 0),
            offset: Offset(2, 33),
            blurRadius: 72.2,
            spreadRadius: -18,
          ),
        ],
      ),
    );

    final EdgeInsetsTween _marginTween = EdgeInsetsTween(
      begin: const EdgeInsets.all(0.0),
      end: const EdgeInsets.fromLTRB(15, 0, 15, 60),
    );

    return Material(
      type: MaterialType.transparency,
      child: Container(
        margin: const EdgeInsets.fromLTRB(15, 0, 15, 60),
        child: DecoratedBoxTransition(
          decoration: decorationTween.animate(animation),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey[300],
              border: Border.all(color: const Color(0xFFF93C3C), width: 1.8),
            ),

            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(ReverseAnimation(animation).value * 20),
                      bottomRight: Radius.circular(ReverseAnimation(animation).value * 20),
                    ),
                    child: Image.file(
                      File(
                        documentsPath +
                            ref.read(tourDecksProvider.notifier).getFirstCardImagePath(item),
                      ),
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) =>
                              Icon(Icons.broken_image, size: 50, color: Colors.grey[600]),
                    ),
                  ),
                ),
                // White info box background + overlaid text via Stack
                FadeTransition(
                  opacity: ReverseAnimation(animation),
                  child: SizeTransition(
                    sizeFactor: ReverseAnimation(animation),
                    axis: Axis.vertical,
                    child: SizedBox(
                      height: 70,
                      width: double.infinity,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Background white container
                          Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                              color: Colors.white,
                            ),
                          ),
                          // Text overlay (same padding & alignment as before)
                          Positioned.fill(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(12, 0, 4, 2),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FadeTransition(
                                    opacity: ReverseAnimation(animation),
                                    child: Text(
                                      overflow: TextOverflow.ellipsis,
                                      item.name,
                                      style: const TextStyle(
                                        fontFamily: 'Petrona',
                                        fontSize: 17,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  FadeTransition(
                                    opacity: ReverseAnimation(animation),
                                    child: Text(
                                      overflow: TextOverflow.ellipsis,
                                      item.location,
                                      style: const TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
