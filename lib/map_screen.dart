import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
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
              onTap: () => Navigator.pushNamed(context, '/waypoints_list'),
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
          ]),
    );
  }
}
