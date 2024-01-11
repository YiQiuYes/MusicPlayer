import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final logic = Get.put(ExploreLogic());
  final state = Get.find<ExploreLogic>().state;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('ExplorePage'),
      ),
    );
  }
}

