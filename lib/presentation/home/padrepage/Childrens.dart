import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChildrensPage extends StatelessWidget {
  final List<dynamic> childrenNames;
  final String institute;
  final String grade;
  final String group;

  const ChildrensPage({
    Key? key,
    required this.childrenNames,
    required this.institute,
    required this.grade,
    required this.group,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tareas de los Niños'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _getTasksData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No se encontraron tareas para estos niños.'),
            );
          }

          List<Map<String, dynamic>> pendingTasks = [];
          List<Map<String, dynamic>> completedTasks = [];

          snapshot.data!.forEach((taskData) {
            if (taskData['alumnos'] != null &&
                taskData['alumnos'].contains(childrenNames)) {
              completedTasks.add(taskData);
            } else {
              pendingTasks.add(taskData);
            }
          });

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (pendingTasks.isNotEmpty)
                  _buildTasksSection('Tareas Pendientes', pendingTasks),
                if (completedTasks.isNotEmpty)
                  _buildTasksSection('Tareas Completadas', completedTasks),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTasksSection(String title, List<Map<String, dynamic>> tasks) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> taskData = tasks[index];
            return ListTile(
              title: Text(taskData['nombre'] ?? 'Sin nombre'),
              subtitle: Text(taskData['descripcion'] ?? 'Sin descripción'),
            );
          },
        ),
        Divider(),
      ],
    );
  }

  Future<List<Map<String, dynamic>>> _getTasksData() async {
    List<Map<String, dynamic>> tasksData = [];

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('actividades')
        .where('instituto', isEqualTo: institute)
        .where('grado', isEqualTo: grade)
        .where('grupo', isEqualTo: group)
        .get();

    querySnapshot.docs.forEach((taskDoc) {
      tasksData.add(taskDoc.data() as Map<String, dynamic>);
    });

    return tasksData;
  }
}
