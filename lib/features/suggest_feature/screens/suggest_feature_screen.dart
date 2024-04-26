import 'package:acc/core/commons/large_text.dart';
import 'package:acc/core/commons/nav_bar_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class SuggestFeature extends ConsumerStatefulWidget {
  const SuggestFeature({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SuggestFeatureState();
}

class _SuggestFeatureState extends ConsumerState<SuggestFeature> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        leading: JustIconButton(
          icon: CupertinoIcons.back,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.black,
        middle: largeText('öner / bildir', false),
      ),
      body: ListView(
        children: [],
      ),
    );
  }
}
