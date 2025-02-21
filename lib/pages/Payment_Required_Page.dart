import 'package:flutter/material.dart';

class PaymentRequiredPage extends StatelessWidget {
  const PaymentRequiredPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Payment Required'),
      ),
      body: const Center(
        child: Text('Please purchase the app to access this feature.'),
      ),
    );
  }
}