import 'package:flutter/material.dart';

void main() {
  runApp(const MarcadorApp());
}

class MarcadorApp extends StatelessWidget {
  const MarcadorApp({super.key, this.home});

  final Widget? home;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Marcador Deportivo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: home ?? const MarcadorPage(),
    );
  }
}

class MarcadorPage extends StatefulWidget {
  const MarcadorPage({
    super.key,
    this.puntosInicialesEquipoA = 0,
    this.puntosInicialesEquipoB = 0,
  });

  final int puntosInicialesEquipoA;
  final int puntosInicialesEquipoB;

  @override
  State<MarcadorPage> createState() => _MarcadorPageState();
}

class _MarcadorPageState extends State<MarcadorPage> {
  static const Color _colorNeutro = Colors.black87;
  static const Color _colorLider = Colors.green;

  late int _puntosEquipoA = widget.puntosInicialesEquipoA;
  late int _puntosEquipoB = widget.puntosInicialesEquipoB;

  bool get _hayEmpate => _puntosEquipoA == _puntosEquipoB;

  bool get _ganaEquipoA => _puntosEquipoA > _puntosEquipoB;

  String get _mensajeResultado {
    if (_hayEmpate) return 'Empate';
    return _ganaEquipoA ? 'Va ganando Equipo A' : 'Va ganando Equipo B';
  }

  Color get _colorEquipoA =>
      (!_hayEmpate && _ganaEquipoA) ? _colorLider : _colorNeutro;

  Color get _colorEquipoB =>
      (!_hayEmpate && !_ganaEquipoA) ? _colorLider : _colorNeutro;

  void _sumarPuntos(bool equipoA) {
    setState(() {
      if (equipoA) {
        _puntosEquipoA++;
      } else {
        _puntosEquipoB++;
      }
    });
  }

  void _restarPuntos(bool equipoA) {
    setState(() {
      if (equipoA && _puntosEquipoA > 0) {
        _puntosEquipoA--;
      } else if (!equipoA && _puntosEquipoB > 0) {
        _puntosEquipoB--;
      }
    });
  }

  void _reiniciar() {
    setState(() {
      _puntosEquipoA = 0;
      _puntosEquipoB = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Marcador Deportivo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: _ColumnaEquipo(
                    nombre: 'Equipo A',
                    puntos: _puntosEquipoA,
                    color: _colorEquipoA,
                    onSumar: () => _sumarPuntos(true),
                    onRestar: () => _restarPuntos(true),
                  ),
                ),
                Expanded(
                  child: _ColumnaEquipo(
                    nombre: 'Equipo B',
                    puntos: _puntosEquipoB,
                    color: _colorEquipoB,
                    onSumar: () => _sumarPuntos(false),
                    onRestar: () => _restarPuntos(false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              _mensajeResultado,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: _hayEmpate ? _colorNeutro : _colorLider,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _reiniciar,
              child: const Text('Reiniciar'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ColumnaEquipo extends StatelessWidget {
  const _ColumnaEquipo({
    required this.nombre,
    required this.puntos,
    required this.color,
    required this.onSumar,
    required this.onRestar,
  });

  final String nombre;
  final int puntos;
  final Color color;
  final VoidCallback onSumar;
  final VoidCallback onRestar;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          nombre,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '$puntos',
          style: TextStyle(
            fontSize: 64,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: onRestar,
              child: const Text('-1'),
            ),
            const SizedBox(width: 12),
            FilledButton(
              onPressed: onSumar,
              child: const Text('+1'),
            ),
          ],
        ),
      ],
    );
  }
}