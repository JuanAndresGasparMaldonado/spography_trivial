import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreditsScreen extends StatelessWidget {
  const CreditsScreen({super.key});

// Esta pantalla contiene los creditos de la aplicación, donde aparece el logo, nombre, versión, tarjeta del desarrollador y copyright
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
            Image.asset(
              'assets/logo_spography.png',
              width: 200, 
              height: 200,
            ),
            const SizedBox(height: 20),
            Text("Spography Trivial", style: GoogleFonts.montserrat(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            Text("v1.0.0", style: GoogleFonts.montserrat(color: Colors.grey)),
            
            const SizedBox(height: 50),
            
            // Tarjeta del desarrollador
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFF2196F3).withValues(alpha: 0.3)),
              ),
              child: Column(
                children: [
                  Text("Desarrollado por:", style: GoogleFonts.montserrat(color: const Color(0xFF2196F3), fontSize: 12)),
                  const SizedBox(height: 10),
                  Text(
                    "Juan Andrés\nGaspar Maldonado",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text("Programación Multimedia y\nDispositivos Móviles", textAlign: TextAlign.center, style: GoogleFonts.montserrat(color: Colors.grey, fontSize: 10)),
                ],
              ),
            ),
            
            const Spacer(),
            Text("©2026 Spography. Todos los derechos reservados", style: GoogleFonts.montserrat(color: Colors.grey[700], fontSize: 10)),
            const SizedBox(height: 150),
          ],
        ),
      ),
    );
  }
}