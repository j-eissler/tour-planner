import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:tour_planner/database.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    loadMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Map"),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.inversePrimary),
                child: Text("Menu",
                    style: Theme.of(context).textTheme.headlineLarge)),
            ListTile(
              leading: const Icon(Icons.view_list),
              title: const Text("Waypoints"),
              onTap: () async {
                // Wait until returned from next screen
                await Navigator.pushNamed(context, '/waypoints_list');
                loadMarkers();
              },
            ),
            // TODO: Add AboutListTile
          ],
        ),
      ),
      body: FlutterMap(
          options: const MapOptions(
            initialCenter: LatLng(50.775555, 6.083611),
            initialRotation: 0,
            interactionOptions: InteractionOptions(
                flags: InteractiveFlag.all & ~InteractiveFlag.rotate),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.app',
            ),
            MarkerLayer(
              markers: _markers,
              alignment: Alignment.topCenter,
            ),
          ]),
    );
  }

  void loadMarkers() async {
    final db = TourPlannerDatabase();
    var waypoints = await db.getAllWaypoints();

    List<Marker> markers = [];
    for (var wp in waypoints) {
      if (wp.lat == null || wp.long == null) continue;

      Marker m = Marker(
        point: LatLng(wp.lat!, wp.long!),
        width: 40,
        height: 40,
        child: const FittedBox(
          child: Icon(
            Icons.location_on,
            color: Colors.red,
          ),
        ),
      );
      markers.add(m);
    }

    setState(() {
      _markers = markers;
    });
  }
}
