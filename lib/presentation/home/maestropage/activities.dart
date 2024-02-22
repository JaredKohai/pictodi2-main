import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Obtener los datos del maestro desde Firebase
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('profesores')
        .doc(user.uid)
        .get();
    if (userDoc.exists) {
      String nombre = userDoc['nombre'];
      String instituto = userDoc['instituto'];
      List<dynamic> asignaturasDynamic = userDoc['asignaturas'];
      List<String> asignaturas = asignaturasDynamic.cast<String>();
      String grado = userDoc['grado'];
      String grupo = userDoc['grupo'];

      // Ejecutar la aplicación con los datos del maestro
      runApp(ActivityPage(
        nombre: nombre,
        instituto: instituto,
        asignaturas: asignaturas,
        grado: grado,
        grupo: grupo,
      ));
      return;
    }
  }

  // Si no se pueden obtener los datos del maestro, mostrar un mensaje de error
  runApp(MaterialApp(
    home: Scaffold(
      body: Center(
        child: Text(
            'Error: No se pudieron obtener los datos del maestro desde Firebase.'),
      ),
    ),
  ));
}

class ActivityPage extends StatelessWidget {
  final String nombre;
  final String instituto;
  final List<String> asignaturas;
  final String grado;
  final String grupo;

  const ActivityPage({
    Key? key,
    required this.nombre,
    required this.instituto,
    required this.asignaturas,
    required this.grado,
    required this.grupo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void refresh() {
      // Implement your refresh logic here (e.g., call an API to fetch new data)
      print('Refreshing data...');
    }

    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage('assets/teachers.png'),
                ),
                SizedBox(width: 10.0),
                Text('Actividades'),
              ],
            ),
            actions: [
              PopupMenuButton(
                onSelected: (value) {
                  if (value == 'refresh') {
                    refresh();
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'refresh',
                    child: Text('Actualizar'),
                  ),
                ],
              ),
            ],
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Pendientes'),
                Tab(text: 'Completados'),
                Tab(text: 'Vencidos'),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              TaskList(status: TaskStatus.pending),
              TaskList(status: TaskStatus.completed),
              TaskList(status: TaskStatus.overdue),
            ],
          ),
        ),
      ),
    );
  }
}

enum TaskStatus { completed, pending, overdue }

class TaskList extends StatelessWidget {
  final TaskStatus status;

  const TaskList({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Task> tasks = getTasks(status);

    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TaskDetailsScreen(task: tasks[index])),
            );
          },
          child: TaskCard(task: tasks[index], status: status),
        );
      },
    );
  }

  List<Task> getTasks(TaskStatus status) {
    switch (status) {
      case TaskStatus.completed:
        return [
          Task(title: 'Tarea completada 1', dueDate: 'Hoy a las 3:00 PM'),
          Task(title: 'Tarea completada 2', dueDate: 'Ayer'),
        ];
      case TaskStatus.pending:
        return [
          Task(title: 'Tarea pendiente 1', dueDate: 'Mañana a las 9:00 AM'),
          Task(title: 'Tarea pendiente 2', dueDate: 'Próxima semana'),
        ];
      case TaskStatus.overdue:
        return [
          Task(title: 'Tarea vencida 1', dueDate: 'Ayer'),
          Task(title: 'Tarea vencida 2', dueDate: 'Hoy a las 10:00 AM'),
        ];
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

  const Task({required this.title, required this.dueDate});
}

class TaskDetailsScreen extends StatelessWidget {
  final Task task;

  const TaskDetailsScreen({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles de la tarea'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Título: ${task.title}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text('Fecha de vencimiento: ${task.dueDate}',
                style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
