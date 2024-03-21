import 'package:flutter/material.dart';
import 'Childrens.dart'; // Importa la nueva página de detalles

class PadresHome extends StatelessWidget {
  final Map<String, dynamic> currentUserData; // Datos del usuario actual

  const PadresHome({Key? key, required this.currentUserData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Obtener los valores de institute, grade y group asegurándose de que no sean nulos
    final String institute = currentUserData['instituto'] ?? '';
    final String grade = currentUserData['grado'] ?? '';
    final String group = currentUserData['grupo'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(20.0),
        crossAxisSpacing: 20.0,
        mainAxisSpacing: 20.0,
        children: [
          _buildGridItem('Hijos', Colors.blue, () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChildrensPage(
                  childrenNames: currentUserData['hijos'],
                  institute: institute,
                  grade: grade,
                  group: group,
                ),
              ),
            );
          }),
          // Agregar más elementos de la cuadrícula según sea necesario
        ],
      ),
    );
  }

  Widget _buildGridItem(String text, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: color,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
