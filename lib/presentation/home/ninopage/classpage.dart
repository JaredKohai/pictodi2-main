import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'act_memorama.dart';

class ClasesPage extends StatelessWidget {
  final String nombre;
  final String instituto;
  final String diagnostico;
  final String grado;
  final String grupo;
  final String gravedad;

  const ClasesPage({
    Key? key,
    required this.nombre,
    required this.instituto,
    required this.diagnostico,
    required this.grado,
    required this.grupo,
    required this.gravedad,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mis Clases',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Mis Clases'),
          centerTitle: true,
        ),
        body: ClassList(
          nombre: nombre,
          instituto: instituto,
          diagnostico: diagnostico,
          grado: grado,
          grupo: grupo,
          gravedad: gravedad,
        ),
      ),
    );
  }
}

class ClassList extends StatelessWidget {
  final String nombre;
  final String instituto;
  final String diagnostico;
  final String grado;
  final String grupo;
  final String gravedad;

  const ClassList({
    Key? key,
    required this.nombre,
    required this.instituto,
    required this.diagnostico,
    required this.grado,
    required this.grupo,
    required this.gravedad,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Class> classes = getClasses();

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: SearchBar(),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: (classes.length / 2).ceil(),
            itemBuilder: (context, index) {
              int firstIndex = index * 2;
              int secondIndex = firstIndex + 1;
              return Row(
                children: [
                  Expanded(
                    child: ClassCard(
                      classInfo: classes[firstIndex],
                      onTap: () {
                        // Navegar a la página de detalles de la clase
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ClassDetailPage(
                              className: classes[firstIndex].name,
                              instituto: instituto,
                              grado: grado,
                              grupo: grupo,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 8.0), // Espacio entre las tarjetas
                  if (secondIndex < classes.length)
                    Expanded(
                      child: ClassCard(
                        classInfo: classes[secondIndex],
                        onTap: () {
                          // Navegar a la página de detalles de la clase
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ClassDetailPage(
                                className: classes[secondIndex].name,
                                instituto: instituto,
                                grado: grado,
                                grupo: grupo,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  List<Class> getClasses() {
    return [
      Class(
        name: 'Matemáticas',
        teacher: '',
        image: 'assets/math_icon.png',
        color: Colors.orange,
      ),
      Class(
        name: 'Sociocultura',
        teacher: '',
        image: 'assets/socio_class.png',
        color: Colors.blue,
      ),
      Class(
        name: 'Ciencias',
        teacher: '',
        image: 'assets/science_icon.png',
        color: Colors.green,
      ),
      Class(
        name: 'Español',
        teacher: '',
        image: 'assets/spanish-class.png',
        color: Colors.red,
      ),
    ];
  }

  List<String> getSubjectList() {
    return ['Matemáticas', 'Sociocultura', 'Ciencias', 'Español'];
  }
}

class ClassCard extends StatelessWidget {
  final Class classInfo;
  final VoidCallback? onTap;

  const ClassCard({
    Key? key,
    required this.classInfo,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: classInfo.color, // Color fijo para las tarjetas de clase
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30.0,
                backgroundImage: AssetImage(
                    classInfo.image), // Imagen fija para las tarjetas de clase
              ),
              const SizedBox(height: 8),
              Text(
                classInfo.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Profesor: Pendiente',
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Class {
  final String name;
  final String teacher;
  final String image;
  final Color color;

  Class({
    required this.name,
    required this.teacher,
    required this.image,
    required this.color,
  });
}

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Buscar clases...',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          prefixIcon: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ),
      ),
    );
  }
}

class ClassDetailPage extends StatelessWidget {
  final String className;
  final String instituto;
  final String grado;
  final String grupo;

  const ClassDetailPage({
    Key? key,
    required this.className,
    required this.instituto,
    required this.grado,
    required this.grupo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Buscando actividades para la clase $className...');
    return Scaffold(
      appBar: AppBar(
        title: Text(className),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('actividades')
            .where('grado', isEqualTo: grado)
            .where('grupo', isEqualTo: grupo)
            .where('instituto', isEqualTo: instituto)
            .where('materia', isEqualTo: className) // Filtrar por asignatura
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          List<DocumentSnapshot> activities = snapshot.data!.docs;

          if (activities.isEmpty) {
            return Center(child: Text('No hay actividades disponibles.'));
          }

          return ListView.builder(
            itemCount: activities.length,
            itemBuilder: (context, index) {
              var activityData =
                  activities[index].data() as Map<String, dynamic>;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    _showConfirmationDialog(context, activityData);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: Colors
                          .blue, // Color fijo para las tarjetas de actividad
                    ),
                    child: ListTile(
                      title: Text(activityData['titulo'],
                          style: TextStyle(color: Colors.white)),
                      subtitle: Text(activityData['instrucciones'],
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

  void _showConfirmationDialog(
      BuildContext context, Map<String, dynamic> activityData) {
    List<String> imagenesSeleccionadas =
        List<String>.from(activityData['imagenes_seleccionadas']);
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ActMemoramaPage(
                      imagenesSeleccionadas: imagenesSeleccionadas),
                ),
              );
            },
            child: Text('Empezar'),
          ),
        ],
      ),
    );
  }
}
