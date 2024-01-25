import 'package:flutter/material.dart';
import '../ananir/ananir_director.dart'; // Asegúrate de tener la ruta correcta

class AdminPage extends StatelessWidget {
  final String nombre;

  const AdminPage({Key? key, required this.nombre}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome, $nombre!'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RegisterDirectorPage()),
                );
              },
              child: Text('Registrar Director'),
            ),
            // Add your admin-specific content here
          ],
        ),
      ),
    );
  }
}
