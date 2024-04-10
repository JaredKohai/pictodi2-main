import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pictodi2/presentation/home/ninopage/act_memorama.dart';
import 'package:pictodi2/presentation/home/ninopage/act_unir.dart';

class NinosPadres extends StatefulWidget {
  final String nombre;

  const NinosPadres({Key? key, required this.nombre}) : super(key: key);

  @override
  _NinosPadresState createState() => _NinosPadresState();
}

class _NinosPadresState extends State<NinosPadres> {
  late List<Map<String, dynamic>> _listaHijos = [];

  @override
  void initState() {
    super.initState();
    obtenerDatosHijos();
  }

  Future<void> obtenerDatosHijos() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('padres')
              .where('nombre', isEqualTo: widget.nombre)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        Map<String, dynamic> padreData =
            querySnapshot.docs.first.data() as Map<String, dynamic>;
        List<dynamic> hijos = padreData['hijos'] ?? [];

        for (var hijoNombre in hijos) {
          QuerySnapshot<Map<String, dynamic>> hijoSnapshot =
              await FirebaseFirestore.instance
                  .collection('niños')
                  .where('nombre', isEqualTo: hijoNombre)
                  .get();

          if (hijoSnapshot.docs.isNotEmpty) {
            Map<String, dynamic> hijoData =
                hijoSnapshot.docs.first.data() as Map<String, dynamic>;

            setState(() {
              _listaHijos.add({
                'nombre': hijoData['nombre'],
                'instituto': hijoData['instituto'],
                'diagnostico': hijoData['diagnostico'],
                'fecha_nacimiento': hijoData['fecha_nacimiento'],
                'grado': hijoData['grado'],
                'grupo': hijoData['grupo'],
                'gravedad': hijoData['gravedad'],
              });
            });
          }
        }
      }
    } catch (e) {
      print('Error al obtener los datos de los hijos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Niños vinculados'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Información de los niños vinculados:',
                style: TextStyle(fontSize: 24.0),
              ),
              SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _listaHijos.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hijo ${index + 1}:',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Nombre: ${_listaHijos[index]['nombre']}',
                            style: TextStyle(fontSize: 16.0),
                          ),
                          Text(
                            'Instituto: ${_listaHijos[index]['instituto']}',
                            style: TextStyle(fontSize: 16.0),
                          ),
                          Text(
                            'Diagnóstico: ${_listaHijos[index]['diagnostico']}',
                            style: TextStyle(fontSize: 16.0),
                          ),
                          Text(
                            'Fecha de nacimiento: ${_listaHijos[index]['fecha_nacimiento']}',
                            style: TextStyle(fontSize: 16.0),
                          ),
                          Text(
                            'Grado: ${_listaHijos[index]['grado']}',
                            style: TextStyle(fontSize: 16.0),
                          ),
                          Text(
                            'Grupo: ${_listaHijos[index]['grupo']}',
                            style: TextStyle(fontSize: 16.0),
                          ),
                          Text(
                            'Gravedad: ${_listaHijos[index]['gravedad']}',
                            style: TextStyle(fontSize: 16.0),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ClassDetailPage(
                                    className:
                                        'Nombre de la clase', // Inserta el nombre de la clase aquí
                                    instituto: _listaHijos[index]['instituto'],
                                    grado: _listaHijos[index]['grado'],
                                    grupo: _listaHijos[index]['grupo'],
                                    nombre: _listaHijos[index]['nombre'],
                                  ),
                                ),
                              );
                            },
                            child: Text('Ver actividades'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ClassDetailPage extends StatelessWidget {
  final String className;
  final String nombre;
  final String instituto;
  final String grado;
  final String grupo;

  const ClassDetailPage({
    Key? key,
    required this.className,
    required this.instituto,
    required this.grado,
    required this.grupo,
    required this.nombre,
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

          List<DocumentSnapshot> allActivities = snapshot.data!.docs;

          // Filtrar actividades que no han sido completadas por el alumno
          List<DocumentSnapshot> activities = allActivities.where((activity) {
            List<dynamic> alumnos = activity['alumnos'];
            return !alumnos.contains(nombre);
          }).toList();

          if (activities.isEmpty) {
            return Center(child: Text('No hay actividades disponibles.'));
          }

          return ListView.builder(
            itemCount: activities.length,
            itemBuilder: (context, index) {
              var activityData = activities[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    _showConfirmationDialog(
                        context, activityData, activities[index].id);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: Colors.blue,
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
              _registrarActividadCompletada(activitySnapshot, actividadId);
              if (tipoActividad == 'Memorama') {
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
}
