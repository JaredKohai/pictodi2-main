// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../authentication/login.dart';

class PadrePage extends StatelessWidget {
  final String nombre; // Agrega esta línea

  const PadrePage({Key? key, required this.nombre}) : super(key: key);

 Future<void> _showGeneradorConfirmation(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ir al Generador'),
          content: Text('¿Quieres ir al generador de pictogramas?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
                // Navegar a la página GeneradorPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showLogoutConfirmation(BuildContext context) async {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Wrap(
            children: <Widget>[
              ListTile(
                title: const Text('¿Quieres cerrar sesión?'),
                onTap: () async {
                  // Cerrar sesión y navegar a la pantalla de inicio de sesión
                  await FirebaseAuth.instance.signOut();
                  Navigator.pop(context); // Cerrar el menú
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido, $nombre'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Mostrar confirmación antes de ir al generador
              _showGeneradorConfirmation(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.account_circle_outlined),
            onPressed: () {
              // Mostrar menú de confirmación para cerrar sesión
              _showLogoutConfirmation(context);
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Text(
            'Actividades Pendientes',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Container(
            width: 150,
            height: 150,
            color: Colors.grey[300],
          ),
          SizedBox(height: 20),
          const Text('Texto o descripción de las actividades pendientes'),
          SizedBox(height: 20),
          Expanded(
            child: Center(
              child: Text('Bienvenido!, $nombre'),
            ),
          ),
        ],
      ),
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.reactCircle,
        items: [
          TabItem(icon: Icons.home, title: 'Inicio'),
          TabItem(icon: Icons.search, title: 'Pictogramas'),
          TabItem(icon: Icons.assignment, title: 'Actividades'),
          TabItem(icon: Icons.account_circle_outlined, title: 'Cuenta'),
        ],
        onTap: (index) {
          // Maneja la acción cuando se toca un ítem
          // Puedes agregar lógica adicional aquí según el índice seleccionado
          if (index == 1) {
            // Mostrar confirmación antes de ir al generador
            _showGeneradorConfirmation(context);
          } else if (index == 3) {
            // Mostrar menú de confirmación para cerrar sesión
            _showLogoutConfirmation(context);
          }
        },
      ),
    );
  }
}