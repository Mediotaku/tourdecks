import 'dart:io';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tourdecks/models/card.dart';

class AnimatedCard extends ConsumerWidget {
  const AnimatedCard({
    super.key,
    required this.pageController,
    required this.index,
    required this.item,
    required this.documentsPath,
  });

  final PageController pageController;
  final int index;
  final Card item;
  final String documentsPath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedBuilder(
      animation: pageController,
      builder: (context, child) {
        double value =
            pageController.position.haveDimensions
                ? pageController.page! - index
                : index.toDouble();
        double shadowValue = Curves.easeOut.transform((1 - value.abs()).clamp(0.0, 1.0));
        value = Curves.easeOut.transform((1 - (value.abs() * .4)).clamp(0.0, 1.0));
        return Center(
          child: Hero(
            tag: 'cardImageTag${item.key}',
            //Material widget required to fix a know issue with text losing style during Hero animation, see: https://github.com/flutter/flutter/issues/12463
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
                      spreadRadius: shadowValue * -18,
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
                      // Gradient overlay (bottom -> transparent within 25% height)
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [Colors.black.withValues(alpha: 0.9), Colors.transparent],
                            stops: const [0.0, 0.25],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        left: 16,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              overflow: TextOverflow.ellipsis,
                              item.name,
                              style: const TextStyle(
                                fontFamily: 'Petrona',
                                fontSize: 17,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              overflow: TextOverflow.ellipsis,
                              item.location,
                              style: const TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 12,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                              textAlign: TextAlign.left,
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
        );
      },
    );
  }
}
