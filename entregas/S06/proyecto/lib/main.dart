import 'package:flutter/material.dart';

void main() {
  runApp(const MiApp());
}

class MiApp extends StatelessWidget {
  const MiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Simple',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const PantallaSaludo(),
    );
  }
}

class PantallaSaludo extends StatefulWidget {
  const PantallaSaludo({super.key});

  @override
  State<PantallaSaludo> createState() => _PantallaSaludoState();
}

class _PantallaSaludoState extends State<PantallaSaludo> {
  String _mensaje = 'Presiona el botón';

  void _saludar() {
    setState(() {
      _mensaje = '¡Hola, bienvenido a Flutter!';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Simple'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _mensaje,
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saludar,
              child: const Text('Saludar'),
            ),
          ],
        ),
      ),
    );
  }
}