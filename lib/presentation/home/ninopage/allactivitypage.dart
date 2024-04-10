import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AllActivitiesPage extends StatelessWidget {
  final String nombre;
  final String instituto;
  final String grado;
  final String grupo;

  const AllActivitiesPage({
    Key? key,
    required this.nombre,
    required this.instituto,
    required this.grado,
    required this.grupo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todas las Actividades'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('actividades')
            .where('grado', isEqualTo: grado)
            .where('grupo', isEqualTo: grupo)
            .where('instituto', isEqualTo: instituto)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final List<DocumentSnapshot> activities = snapshot.data!.docs;

          if (activities.isEmpty) {
            return Center(child: Text('No hay actividades disponibles.'));
          }

          return ListView.builder(
            itemCount: activities.length,
            itemBuilder: (context, index) {
              final activity = activities[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    // Aquí puedes agregar la lógica para ver detalles de la actividad si lo deseas
                    // Por ejemplo, puedes abrir un AlertDialog con más detalles
                    _showActivityDetails(context, activity);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: Colors.blue,
                    ),
                    child: ListTile(
                      title: Text(activity['titulo'],
                          style: TextStyle(color: Colors.white)),
                      subtitle: Text(activity['instrucciones'],
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showActivityDetails(BuildContext context, DocumentSnapshot activity) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Detalles de la Actividad'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Título: ${activity['titulo']}'),
            Text('Instrucciones: ${activity['instrucciones']}'),
            // Puedes agregar más detalles aquí según tu estructura de datos
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}
