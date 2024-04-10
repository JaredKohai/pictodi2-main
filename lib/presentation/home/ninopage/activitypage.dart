import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pictodi2/presentation/home/ninopage/act_memorama.dart';
import 'package:pictodi2/presentation/home/ninopage/act_unir.dart';
import 'package:pictodi2/presentation/home/ninopage/allactivitypage.dart';

void main() {
  runApp(ActivityPage(
    nombre: 'Juan',
    instituto: 'Instituto XYZ',
    grado: '5',
    grupo: 'A',
  ));
}

class ActivityPage extends StatelessWidget {
  final String nombre;
  final String instituto;
  final String grado;
  final String grupo;

  const ActivityPage({
    Key? key,
    required this.nombre,
    required this.instituto,
    required this.grado,
    required this.grupo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tareas Teams',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Pendientes'),
                Tab(text: 'Completados'),
                Tab(text: 'Vencidos'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              TaskList(
                status: TaskStatus.pending,
                nombre: nombre,
                instituto: instituto,
                grado: grado,
                grupo: grupo,
              ),
              TaskList(
                status: TaskStatus.completed,
                nombre: nombre,
                instituto: instituto,
                grado: grado,
                grupo: grupo,
              ),
              TaskList(
                status: TaskStatus.overdue,
                nombre: nombre,
                instituto: instituto,
                grado: grado,
                grupo: grupo,
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AllActivitiesPage(
                    nombre: nombre,
                    instituto: instituto,
                    grado: grado,
                    grupo: grupo,
                  ),
                ),
              );
            },
            child: Icon(Icons.view_list),
          ),
        ),
      ),
    );
  }
}

class TaskList extends StatelessWidget {
  final TaskStatus status;
  final String nombre;
  final String instituto;
  final String grado;
  final String grupo;

  const TaskList({
    Key? key,
    required this.status,
    required this.nombre,
    required this.instituto,
    required this.grado,
    required this.grupo,
  }) : super(key: key);

  void _showConfirmationDialog(BuildContext context,
      DocumentSnapshot activitySnapshot, String actividadId) {
    List<String> imagenesSeleccionadas =
        List<String>.from(activitySnapshot['imagenes_seleccionadas']);
    String tipoActividad =
        activitySnapshot['tipo']; // Obtener el tipo de actividad
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('¿Quieres empezar la actividad?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _registrarActividadCompletada(activitySnapshot,
                  actividadId); // Llamada al método para registrar la actividad completada
              if (tipoActividad == 'Memorama') {
                // Verificar el tipo de actividad
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ActMemoramaPage(
                      imagenesSeleccionadas: imagenesSeleccionadas,
                      nombre: nombre,
                    ),
                  ),
                );
              } else if (tipoActividad == 'Unir') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UnirPage(
                      imagenesSeleccionadas: imagenesSeleccionadas,
                      nombre: nombre,
                    ),
                  ),
                );
              }
            },
            child: Text('Empezar'),
          ),
        ],
      ),
    );
  }

  void _registrarActividadCompletada(
      DocumentSnapshot activitySnapshot, String actividadId) async {
    try {
      await FirebaseFirestore.instance
          .collection('actividades_completadas')
          .doc(actividadId)
          .update({
        'alumnos': FieldValue.arrayUnion([nombre]),
      });

      print('Actividad completada registrada exitosamente para $nombre.');
    } catch (e) {
      print('Error al registrar la actividad completada: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
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

        List<DocumentSnapshot> filteredActivities;
        if (status == TaskStatus.pending) {
          // Filtrar actividades pendientes
          filteredActivities = activities.where((activity) {
            final Timestamp dueDate = activity['fecha_vencimiento'];
            final now = Timestamp.now();
            return !(activity['alumnos'] as List).contains(nombre) &&
                now.compareTo(dueDate) < 0;
          }).toList();
        } else if (status == TaskStatus.completed) {
          // Filtrar actividades completadas
          filteredActivities = activities
              .where(
                  (activity) => (activity['alumnos'] as List).contains(nombre))
              .toList();
        } else {
          // Filtrar actividades vencidas
          filteredActivities = activities.where((activity) {
            final Timestamp dueDate = activity['fecha_vencimiento'];
            final now = Timestamp.now();
            final difference = now.seconds - dueDate.seconds;
            return now.compareTo(dueDate) > 0 &&
                !(activity['alumnos'] as List).contains(nombre) &&
                difference > 0;
          }).toList();
        }

        if (filteredActivities.isEmpty) {
          return Center(
              child: Text(status == TaskStatus.pending
                  ? 'No hay tareas pendientes.'
                  : status == TaskStatus.completed
                      ? 'No hay tareas completadas.'
                      : 'No hay tareas vencidas.'));
        }

        return ListView.builder(
          itemCount: filteredActivities.length,
          itemBuilder: (context, index) {
            final activity = filteredActivities[index];
            final task = Task(
              title: activity['titulo'],
              dueDate: _calculateDueDate(activity['fecha_vencimiento']),
              isPending: status == TaskStatus.pending,
              isOverdue: status == TaskStatus.overdue,
            );
            return GestureDetector(
              onTap: () {
                if (status == TaskStatus.pending ||
                    status == TaskStatus.overdue) {
                  _showConfirmationDialog(
                      context, activity, filteredActivities[index].id);
                }
              },
              child: TaskCard(task: task, status: status),
            );
          },
        );
      },
    );
  }

  String _calculateDueDate(Timestamp dueDate) {
    final now = Timestamp.now();
    final difference = now.seconds - dueDate.seconds;
    final days = difference ~/ (60 * 60 * 24);
    final hours = (difference % (60 * 60 * 24)) ~/ (60 * 60);
    final minutes = ((difference % (60 * 60 * 24)) % (60 * 60)) ~/ 60;

    if (days > 0) {
      return 'Hace $days días';
    } else if (hours > 0) {
      return 'Hace $hours horas';
    } else {
      return 'Hace $minutes minutos';
    }
  }
}

class TaskCard extends StatelessWidget {
  final Task task;
  final TaskStatus status;

  const TaskCard({Key? key, required this.task, required this.status})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData iconData = Icons.check_circle;
    Color iconColor = Colors.green;
    String subTitle = '';

    if (status == TaskStatus.pending) {
      iconData = Icons.access_time;
      iconColor = Colors.orange;
      subTitle =
          task.isPending ? 'Faltan ${task.dueDate}' : 'Entregado con éxito';
    } else if (status == TaskStatus.overdue) {
      iconData = Icons.error;
      iconColor = Colors.red;
      subTitle = 'Vencido hace ${task.dueDate}';
    } else if (status == TaskStatus.completed) {
      iconData = Icons.check_circle;
      iconColor = Colors.green;
      subTitle = 'Completado hace ${task.dueDate}';
    }

    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 3.0,
      child: ListTile(
        leading: Icon(iconData, color: iconColor),
        title: Text(task.title,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subTitle),
      ),
    );
  }
}

class Task {
  final String title;
  final String dueDate;
  final bool isPending;
  final bool isOverdue;

  Task({
    required this.title,
    required this.dueDate,
    required this.isPending,
    required this.isOverdue,
  });
}

enum TaskStatus { completed, pending, overdue }
