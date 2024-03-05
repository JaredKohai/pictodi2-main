import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
            return now.compareTo(dueDate) > 0 &&
                !(activity['alumnos'] as List).contains(nombre);
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
            return TaskCard(
              task: Task(
                title: activity['titulo'],
                dueDate: status == TaskStatus.overdue
                    ? _calculateOverdue(activity['fecha_vencimiento'])
                    : activity['fecha_vencimiento'].toDate().toString(),
              ),
              status: status,
            );
          },
        );
      },
    );
  }

  String _calculateOverdue(Timestamp dueDate) {
    final now = Timestamp.now();
    final difference = now.seconds - dueDate.seconds;
    final days = (difference / (60 * 60 * 24)).floor();
    return 'Hace $days días';
  }
}

enum TaskStatus { completed, pending, overdue }

class TaskCard extends StatelessWidget {
  final Task task;
  final TaskStatus status;

  const TaskCard({Key? key, required this.task, required this.status})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData iconData = Icons.check_circle;
    Color iconColor = Colors.green;

    if (status == TaskStatus.pending) {
      iconData = Icons.access_time;
      iconColor = Colors.orange;
    } else if (status == TaskStatus.overdue) {
      iconData = Icons.error;
      iconColor = Colors.red;
    }

    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 3.0,
      child: ListTile(
        title: Text(task.title,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(task.dueDate),
        trailing: Icon(iconData, color: iconColor),
      ),
    );
  }
}

class Task {
  final String title;
  final String dueDate;

  Task({required this.title, required this.dueDate});
}
