import 'package:flutter/material.dart';

class AddressListScreen extends StatelessWidget {
  const AddressListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Address List")),
      body: const Center(
          child: Text("This screen shows all the addresses in the database")),
    );
  }
}
