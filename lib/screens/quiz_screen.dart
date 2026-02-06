import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import para conectar con la BD

// Esta pantalla sera el quiz de preguntas, serán 10 preguntas con 4 respuestas y se tendrá que seleccionar una de las opciones. Al final se mostraran los puntos totales ganados
class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  // Lógica para comprobar si la respuesta es correcta
  void _checkAnswer(String selected, String correct) {
    bool isCorrect = (selected == correct);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isCorrect ? "¡Correcto!" : "Incorrecto, era: $correct"),
        backgroundColor: isCorrect ? Colors.green : Colors.red,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      // Usamos StreamBuilder para leer la colección 'preguntas' de Firebase
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('preguntas').snapshots(),
        builder: (context, snapshot) {
          // 1. Si no hay datos aún (Cargando)
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Si la lista está vacía
          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No hay preguntas en Firebase",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          // 3. Cogemos la primera pregunta (docs[0]) para probar
          var data = snapshot.data!.docs[0];
          String questionTitle = data['titulo'];
          String correctAnswer = data['correcta'];
          List<dynamic> options = data['opciones'];

          return Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.emoji_events,
                    size: 80,
                    color: Color(0xFF2196F3),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Modo Quiz",
                    style: GoogleFonts.montserrat(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Pregunta 1/10",
                    style: TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 40),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFF2196F3)),
                      ),
                      child: Text(
                        questionTitle, // Aquí va el texto de Firebase
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Generamos los botones de las opciones dinámicamente
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
                        onPressed: () =>
                            _checkAnswer(option.toString(), correctAnswer),
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
