import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pictodi2/presentation/authentication/login.dart';
import 'generador.dart';
import 'generadoia.dart';
import 'package:firebase_storage/firebase_storage.dart'
    as firebase_storage; // Importa el paquete de Firebase Storage

class NinoPage extends StatelessWidget {
  final String nombre;

  const NinoPage({Key? key, required this.nombre}) : super(key: key);

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
                  MaterialPageRoute(builder: (context) => GeneradorPage()),
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

  Future<void> _showActivity(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ir al Generador'),
          content: Text('¿Quieres ir al generador de pictogramas con IA?'),
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
                // Navegar a la página GeneradorIA
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GeneradorIA()),
                );
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido, ${user?.displayName ?? ''}'),
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
          IconButton(
            icon: Icon(Icons.assignment_late_outlined),
            onPressed: () => _showActivity(context),
          )
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
