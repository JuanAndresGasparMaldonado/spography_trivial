import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Esta pantalla sera el quiz de preguntas, serán 10 preguntas con 4 respuestas y se tendrá que seleccionar una de las opciones. Al final se mostraran los puntos totales ganados
class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.emoji_events, size: 80, color: Color(0xFF2196F3)),
            const SizedBox(height: 20),
            Text(
              "Modo Quiz",
              style: GoogleFonts.montserrat(
                fontSize: 24, 
                color: Colors.white, 
                fontWeight: FontWeight.bold
              )
            ),
            const SizedBox(height: 10),
            const Text("Pregunta 1/10", style: TextStyle(color: Colors.grey)),
            
            const SizedBox(height: 40),
            
            // Botón simulado de respuesta
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E), 
                borderRadius: BorderRadius.circular(10), 
                border: Border.all(color: const Color(0xFF2196F3))
              ),
              child: const Text(
                "¿En qué año ganó España el mundial?", 
                style: TextStyle(color: Colors.white)
              ),
            )
          ],
        ),
      ),
    );
  }
}