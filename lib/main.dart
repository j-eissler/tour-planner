import 'package:flutter/material.dart';
import 'package:tour_planner/waypoint_form_screen.dart';
import 'package:tour_planner/waypoint_list_screen.dart';
import 'package:tour_planner/map_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 0, 107, 255)),
        useMaterial3: true,
      ),
      initialRoute: '/map',
      routes: {
        '/map': (context) => const MapScreen(),
        '/waypoints_list': (context) => const WaypointsListScreen(),
        '/waypoint_form': (context) => const WaypointFormScreen()
      },
    );
  }
}
