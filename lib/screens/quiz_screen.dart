import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Esta pantalla sera el quiz de preguntas. Al final se mostraran los puntos totales ganados.
class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  // --- VARIABLES DEL JUEGO ---
  int _questionIndex = 0; // ¿En qué pregunta estamos? (Empieza en la 0)
  int _score = 0; // Puntos actuales
  bool _isLocked = false; // Para evitar que pulsen dos botones a la vez rápido

  // --- LÓGICA: PROCESAR RESPUESTA ---
  void _answerQuestion(
    String selected,
    String correct,
    int totalQuestions,
  ) async {
    if (_isLocked) return; // Si ya pulsó, no dejamos pulsar otra vez

    setState(() {
      _isLocked = true; // Bloqueamos botones
    });

    bool isCorrect = (selected == correct);

    if (isCorrect) {
      _score += 10; // Sumamos 10 puntos si acierta
    }

    // 1. Feedback visual (SnackBar)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isCorrect
              ? "¡Correcto! (+10 pts) 🎉"
              : "Fallaste... Era: $correct 😢",
          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
        ),
        backgroundColor: isCorrect ? Colors.green : Colors.redAccent,
        duration: const Duration(seconds: 1), // Dura 1 segundo
      ),
    );

    // 2. Esperamos un poquito para que lea el mensaje antes de cambiar
    await Future.delayed(const Duration(milliseconds: 1200));

    // 3. Pasamos a la siguiente pregunta
    if (mounted) {
      setState(() {
        _questionIndex++; // Avanzamos índice
        _isLocked = false; // Desbloqueamos para la siguiente
      });
    }
  }

  // --- LÓGICA: REINICIAR JUEGO ---
  void _resetQuiz() {
    setState(() {
      _questionIndex = 0;
      _score = 0;
      _isLocked = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      // Leemos TODAS las preguntas de la colección
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('preguntas').snapshots(),
        builder: (context, snapshot) {
          // A. Si no hay datos aún (Cargando)
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var questions =
              snapshot.data!.docs; // La lista de todas las preguntas
          int totalQuestions = questions.length;

          // B. Si la lista está vacía
          if (questions.isEmpty) {
            return const Center(
              child: Text(
                "No hay preguntas en Firebase",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          // C. COMPROBAR SI EL JUEGO HA TERMINADO
          if (_questionIndex >= totalQuestions) {
            // --- PANTALLA FINAL (RESULTADOS) ---
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.emoji_events,
                    size: 100,
                    color: Colors.amber,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "¡Quiz Terminado!",
                    style: GoogleFonts.montserrat(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Puntuación Final: $_score / ${totalQuestions * 10}",
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _resetQuiz,
                    icon: const Icon(Icons.replay),
                    label: const Text("Volver a jugar"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2196F3),
                      foregroundColor: Colors.white,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(
                      context,
                    ), // Salir al menú anterior o mapa (si vienes del drawer no hace pop, cuidado)
                    child: const Text(
                      "Salir",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            );
          }

          // D. PANTALLA DE JUEGO (SI AÚN QUEDAN PREGUNTAS)
          // Cogemos la pregunta actual según el índice
          var currentData = questions[_questionIndex];
          String questionTitle = currentData['titulo'];
          String correctAnswer = currentData['correcta'];
          List<dynamic> options = currentData['opciones'];

          return Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.emoji_events,
                    size: 50,
                    color: Color(0xFF2196F3),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Modo Quiz",
                    style: GoogleFonts.montserrat(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Muestra "Pregunta 1/5", "Pregunta 2/5"...
                  Text(
                    "Pregunta ${_questionIndex + 1}/$totalQuestions",
                    style: const TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 10),

                  // CAJA DE LA PREGUNTA
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFF2196F3)),
                      ),
                      child: Text(
                        questionTitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // OPCIONES DE RESPUESTA
                  ...options.map((option) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 10,
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E1E1E),
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(color: Colors.grey),
                          ),
                        ),
                        // Al pulsar, llamamos a la función con lógica
                        onPressed: () => _answerQuestion(
                          option.toString(),
                          correctAnswer,
                          totalQuestions,
                        ),
                        child: Text(
                          option.toString(),
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
