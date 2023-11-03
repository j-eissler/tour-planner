import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:tour_planner/database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:tour_planner/waypoint_model.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final mapController = MapController();
  final initalPosition = const LatLng(50.775555, 6.083611);
  final initalZoom = 13.0;
  List<Marker> _markers = [];

  final addressTextFieldController = TextEditingController();

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
            // TODO: Add settings menu. Settings: marker color, marker size
            // TODO: Add AboutListTile
          ],
        ),
      ),
      body: Stack(
        children: [
          FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: initalPosition,
                initialRotation: 0,
                initialZoom: initalZoom,
                interactionOptions: const InteractionOptions(
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
          // Address search field
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black45,
                    blurRadius: 6.0,
                  ),
                ],
              ),
              child: TextField(
                controller: addressTextFieldController,
                onSubmitted: _searchAddress,
                decoration: const InputDecoration(
                  hintText: 'Search address',
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.all(12.0),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Show all waypoints
          FloatingActionButton(
            onPressed: () {
              List<LatLng> points = [];
              for (var e in _markers) {
                points.add(e.point);
              }
              final bounds = LatLngBounds.fromPoints(points);
              mapController.fitCamera(CameraFit.bounds(bounds: bounds));
              // Zoom out a little bit to avoid having the outer markers exactly at the edge of the screen
              mapController.move(
                  mapController.camera.center, mapController.camera.zoom - 0.5);
            },
            heroTag: 'fab2',
            child: const Icon(Icons.fullscreen),
          ),
          const SizedBox(
            width: 10,
            height: 15,
          ),
          // Center on location
          FloatingActionButton(
            child: const Icon(Icons.gps_fixed),
            onPressed: () async {
              await requestLocationPermissions();
              final pos = await Geolocator.getCurrentPosition();
              setState(() {
                mapController.move(
                    LatLng(pos.latitude, pos.longitude), initalZoom);
              });
            },
            heroTag: 'fab1', // heroTag must be unique
          ),
        ],
      ),
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

  Future<void> requestLocationPermissions() async {
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

  Future<LatLng?> _getCoordinates(String address) async {
    final response = await http.get(Uri.parse(
        'https://nominatim.openstreetmap.org/search?format=jsonv2&limit=1&q=$address'));

    if (response.statusCode == 200) {
      try {
        final json = jsonDecode(response.body);
        final lat = double.parse(json[0]['lat']);
        final long = double.parse(json[0]['lon']);
        return LatLng(lat, long);
      } catch (e) {
        print('Error: failed to get lat,lon from response');
      }
    } else {
      throw Exception('Failed to get coordinates');
    }

    return null;
  }

  void _searchAddress(String? input) async {
    if (input == null) return;

    final coords = await _getCoordinates(input);
    if (coords == null) {
      _showSnackBar('Address not found');
      return;
    }

    final db = TourPlannerDatabase();
    db.addWaypoint(Waypoint(
        address: input,
        city: '',
        lat: coords.latitude,
        long: coords.longitude));

    loadMarkers();

    addressTextFieldController.clear();

    _showSnackBar('Waypoint added');

    mapController.move(coords, initalZoom);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
