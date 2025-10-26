import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tourdecks/models/tourdeck.dart';
import 'package:tourdecks/ui/maindecks_page/maindecks_viewmodel.dart';
import 'package:tourdecks/ui/tourdeck_page/tourdeck_page.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class SmallCard extends ConsumerWidget {
  const SmallCard({super.key, required this.item, required this.documentsPath});

  final TourDeck item;

  final String documentsPath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ZoomTapAnimation(
      beginDuration: const Duration(milliseconds: 120),
      endDuration: const Duration(milliseconds: 120),
      onTap: () {
        ref.read(selectedTourDeckProvider.notifier).select(item);
        Navigator.of(
          context,
        ).push(MaterialPageRoute<void>(builder: (context) => TourDeckPage(deckKey: item.key)));
      },
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
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
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
            Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.fromLTRB(12, 0, 4, 2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      overflow: TextOverflow.ellipsis,
                      item.name,
                      style: TextStyle(
                        fontFamily: 'Petrona',
                        fontSize: 17,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      overflow: TextOverflow.ellipsis,
                      item.location,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 12,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
