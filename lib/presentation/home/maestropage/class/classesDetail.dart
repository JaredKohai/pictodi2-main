import 'package:flutter/material.dart';
import 'classes.dart';
import 'form.dart';

class Activity {
  final String name;

  Activity(this.name);
}

class ClassDetailPage extends StatelessWidget {
  final ClassData classData;

  ClassDetailPage({required this.classData});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Número de pestañas
      child: Scaffold(
        appBar: AppBar(
          title: Text(classData.className),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CustomForm(),
                    ),
                  );
                },
                icon: Icon(Icons.add),
              ),
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: 'Actividades'),
              Tab(text: 'Alumnos'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Contenido de la pestaña 'Actividades'
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    '',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: classData.activities.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(classData.activities[index].name),
                      );
                    },
                  ),
                ),
              ],
            ),
            // Contenido de la pestaña 'Alumnos'
            Center(
              child: Text(
                'Contenido de la pestaña "Alumnos"',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
