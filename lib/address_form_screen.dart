import 'package:flutter/material.dart';

class AddressFormScreen extends StatelessWidget {
  const AddressFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Enter address information")),
      body: const Center(child: Text("Enter data here")),
    );
  }
}
