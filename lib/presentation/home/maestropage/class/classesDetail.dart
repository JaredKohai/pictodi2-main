// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'form.dart'
    // ignore: library_prefixes
    as FormPage; // Agregar un prefijo para evitar conflictos de nombres
import 'classes.dart'
    // ignore: library_prefixes
    as ClassModels; // Agregar un prefijo para evitar conflictos de nombres

class Activity {
  final String name;

  Activity(this.name);
}

class ClassDetailPage extends StatelessWidget {
  final String nombre;
  final String instituto;
  final List<String> asignaturas;
  final String grado;
  final String grupo;
  final ClassModels.ClassData
      classData; // Utilizar el prefijo para evitar conflictos de nombres

  const ClassDetailPage({
    super.key,
    required this.classData,
    required this.nombre,
    required this.instituto,
    required this.asignaturas,
    required this.grado,
    required this.grupo,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
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
                      builder: (context) => FormPage.CustomForm(
                        nombre: nombre, // Pasar 'nombre' al CustomForm
                        instituto: instituto, // Pasar 'instituto' al CustomForm
                        asignaturas:
                            asignaturas, // Pasar 'asignaturas' al CustomForm
                        grado: grado, // Pasar 'grado' al CustomForm
                        grupo: grupo, // Pasar 'grupo' al CustomForm
                        nombreMateria: classData
                            .className, // Pasar el nombre de la materia
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.add),
              ),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Actividades'),
              Tab(text: 'Alumnos'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Contenido de la pestaña 'Actividades'
            FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('actividades')
                  .where('grado', isEqualTo: grado)
                  .where('grupo', isEqualTo: grupo)
                  .where('materia',
                      isEqualTo: classData.className) // Filtrar por materia
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final actividades = snapshot.data!.docs;

                return Expanded(
                  child: ListView.builder(
                    itemCount: actividades.length,
                    itemBuilder: (context, index) {
                      final actividad =
                          actividades[index].data() as Map<String, dynamic>;

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Actividad: ${actividad['titulo']}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    'Instrucciones: ${actividad['instrucciones']}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    'Fecha de vencimiento: ${actividad['fecha']}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),

            FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('niños')
                  .where('instituto', isEqualTo: instituto)
                  .where('grado', isEqualTo: grado)
                  .where('grupo', isEqualTo: grupo)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Problemilla: ${snapshot.error}'));
                }

                final alumnos = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: alumnos.length,
                  itemBuilder: (context, index) {
                    final alumno = alumnos[index];
                    final nombre = alumno['nombre'];

                    return ListTile(
                      title: Text(nombre),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ClassDetailPage(
      classData: ClassModels.ClassData(
          'Nombre de la clase', Colors.blue, 'assets/math-class.png', []),
      nombre: 'Nombre del profesor',
      instituto: 'Nombre del instituto',
      asignaturas: const ['Asignatura 1', 'Asignatura 2'],
      grado: 'Grado',
      grupo: 'Grupo',
    ),
  ));
}
