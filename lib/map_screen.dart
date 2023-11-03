import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:tour_planner/database.dart';
import 'package:geolocator/geolocator.dart';

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
    requestLocationPermissions();
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
            CurrentLocationLayer(),
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

  void requestLocationPermissions() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    setState(() {});
  }
}
