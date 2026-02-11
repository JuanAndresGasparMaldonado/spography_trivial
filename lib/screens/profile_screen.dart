import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Esta pantalla muestra los datos del usuario con su nombre, su rango para indicar su nivel com jugador, sus puntos totales conseguidos en los quiz y las preguntas de paises en el mapa interactivos acertadas
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

@override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _puntosGuardados = 0; // En esta variable guardaremos los puntos

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  // ---- FUNCIÓN PARA LEER DE MEMORIA ----
  void _cargarDatos() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // Leemos 'puntos_guardados', Si no existe, devuelve 0.
      _puntosGuardados = prefs.getInt('puntos_guardados') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50, 
              backgroundColor: Color(0xFF2196F3), 
              child: Text("U", style: TextStyle(fontSize: 40, color: Colors.white))
            ),
            const SizedBox(height: 20),
            Text("Usuario", style: GoogleFonts.montserrat(fontSize: 22, color: Colors.white)),
            Text("Rango: Principiante", style: GoogleFonts.montserrat(color: Colors.greenAccent)),
            const SizedBox(height: 20),

            // Aquí creamos la carta con los puntos reales del jugador
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(15)),
              child: Column(
                children: [
                  const Text("PUNTUACIÓN ÚLTIMA PARTIDA", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 5),
                  Text(
                    "$_puntosGuardados",
                    style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)
                  ),
                  const Text("(Leído de Memoria Interna)", style: TextStyle(color: Colors.white24, fontSize: 10)),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _cargarDatos, 
              child: const Text("Actualizar Datos")
            )
          ],
        ),
      ),
    );
  }
}