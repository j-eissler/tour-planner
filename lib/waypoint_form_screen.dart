import 'package:flutter/material.dart';
import 'package:tour_planner/database.dart';
import 'package:tour_planner/waypoint_model.dart';

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
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing data')),
                    );
                  }
                  final db = TourPlannerDatabase();
                  db.addWaypoint(Waypoint(address: _address, city: _city));

                  Navigator.of(context).pop();
                },
                child: const Text('Submit')),
          ],
        ),
      ),
    );
  }
}
