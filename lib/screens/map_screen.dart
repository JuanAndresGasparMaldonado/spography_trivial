import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // <--- ESTRICTAMENTE NECESARIO: Importar Firestore

// --- IMPORTAMOS LAS PANTALLAS ---
import 'quiz_screen.dart';
import 'profile_screen.dart';
import 'credits_screen.dart';
import 'login_screen.dart';

// Esta pantalla es la más importante, se basa en un mapa interactivo en cual se podrán seleccionar los países y mostrará sus datos
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _selectedIndex = 2; // Empezamos en el Mapa (Posición 2)

  // <--- ESTRICTAMENTE NECESARIO: Prueba de conexión a Firestore ---
  @override
  void initState() {
    super.initState();
    // Esto escribe en la base de datos al abrir la pantalla para comprobar que funciona
    FirebaseFirestore.instance.collection('pruebas_conexion').add({
      'mensaje': '¡Conexión exitosa desde la app!',
      'fecha': DateTime.now().toString(),
      'usuario': 'Test automático',
    }).then((documento) {});
  }
  // ----------------------------------------------------------------

  // ---- LISTA DE PANTALLAS ----
  final List<Widget> _pages = [
    const ProfileScreen(), // 0
    const QuizScreen(), // 1
    const _MapContent(), // 2
  ];

  void _onItemTapped(int index) {
    if (index == 3) {
      _scaffoldKey.currentState?.openDrawer(); // Abre menú
    } else {
      setState(() {
        _selectedIndex = index; // Cambia pantalla
      });
    }
  }

  // Navegar desde el menú lateral
  void _navigateFromDrawer(int index) {
    Navigator.pop(context);
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFF121212),
      extendBody: true,

      // ---- MENÚ LATERAL (DRAWER) ----
      drawer: Drawer(
        backgroundColor: const Color(0xFF121212),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFF1E1E1E)),
              accountName: Text(
                "Usuario",
                style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
              ),
              accountEmail: const Text("usuario@gmail.com"),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Color(0xFF2196F3),
                child: Text(
                  "U",
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.public, color: Color(0xFF2196F3)),
              title: const Text(
                "Mapa Interactivo",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () => _navigateFromDrawer(2),
            ),
            ListTile(
              leading: const Icon(Icons.emoji_events, color: Colors.white),
              title: const Text(
                "Quiz / Copa",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () => _navigateFromDrawer(1),
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.white),
              title: const Text(
                "Mi Perfil",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () => _navigateFromDrawer(0),
            ),
            const Divider(color: Colors.grey),
            ListTile(
              leading: const Icon(Icons.info_outline, color: Colors.white),
              title: const Text(
                "Créditos",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreditsScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text(
                "Cerrar Sesión",
                style: TextStyle(color: Colors.redAccent),
              ),
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        ),
      ),

      // ---- CUERPO ----
      body: IndexedStack(index: _selectedIndex, children: _pages),

      // ---- BARRA DE NAVEGACIÓN ----
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 30),
        height: 70,
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(35),
          boxShadow: [
            // Sombra suave
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
            // Brillo azul
            BoxShadow(
              color: const Color(0xFF2196F3).withValues(alpha: 0.2),
              blurRadius: 20,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _barraNavIconos(Icons.person, 0), // Perfil
            _barraNavIconos(Icons.emoji_events, 1), // Quiz (Destacado)
            _barraNavIconos(Icons.public, 2), // Mapa (Destacado)
            _barraNavIconos(Icons.menu, 3), // Menú
          ],
        ),
      ),
    );
  }

  // Widget que anima la barra de navegación e indica cuál está seleccionada y destaca los icónos de las pantallas princi
  Widget _barraNavIconos(IconData icon, int index) {
    // 1. ¿Está seleccionado este botón?
    final bool isSelected = _selectedIndex == index;

    // 2. ¿Es un botón destacado (Copa o Mapa)?
    final bool isProminent = (index == 1 || index == 2);

    // 3. Definimos el color
    Color iconColor;
    if (isSelected && index != 3) {
      iconColor = const Color(
        0xFF2196F3,
      ); // AZUL si está seleccionado (menos el menú)
    } else if (isProminent) {
      iconColor =
          Colors.white; // BLANCO si es Copa/Mapa pero no está seleccionado
    } else {
      iconColor = Colors.grey; // GRIS para el resto
    }

    // 4. Definimos el tamaño de los icons
    double iconSize = isProminent ? 34 : 26; // Grandes o Normales

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.transparent,
        child: Icon(icon, size: iconSize, color: iconColor),
      ),
    );
  }
}

// --- PANTALLA MAPA (POR AHORA VACÍA) ---
class _MapContent extends StatelessWidget {
  const _MapContent();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0D2644), // Fondo Azul Tipo océano
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.public,
              size: 150,
              color: const Color(0xFF3E5641).withValues(alpha: 0.8),
            ),
            const SizedBox(height: 30),
            Text(
              "Mapa Interactivo",
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "(Próximamente)",
              style: GoogleFonts.montserrat(
                color: Colors.white54,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}