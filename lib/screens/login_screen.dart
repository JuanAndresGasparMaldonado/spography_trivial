import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart'; // ESTRICTAMENTE NECESARIO
import 'map_screen.dart';

// Esta pantalla contiene el login del usuario: Pide el usuario o email y la contraseña. Si es incorrecto salta un error
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controladores para leer lo que escribe el usuario
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  
  bool _isLoading = false; // Para el efecto de carga en el botón

  // Función de Login (Conectada a Firebase)
  void _login() async {
    FocusScope.of(context).unfocus(); // Escondemos el teclado
    setState(() => _isLoading = true);

    var userInput = _userController.text.trim();
    if (userInput == 'usuario') userInput = 'fferban041@g.educaand.es'; // TRUCO PARA ACEPTAR "USUARIO"

    // --- LÓGICA DE VALIDACIÓN ---
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: userInput, 
        password: _passController.text.trim()
      );
      
      if (mounted) { // Si es correcto navegamos al Mapa
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MapScreen()));
      }

    } on FirebaseAuthException catch (e) {
      // Si es incorrecto --> ERROR
      String mensaje = "Credenciales incorrectas";
      if (e.code == 'user-not-found') mensaje = "No existe este usuario";
      if (e.code == 'wrong-password') mensaje = "Contraseña incorrecta";

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensaje), backgroundColor: Colors.red));
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Colores del diseño
    const cardColor = Color(0xFF1E1E1E);
    const primaryBlue = Color(0xFF2196F3);

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ---- 1. LA CABECERA ----
              Text("Bienvenido", style: GoogleFonts.montserrat(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 10),
              Text("Inicia sesión para explorar.", style: GoogleFonts.roboto(color: Colors.grey)),
              const SizedBox(height: 50),

              // ---- 2. INPUT DEL USUARIO ----
              TextField(
                controller: _userController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Usuario o Email", filled: true, fillColor: cardColor,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.person, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 20),

              // --- 3. INPUT CONTRASEÑA ---
              TextField(
                controller: _passController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Contraseña", filled: true, fillColor: cardColor,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 40),

              // --- 4. BOTÓN DE LOGIN ---
              SizedBox(
                width: double.infinity, height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(backgroundColor: primaryBlue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white) 
                    : const Text("ENTRAR", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}