import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'form.dart' as FormPage;
import 'classes.dart' as ClassModels;

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
  final ClassModels.ClassData classData;

  const ClassDetailPage({
    Key? key,
    required this.classData,
    required this.nombre,
    required this.instituto,
    required this.asignaturas,
    required this.grado,
    required this.grupo,
  }) : super(key: key);

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
                        nombre: nombre,
                        instituto: instituto,
                        asignaturas: asignaturas,
                        grado: grado,
                        grupo: grupo,
                        nombreMateria: classData.className,
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
            FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('actividades')
                  .where('grado', isEqualTo: grado)
                  .where('grupo', isEqualTo: grupo)
                  .where('materia', isEqualTo: classData.className)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final actividades = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: actividades.length,
                  itemBuilder: (context, index) {
                    final actividad =
                        actividades[index].data() as Map<String, dynamic>;

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ActivityDetailPage(
                                actividad: actividad,
                              ),
                            ),
                          );
                        },
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
                                    'Fecha de vencimiento: ${calculateTimeDifference(actividad['fecha_vencimiento'].toDate())}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
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

  String calculateTimeDifference(DateTime dateTime) {
    final now = DateTime.now();
    final difference = dateTime.difference(now);

    if (difference.isNegative) {
      return 'Vencido hace ${-difference.inDays}d ${-difference.inHours.remainder(24)}h ${-difference.inMinutes.remainder(60)}m';
    } else {
      final days = difference.inDays;
      final hours = difference.inHours.remainder(24);
      final minutes = difference.inMinutes.remainder(60);

      return '${days}d ${hours}h ${minutes}m';
    }
  }
}

class ActivityDetailPage extends StatelessWidget {
  final Map<String, dynamic> actividad;

  const ActivityDetailPage({Key? key, required this.actividad})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<dynamic> alumnos = actividad['alumnos'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de la Actividad'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Actividad: ${actividad['titulo']}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Instrucciones: ${actividad['instrucciones']}'),
            SizedBox(height: 10),
            Text(
                'Fecha de vencimiento: ${calculateTimeDifference(actividad['fecha_vencimiento'].toDate())}'),
            SizedBox(height: 10),
            Text(
              'Alumnos que la finalizaron:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: alumnos.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(alumnos[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String calculateTimeDifference(DateTime dateTime) {
    final now = DateTime.now();
    final difference = dateTime.difference(now);

    if (difference.isNegative) {
      return 'Vencido hace ${-difference.inDays}d ${-difference.inHours.remainder(24)}h ${-difference.inMinutes.remainder(60)}m';
    } else {
      final days = difference.inDays;
      final hours = difference.inHours.remainder(24);
      final minutes = difference.inMinutes.remainder(60);

      return '${days}d ${hours}h ${minutes}m';
    }
  }
}
