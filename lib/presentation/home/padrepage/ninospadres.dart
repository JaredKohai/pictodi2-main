import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      // Obtener la referencia al documento del padre que tiene el mismo nombre
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('padres')
              .where('nombre', isEqualTo: widget.nombre)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Obtener los datos del padre
        Map<String, dynamic> padreData =
            querySnapshot.docs.first.data() as Map<String, dynamic>;

        // Obtener la lista de hijos del padre
        List<dynamic> hijos = padreData['hijos'] ?? [];

        // Iterar sobre cada hijo para obtener su información
        for (var hijoNombre in hijos) {
          // Obtener la referencia al documento del hijo
          QuerySnapshot<Map<String, dynamic>> hijoSnapshot =
              await FirebaseFirestore.instance
                  .collection('niños')
                  .where('nombre', isEqualTo: hijoNombre)
                  .get();

          if (hijoSnapshot.docs.isNotEmpty) {
            // Obtener los datos del hijo
            Map<String, dynamic> hijoData =
                hijoSnapshot.docs.first.data() as Map<String, dynamic>;

            // Agregar la información del hijo a la lista
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
              // Mostrar la información de los hijos en tarjetas
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
                            'Información del hijo ${index + 1}:',
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
