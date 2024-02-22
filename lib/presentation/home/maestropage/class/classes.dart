import 'package:flutter/material.dart';
import 'classesDetail.dart';

class ClassesTabContent extends StatefulWidget {
  final String nombre;
  final String instituto;
  final List<String> asignaturas; // Convertir a List<String>
  final String grado;
  final String grupo;

  ClassesTabContent({
    required this.nombre,
    required this.instituto,
    required this.asignaturas,
    required this.grado,
    required this.grupo,
  });

  @override
  _ClassesTabContentState createState() => _ClassesTabContentState();
}

class _ClassesTabContentState extends State<ClassesTabContent> {
  late TextEditingController _searchController;

  final List<ClassData> classes = [
    ClassData('Matemáticas', Colors.blue, 'assets/math-class.png', []),
    ClassData('Historia', Colors.green, 'assets/math-class.png', []),
    ClassData('Ciencias', Colors.orange, 'assets/math-class.png', []),
    ClassData('Español', Colors.red, 'assets/math-class.png', []),
  ];

  List<ClassData> filteredClasses =
      []; // Lista filtrada para mostrar en la interfaz

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    filterClasses(); // Filtrar las clases al inicio
  }

  void filterClasses() {
    // Obtener las asignaturas registradas del profesor desde Firebase
    List<String> asignaturasRegistradas = [
      'Matemáticas',
      'Historia',
      'Ciencias',
      'Español'
    ]; // ¡Reemplaza esto con tus datos reales de Firebase!

    // Filtrar las clases para incluir solo las asignaturas registradas
    filteredClasses = classes.where((classData) {
      return asignaturasRegistradas.contains(classData.className);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: AssetImage('assets/teachers.png'),
            ),
            SizedBox(width: 10.0),
            Text('Clases'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              _showOptions(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Controles de búsqueda y lista de clases filtradas
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.grey),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          // Cuando cambia el texto de búsqueda, filtrar nuevamente las clases
                          filterClasses();
                          setState(() {}); // Actualizar la interfaz
                        },
                        decoration: const InputDecoration(
                          hintText: 'Buscar',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 1.0,
                ),
                itemCount: filteredClasses.length,
                itemBuilder: (context, index) {
                  double height = (index % 2 == 0) ? 100.0 : 150.0;
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ClassDetailPage(
                            classData: filteredClasses[index],
                          ),
                        ),
                      );
                    },
                    child: _buildClassContainer(filteredClasses[index], height),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Opción:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ListTile(
                title: const Text('Opcion 1'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Opcion 2'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildClassContainer(ClassData classData, double height) {
    Color textColor = _calculateTextColor(classData.color);

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: classData.color,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            classData.imagePath,
            width: 100,
            height: 100,
          ),
          const SizedBox(height: 10.0),
          Text(
            classData.className,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Color _calculateTextColor(Color backgroundColor) {
    double luminance = (0.299 * backgroundColor.red +
            0.587 * backgroundColor.green +
            0.114 * backgroundColor.blue) /
        255;
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}

class CustomSearchDelegate extends SearchDelegate {
  final List<ClassData> classes;

  CustomSearchDelegate(this.classes);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}

class ClassData {
  final String className;
  final Color color;
  final String imagePath;
  final List<Activity> activities;

  ClassData(this.className, this.color, this.imagePath, this.activities);
}
