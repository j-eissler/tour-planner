import 'package:flutter/material.dart';

class WaypointFormScreen extends StatelessWidget {
  const WaypointFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Enter waypoint information")),
      body: const Center(child: Text("Enter data here")),
    );
  }
}
