import 'package:flutter/material.dart';
import 'package:tour_planner/database.dart';
import 'package:tour_planner/waypoint_model.dart';

class WaypointsListScreen extends StatefulWidget {
  const WaypointsListScreen({super.key});

  @override
  State<WaypointsListScreen> createState() => _WaypointsListScreenState();
}

class _WaypointsListScreenState extends State<WaypointsListScreen> {
  List<Waypoint> waypoints = [];

  @override
  void initState() {
    super.initState();
    loadWaypoints();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Waypoints")),
      body: ListView.builder(
          itemCount: waypoints.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(waypoints[index].address),
              trailing: ElevatedButton(
                child: const Icon(Icons.delete),
                onPressed: () async {
                  final db = TourPlannerDatabase();
                  await db.deleteWaypoint(waypoints[index].id);
                  loadWaypoints();
                },
              ),
            );
          }),
    );
  }

  void loadWaypoints() async {
    final db = TourPlannerDatabase();
    var wps = await db.getAllWaypoints();

    setState(() {
      waypoints = wps;
    });
  }
}
