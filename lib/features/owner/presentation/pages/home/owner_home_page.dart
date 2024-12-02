import 'package:flutter/material.dart';

class OwnerHomePage extends StatelessWidget {
  const OwnerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments'),
        centerTitle: false,
      ),
      body: const Center(
        child: Text('Appointments'),
      ),
    );
  }
}
