import 'package:flutter/material.dart';

class SecretScreen extends StatefulWidget {
  const SecretScreen({super.key});

  @override
  State<SecretScreen> createState() => _SecretScreenState();
}

class _SecretScreenState extends State<SecretScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('tala secreta'),
    );
  }
}
