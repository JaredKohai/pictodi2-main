import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pictodi2/presentation/authentication/login.dart';

class PerfilPage extends StatelessWidget {
  final String nombre;
  final String instituto;
  final String diagnostico;
  final String fecha_nacimiento;
  final String grado;
  final String grupo;
  final String gravedad;
  const PerfilPage({
    Key? key,
    required this.nombre,
    required this.instituto,
    required this.diagnostico,
    required this.fecha_nacimiento,
    required this.grado,
    required this.grupo,
    required this.gravedad,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Perfil',
          style: GoogleFonts.openSans(),
        ),
        elevation: 0, // Ajusta la elevación a 0 para eliminar la sombra
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Foto
              Stack(
                children: [
                  Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
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
                      // Correo electrónico
                      // Teléfono
                      ListTile(
                        title: Text('Fecha de nacimiento',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(fecha_nacimiento),
                      ),
                      ListTile(
                        title: Text('Grado',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(grado),
                      ),
                      ListTile(
                        title: Text('Grupo',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(grupo),
                      ),
                      ListTile(
                        title: Text('Diagnóstico',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(diagnostico),
                      ),
                      ListTile(
                        title: Text('Gravedad',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(gravedad),
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
                  'Log Out',
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