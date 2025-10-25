import 'package:flutter/material.dart';

class Carroussel extends StatefulWidget {
  @override
  _CarrousselState createState() => new _CarrousselState();
}

class _CarrousselState extends State<Carroussel> {
  late PageController controller;
  int currentpage = 0;

  @override
  initState() {
    super.initState();
    controller = PageController(initialPage: currentpage, keepPage: false, viewportFraction: 0.6);
  }

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Text("Carousel Example"),
            PageView.builder(
              onPageChanged: (value) {
                setState(() {
                  currentpage = value;
                });
              },
              controller: controller,
              itemBuilder: (context, index) => builder(index),
            ),
          ],
        ),
      ),
    );
  }

  builder(int index) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        double value = 1.0;
        if (controller.position.haveDimensions) {
          value = controller.page! - index.toDouble();
          value = (1 - (value.abs() * .5)).clamp(0.0, 1.0);
        }

        return Center(
          child: Container(
            height: Curves.easeOut.transform(value) * 300,
            width: Curves.easeOut.transform(value) * 250,
            margin: const EdgeInsets.all(10.0),
            color: index % 2 == 0 ? Colors.blue : Colors.red,
          ),
        );
      },
    );
  }
}
