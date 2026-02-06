import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    // Escondemos el teclado
    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
    });

    final user = _userController.text.trim();
    final pass = _passController.text.trim();

    // --- LÓGICA DE VALIDACIÓN ---
    try {
      // Intentamos loguear en Firebase con los datos introducidos
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: user,
        password: pass,
      );

      // Si es correcto navegamos al Mapa
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MapScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      // Si es incorrecto --> ERROR
      // Determinamos el mensaje según el error de Firebase
      String mensajeError = "Credenciales incorrectas";
      if (e.code == 'user-not-found') mensajeError = "No existe este usuario";
      if (e.code == 'wrong-password') mensajeError = "Contraseña incorrecta";
      if (e.code == 'invalid-email') mensajeError = "El email no es válido";

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              mensajeError,
              style: GoogleFonts.roboto(color: Colors.white),
            ),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Colores del diseño
    const bgColor = Color(0xFF121212);
    const cardColor = Color(0xFF1E1E1E);
    const primaryBlue = Color(0xFF2196F3);

    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---- 1. LA CABECERA ----
              Text(
                "Bienvenido,",
                style: GoogleFonts.montserrat(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Inicia sesión para explorar el mundo.",
                style: GoogleFonts.roboto(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 50),

              // ---- 2. INPUT DEL USUARIO ----
              Text(
                "Usuario o Email",
                style: GoogleFonts.roboto(
                  color: primaryBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _userController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText:
                      "Ej. usuario@prueba.com", // Pequeño cambio para recordar formato email
                  filled: true,
                  fillColor: cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: primaryBlue, width: 2),
                  ),
                  prefixIcon: const Icon(
                    Icons.person_outline,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // --- 3. INPUT CONTRASEÑA ---
              Text(
                "Contraseña",
                style: GoogleFonts.roboto(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _passController,
                obscureText: true, // Ocultar texto
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "••••••••",
                  filled: true,
                  fillColor: cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white, width: 1),
                  ),
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: Colors.grey,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // --- 4. BOTÓN DE LOGIN ---
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                    shadowColor: primaryBlue.withValues(alpha: 0.4),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          "ENTRAR",
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 20),

              // --- 5. REGISTRO (Solo visual por ahora) ---
              Center(
                child: TextButton(
                  onPressed: () {
                    // Aquí iría al registro
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "¿No tienes cuenta? ",
                      style: const TextStyle(color: Colors.grey),
                      children: [
                        TextSpan(
                          text: "Regístrate",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
