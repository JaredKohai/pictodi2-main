import 'package:flutter/material.dart';

void main() {
  runApp(const ClasesPage());
}

class ClasesPage extends StatelessWidget {
  const ClasesPage({super.key});

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
        body: const ClassList(),
      ),
    );
  }
}

class ClassList extends StatelessWidget {
  const ClassList({super.key});

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
                  Expanded(child: ClassCard(classInfo: classes[firstIndex])),
                  const SizedBox(width: 8.0), // Espacio entre las tarjetas
                  if (secondIndex < classes.length)
                    Expanded(child: ClassCard(classInfo: classes[secondIndex])),
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
          teacher: 'Profesor Ejemplo 1',
          image: 'assets/math_icon.png',
          color: Colors.orange),
      Class(
          name: 'Historia',
          teacher: 'Profesor Ejemplo 2',
          image: 'assets/history_icon.jpg',
          color: Colors.blue),
      Class(
          name: 'Ciencias',
          teacher: 'Profesor Ejemplo 3',
          image: 'assets/science_icon.png',
          color: Colors.green),
      // Puedes agregar más clases según sea necesario
    ];
  }
}

class ClassCard extends StatelessWidget {
  final Class classInfo;

  const ClassCard({super.key, required this.classInfo});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        onTap: () {
          // Lógica para navegar a los detalles de la clase
          // Puedes implementar esto según tus necesidades
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: classInfo.color,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30.0,
                backgroundImage: AssetImage(classInfo.image),
              ),
              const SizedBox(height: 8),
              Text(classInfo.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 8),
              Text('Profesor: ${classInfo.teacher}',
                  style: const TextStyle(color: Colors.white)),
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

  Class(
      {required this.name,
      required this.teacher,
      required this.image,
      required this.color});
}

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

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
              icon: const Icon(Icons.search)),
        ),
      ),
    );
  }
}
