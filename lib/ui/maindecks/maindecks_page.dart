import 'package:flutter/material.dart';

class MainDecksPage extends StatefulWidget {
  const MainDecksPage({super.key});

  @override
  State<MainDecksPage> createState() => _MainDecksPageState();
}

class _MainDecksPageState extends State<MainDecksPage> {
  final WebAppPageViewmodel viewModel = WebAppPageViewmodel();

  @override
  void initState() {
    super.initState();
    viewModel.initializeWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: WebViewWidget(controller: viewModel.controller)),
    );
  }
}
