import 'dart:io';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tourdecks/models/card.dart';
import 'package:tourdecks/ui/maindecks_page/maindecks_viewmodel.dart';
import 'package:tourdecks/ui/tourdeck_page/tourdeck_viewmodel.dart';

// Convert to Stateful to host AnimationController
class AnimatedCard extends ConsumerStatefulWidget {
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
  ConsumerState<AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends ConsumerState<AnimatedCard> with SingleTickerProviderStateMixin {
  late final AnimationController _floatController;
  late final Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _floatAnimation = Tween<double>(
      begin: -6.0,
      end: 6.0,
    ).animate(CurvedAnimation(parent: _floatController, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(covariant AnimatedCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    /*if (oldWidget.editMode != widget.editMode) {
      if (widget.editMode) {
        _floatController.repeat(reverse: true);
      } else {
        _floatController.stop();
        _floatController.reset();
      }
    }*/
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final focusedIndex = ref.watch(focusedCardIndexProvider);
    final totalCount = ref.watch(cardIdsProvider).length; // total cards

    return AnimatedBuilder(
      animation: Listenable.merge([widget.pageController, _floatController]),
      builder: (context, child) {
        final bool isFocused = focusedIndex == widget.index;
        final bool showEditButtons = widget.editMode && isFocused;
        final bool shouldFloat = widget.editMode && isFocused;

        // Boundary-aware button visibility
        final bool showLeftButton = showEditButtons && widget.index > 0;
        final bool showRightButton = showEditButtons && widget.index < totalCount - 1;

        // Start/stop controller only for focused card in edit mode
        if (shouldFloat) {
          if (!_floatController.isAnimating) {
            _floatController.repeat(reverse: true);
          }
        } else {
          if (_floatController.isAnimating) {
            _floatController.stop();
            _floatController.reset();
          }
        }

        double value =
            widget.pageController.position.haveDimensions
                ? widget.pageController.page! - widget.index
                : widget.index.toDouble();
        double shadowValue = Curves.easeOut.transform((1 - value.abs()).clamp(0.0, 1.0));
        value = Curves.easeOut.transform((1 - (value.abs() * .4)).clamp(0.0, 1.0));

        final double floatOffsetY = shouldFloat ? _floatAnimation.value : 0.0;

        return Center(
          child: Transform.translate(
            offset: Offset(0, floatOffsetY),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Hero(
                  tag: 'cardImageTag${widget.item.key}',
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
                                File(widget.documentsPath + widget.item.filename),
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
                                    widget.item.name,
                                    style: const TextStyle(
                                      fontFamily: 'Petrona',
                                      fontSize: 17,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    overflow: TextOverflow.ellipsis,
                                    widget.item.location,
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
                // Previous button
                Positioned(
                  left: -14,
                  top: 0,
                  bottom: 60,
                  child: Center(
                    child: AnimatedScale(
                      scale: showLeftButton ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutBack,
                      child: IgnorePointer(
                        ignoring: !showLeftButton,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          iconSize: 32,
                          style: IconButton.styleFrom(
                            backgroundColor: const Color(0xFFFF6E6E),
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.fromLTRB(0, 0, 2, 0),
                          ),
                          icon: const Icon(Icons.keyboard_double_arrow_left, color: Colors.white),
                          onPressed: () {
                            ref
                                .read(tourDecksProvider.notifier)
                                .moveCardInsideTourdeck(
                                  ref.read(selectedTourDeckProvider)!.key,
                                  widget.index,
                                  widget.index - 1,
                                );
                            widget.pageController.animateToPage(
                              widget.index - 1,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                // Next button
                Positioned(
                  right: -14,
                  top: 0,
                  bottom: 60,
                  child: Center(
                    child: AnimatedScale(
                      scale: showRightButton ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutBack,
                      child: IgnorePointer(
                        ignoring: !showRightButton,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          iconSize: 32,
                          style: IconButton.styleFrom(
                            backgroundColor: const Color(0xFFFF6E6E),
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
                          ),
                          icon: const Icon(Icons.keyboard_double_arrow_right, color: Colors.white),
                          onPressed: () {
                            ref
                                .read(tourDecksProvider.notifier)
                                .moveCardInsideTourdeck(
                                  ref.read(selectedTourDeckProvider)!.key,
                                  widget.index,
                                  widget.index + 1,
                                );
                            widget.pageController.animateToPage(
                              widget.index + 1,
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
          ),
        );
      },
    );
  }
}
