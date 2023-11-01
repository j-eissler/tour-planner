import 'package:flutter/material.dart';

class WaypointsListScreen extends StatelessWidget {
  const WaypointsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Waypoints")),
      body: const Center(
          child: Text("This screen shows all the waypoints in the database")),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.pushNamed(context, '/waypoint_form'),
      ),
    );
  }
}
