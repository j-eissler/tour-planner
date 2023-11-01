import 'package:flutter/material.dart';
import 'package:tour_planner/address_list_screen.dart';
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/map',
      routes: {
        '/map': (context) => const MapScreen(),
        '/address_list': (context) => const AddressListScreen()
      },
    );
  }
}
