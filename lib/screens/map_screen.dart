import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';

// --- IMPORTAMOS LAS PANTALLAS ---
import 'quiz_screen.dart';
import 'profile_screen.dart';
import 'credits_screen.dart';
import 'login_screen.dart';

// Esta pantalla es la más importante, contiene el Mapa y el Menú Principal.El mapa es interactivo en el cual se podrán seleccionar los países y mostrará sus datos
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 2; // Empezamos en el Mapa (Posición 2)

  // ---- LISTA DE PANTALLAS ----
  final List<Widget> _pages = [
    const ProfileScreen(), // 0
    const QuizScreen(),    // 1
    const _MapContent(),   // 2
  ];

  // Función para cambiar de pantalla desde la barra de abajo
  void _onItemTapped(int index) {
    if (index == 3) {
      _scaffoldKey.currentState?.openDrawer(); // Abre menú
    } else {
      setState(() => _selectedIndex = index); // Cambia pantalla
    }
  }

  // Función para cambiar de pantalla desde el menú lateral
  void _navigateFromDrawer(int index) {
    Navigator.pop(context); // Cierra el menú
    setState(() => _selectedIndex = index); // Cambia la pantalla
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFF121212),
      
      // ---- MENÚ LATERAL (DRAWER) ----
      drawer: Drawer(
        backgroundColor: const Color(0xFF121212),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // 1. Cabecera del Usuario
            const UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF1E1E1E)),
              accountName: Text("Usuario", style: TextStyle(fontWeight: FontWeight.bold)),
              accountEmail: Text("usuario@prueba.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Color(0xFF2196F3), 
                child: Text("U", style: TextStyle(color: Colors.white, fontSize: 24))
              ),
            ),
            
            // 2. Botones de Navegación (LOS QUE FALTABAN)
            ListTile(
              leading: const Icon(Icons.public, color: Color(0xFF2196F3)),
              title: const Text("Mapa Interactivo", style: TextStyle(color: Colors.white)),
              onTap: () => _navigateFromDrawer(2),
            ),
            ListTile(
              leading: const Icon(Icons.emoji_events, color: Colors.white),
              title: const Text("Quiz / Copa", style: TextStyle(color: Colors.white)),
              onTap: () => _navigateFromDrawer(1),
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.white),
              title: const Text("Mi Perfil", style: TextStyle(color: Colors.white)),
              onTap: () => _navigateFromDrawer(0),
            ),

            const Divider(color: Colors.grey),

            // 3. Otros Botones
            ListTile(
              leading: const Icon(Icons.info_outline, color: Colors.white),
              title: const Text("Créditos", style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context); 
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CreditsScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text("Cerrar Sesión", style: TextStyle(color: Colors.redAccent)),
              onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen())),
            ),
          ],
        ),
      ),

      // ---- CUERPO ----
      body: IndexedStack(index: _selectedIndex, children: _pages),

      // ---- BARRA DE NAVEGACIÓN INFERIOR ----
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 30),
        height: 70,
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(35),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _barraNavIconos(Icons.person, 0),       // Perfil
            _barraNavIconos(Icons.emoji_events, 1), // Quiz
            _barraNavIconos(Icons.public, 2),       // Mapa
            _barraNavIconos(Icons.menu, 3),         // Menú
          ],
        ),
      ),
    );
  }

  // Widget para animar los iconos de la barra de navegación
  Widget _barraNavIconos(IconData icon, int index) {
    final bool isSelected = _selectedIndex == index;
    final bool isProminent = (index == 1 || index == 2);
    
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Icon(
        icon, 
        size: isProminent ? 34 : 26, 
        color: isSelected && index != 3 ? const Color(0xFF2196F3) : (isProminent ? Colors.white : Colors.grey)
      ),
    );
  }
}

// ---- PANTALLA MAPA ----
class _MapContent extends StatelessWidget {
  const _MapContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D2644),
      appBar: AppBar(
        title: const Text("Explorar Países (JSON)", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: FutureBuilder(
        // Pedimos el archivo JSON que está guardado en assets
        future: DefaultAssetBundle.of(context).loadString('assets/paises.json'),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          // Desciframos el JSON. Convertimos el texto en una lista)
          var countries = json.decode(snapshot.data.toString());

          // Aquí creamos el diseño de la lista
          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: countries.length,
            itemBuilder: (context, index) {
              var country = countries[index];
              return Card(
                color: const Color(0xFF1E1E1E),
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: Text(country['emoji'], style: const TextStyle(fontSize: 30)),
                  title: Text(
                    country['nombre'], 
                    style: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.bold)
                  ),
                  subtitle: Text(
                    "Capital: ${country['capital']}", 
                    style: const TextStyle(color: Colors.grey)
                  ),
                  trailing: const Icon(Icons.info_outline, color: Color(0xFF2196F3)),
                  onTap: () {
                    // Al pulsar sobre el país mostramos el dato curioso
                    showDialog(
                      context: context, 
                      builder: (_) => AlertDialog(
                        backgroundColor: const Color(0xFF1E1E1E),
                        title: Text(country['nombre'], style: const TextStyle(color: Colors.white)),
                        content: Text(country['dato'], style: const TextStyle(color: Colors.white)),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context), 
                            child: const Text("Cerrar")
                          )
                        ],
                      )
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}