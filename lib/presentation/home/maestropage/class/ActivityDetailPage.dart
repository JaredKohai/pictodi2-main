import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityDetailPage extends StatelessWidget {
  final Map<String, dynamic> actividad;

  const ActivityDetailPage({Key? key, required this.actividad})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<dynamic> alumnos = actividad['alumnos'];
    final DateTime fechaVencimiento =
        (actividad['fecha_vencimiento'] as Timestamp).toDate();
    final formattedFechaVencimiento = fechaVencimiento.toString();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detalles de la Actividad',
          style: TextStyle(
            fontFamily: 'Chewy',
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Actividad: ${actividad['titulo']}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Instrucciones:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            SizedBox(height: 10),
            Text(
              actividad['instrucciones'],
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Comic Sans MS',
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Fecha de vencimiento:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 10),
            Text(
              formattedFechaVencimiento,
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Comic Sans MS',
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Alumnos que completaron la actividad:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: alumnos.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(
                      Icons.child_care,
                      color: Colors.pink,
                      size: 36,
                    ),
                    title: Text(
                      alumnos[index],
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Chewy',
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
