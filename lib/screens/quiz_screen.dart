import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Esta pantalla sera el quiz de preguntas. Al final se mostraran los puntos totales ganados.
class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  // --- VARIABLES DEL JUEGO ---
  int _index = 0; 
  int _score = 0;         
  bool _bloqueado = false;

  void _guardarPuntuacion() async {
    // Guardamos la memoria en local con SharedPreferences)
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('puntos_guardados', _score); // Guardamos la nota con la clave 'puntos_guardados'

    // Guardamos en la base de datos (Firestore)
    // Usamos el email del usuario o "user" si no hay
    String usuario = "user";
    
    await FirebaseFirestore.instance.collection('puntuaciones').add({
      'puntos': _score,
      'fecha': DateTime.now().toString(),
      'usuario': usuario,
    });

    debugPrint("✅ Puntuación guardada en Memoria y Nube");
  }

  // --- LÓGICA: PROCESAR RESPUESTA ---
  void _responder(String elegida, String correcta, int total) async {
    if (_bloqueado) return;
    setState(() => _bloqueado = true);

    bool acerto = (elegida == correcta);
    if (acerto) _score += 10;

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(acerto ? "¡Correcto! (+10) 🎉" : "Fallaste... Era: $correcta"),
      backgroundColor: acerto ? Colors.green : Colors.red,
      duration: const Duration(milliseconds: 1000),
    ));

    await Future.delayed(const Duration(milliseconds: 1200));
    
    if (mounted) {
      setState(() { 
        _index++; 
        _bloqueado = false; 
      });

      // Si hemos llegado al final, guardamos
      if (_index >= total) {
        _guardarPuntuacion();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('preguntas').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          
          var preguntas = snapshot.data!.docs;
          if (preguntas.isEmpty) return const Center(child: Text("Sin preguntas", style: TextStyle(color: Colors.white)));

          // Si terminamos las preguntas, mostramos el final; si no, la pregunta actual
          if (_index >= preguntas.length) {
            return _pantallaFinal(preguntas.length * 10);
          } else {
            return _pantallaPregunta(preguntas[_index], preguntas.length);
          }
        },
      ),
    );
  }

  // Widget separado para mostrar el final (Más limpio)
  Widget _pantallaFinal(int maxPuntos) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.emoji_events, size: 100, color: Colors.amber),
          Text("¡Terminado!", style: GoogleFonts.montserrat(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold)),
          Text("Puntos: $_score / $maxPuntos", style: GoogleFonts.montserrat(fontSize: 20, color: Colors.blue)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => setState(() { _index = 0; _score = 0; }),
            child: const Text("Volver a jugar"),
          )
        ],
      ),
    );
  }

  // Widget separado para mostrar la pregunta (Más limpio)
  Widget _pantallaPregunta(QueryDocumentSnapshot data, int total) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Pregunta ${_index + 1}/$total", style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 20),
          
          // Caja de pregunta
          Container(
            width: double.infinity, padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.blue)),
            child: Text(data['titulo'], textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 18)),
          ),
          const SizedBox(height: 20),

          // Generar botones de opciones
          ...data['opciones'].map<Widget>((opcion) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E1E1E), minimumSize: const Size(double.infinity, 50)),
                onPressed: () => _responder(opcion.toString(), data['correcta'], total),
                child: Text(opcion.toString(), style: const TextStyle(color: Colors.white)),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}