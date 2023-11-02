import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:tour_planner/database.dart';
import 'package:tour_planner/waypoint_model.dart';
import 'package:http/http.dart' as http;

class WaypointFormScreen extends StatefulWidget {
  const WaypointFormScreen({super.key});

  @override
  State<WaypointFormScreen> createState() => _WaypointFormScreenState();
}

class _WaypointFormScreenState extends State<WaypointFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String _address = '';
  String _city = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Enter waypoint information")),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
                decoration: const InputDecoration(
                    icon: Icon(Icons.location_on), labelText: 'Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field cannot be empty';
                  }
                  _address = value;
                  return null;
                }),
            TextFormField(
                decoration:
                    const InputDecoration(icon: Icon(null), labelText: 'City'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field cannot be empty';
                  }
                  _city = value;
                  return null;
                }),
            ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing data')),
                    );
                  }

                  final coords = await getCoordinates(_address, _city);

                  final db = TourPlannerDatabase();
                  db.addWaypoint(Waypoint(
                      address: _address,
                      city: _city,
                      lat: coords?.latitude,
                      long: coords?.longitude));

                  // Because this function is async, we need to check if the widget is still mounted.
                  // We need to avoid popping a navigator route when the widget doesn't exist anymore.
                  if (mounted) {
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Submit')),
          ],
        ),
      ),
    );
  }

  Future<LatLng?> getCoordinates(String address, String city) async {
    final response = await http.get(Uri.parse(
        'https://nominatim.openstreetmap.org/search?format=jsonv2&limit=1&q=$address,$city'));

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
}
