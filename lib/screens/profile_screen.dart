import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Esta pantalla muestra los datos del usuario con su nombre, su rango para indicar su nivel com jugador, sus puntos totales conseguidos en los quiz y las preguntas de paises en el mapa interactivos acertadas
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            // Avatar del usuario
            const CircleAvatar(
              radius: 50, 
              backgroundColor: Color(0xFF2196F3), 
              child: Text("U", style: TextStyle(fontSize: 40, color: Colors.white))
            ),
            const SizedBox(height: 20),
            
            // Nombre y rango del jugador
            Text(
              "Usuario", 
              style: GoogleFonts.montserrat(fontSize: 22, color: Colors.white)
            ),
            Text("Rango: Principiante", style: GoogleFonts.montserrat(color: Colors.greenAccent)),
            
            const SizedBox(height: 20),
            
            // Estadísticas del jugador
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _cartaDatos("Puntos", "1,250"),
                const SizedBox(width: 20),
                _cartaDatos("Países", "12"),
              ],
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }
  // Widget donde se mostraran actualizados más adelante los datos del jugador
  Widget _cartaDatos(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E), 
        borderRadius: BorderRadius.circular(10)
      ),
      child: Column(
        children: [
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}