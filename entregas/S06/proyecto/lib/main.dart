import 'package:flutter/material.dart';

const kFondo = Color(0xFF0E120C);
const kSuperficie = Color(0xFF181E14);
const kBorde = Color(0xFF2A3222);
const kTexto = Color(0xFFF1F4EA);
const kMuted = Color(0xFF8F9C80);
const kLima = Color(0xFFC8F54E);
const kIconoFondo = Color(0xFF37491C);

void main() {
    runApp(const MyApp());
}

class MyApp extends StatelessWidget {
    const MyApp({super.key});

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                brightness: Brightness.dark,
                scaffoldBackgroundColor: kFondo,
            ),
            home: Scaffold(
                body: SafeArea (
                    child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                            Text('Hola, Luis', style: TextStyle(fontSize: 20, color: kTexto)),

                            const SizedBox(height: 22),
                            Card(
                                color: kSuperficie,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    side: const BorderSide(color: kBorde),
                                ),
                                child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                            Text('Tu hora ideal para dormir', style: TextStyle(fontSize: 11, color: kLima)),
                                            const SizedBox(height: 6),
                                            Text('10:00 p.m.', style: TextStyle(fontSize: 40, color: kTexto, fontWeight: FontWeight.w500)),
                                        ],
                                    )
                                ),
                            ),

                            const SizedBox(height: 18),
                            Card(
                                color: kSuperficie,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    side: const BorderSide(color: kBorde),
                                ),
                                child: Padding(
                                    padding: const EdgeInsets.all(14),
                                    child: Row(
                                        children: [
                                            Icon(Icons.bedtime, color: kLima),
                                            const SizedBox(width: 12),
                                            Text('Anoche dormiste 6h de 7.5h planeadas', style: TextStyle(fontSize: 14, color: kTexto)),
                                        ],
                                    ),
                                ),
                            ),

                            const SizedBox(height: 18),
                            Row(
                              children: [
                                Expanded(
                                  child: Card(
                                    color: kSuperficie,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      side: const BorderSide(color: kBorde),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(14),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Racha', style: TextStyle(fontSize: 11, color: kMuted)),
                                          const SizedBox(height: 4),
                                          Text('3 días', style: TextStyle(fontSize: 19, color: kTexto)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Card(
                                    color: kSuperficie, 
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      side: const BorderSide(color: kBorde),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(14),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Promedio Semanal', style: TextStyle(fontSize: 11, color: kMuted)),
                                          const SizedBox(height: 4),
                                          Text('6.8h', style: TextStyle(fontSize: 19, color: kTexto)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 30),
                            Text('¿Cómo se vería tu noche?', style: TextStyle(fontSize: 18, color: kTexto)),
                            const SizedBox(height: 6),
                            Text(
                                'Un recorrido rápido por las tres partes de la app: el aviso, la interrupción y el resumen de la mañana',
                                style: TextStyle(fontSize: 13, color: kMuted), 
                            ),

                            const SizedBox(height: 14),
                            SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: kLima,
                                        foregroundColor: kFondo,
                                        padding: const EdgeInsets.symmetric(vertical: 14)
                                    ),
                                    onPressed: () {},
                                    child: Text('Empezar simulación'),
                                ),
                            ),
                        ],
                    ),
                ),
                bottomNavigationBar: BottomNavigationBar(
                    currentIndex: 0,
                    type: BottomNavigationBarType.fixed,
                    backgroundColor: kSuperficie,
                    selectedItemColor: kLima,
                    unselectedItemColor: kMuted,
                    onTap: (i) {},
                    items: const [
                        BottomNavigationBarItem(icon: Icon(Icons.nightlight_round), label: 'Inicio'),
                        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Historial'),
                        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Ajustes'),
                    ],
                ),
            ),
        );
    }
}