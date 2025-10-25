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
  });

  final PageController pageController;
  final int index;
  final Card item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedBuilder(
      animation: pageController,
      builder: (context, child) {
        double value =
            pageController.position.haveDimensions
                ? pageController.page! - index
                : index.toDouble();
        value = Curves.easeOut.transform((1 - (value.abs() * .4)).clamp(0.0, 1.0));
        return Center(
          child: Container(
            height: value * 350,
            width: value * 300,
            margin: const EdgeInsets.fromLTRB(15, 0, 15, 40),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red, width: 2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    color: Colors.grey[300],
                    child: Image.file(
                      File(item.imageURL),
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) =>
                              Icon(Icons.broken_image, size: 60, color: Colors.grey[600]),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Text(
                      'Imperial',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Petrona',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: const Offset(1, 1),
                            blurRadius: 3,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
