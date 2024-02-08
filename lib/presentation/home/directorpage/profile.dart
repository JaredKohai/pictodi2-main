import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pictodi2/presentation/authentication/login.dart';

class PerfilPage extends StatelessWidget {
  final String nombre;
  final String instituto;
  const PerfilPage({Key? key, required this.nombre, required this.instituto})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0, // Ajusta la elevación a 0 para eliminar la sombra
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Perfil',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Stack(
                children: [
                  Container(
                    height: 200,
                    width: 200,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('assets/profile_image.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: GestureDetector(
                      child: const Icon(
                        Icons.camera_alt,
                        size: 30,
                      ),
                      onTap: () {},
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              // Contenedor tipo input para los datos
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: ListView(
                    children: [
                      ListTile(
                        title: Text('Nombre',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(nombre),
                      ),
                      ListTile(
                        title: Text('Institución',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(instituto),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () async {
                  try {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  } catch (e) {
                    print("Error al cerrar sesión: $e");
                  }
                },
                icon: const Icon(Icons.logout,
                    size: 24, color: Color.fromARGB(255, 255, 255, 255)),
                label: Text(
                  'Salir',
                  style: GoogleFonts.openSans().copyWith(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Color de fondo del botón
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
