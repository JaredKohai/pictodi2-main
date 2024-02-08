import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Infop extends StatelessWidget {
  const Infop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar Categoría'),
      ),
      body: const CategoryList(),
    );
  }
}

class CategoryList extends StatelessWidget {
  const CategoryList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        CategoryTile(category: 'profesores'),
        CategoryTile(category: 'niños'),
        CategoryTile(category: 'padres'),
        CategoryTile(category: 'psicologos'),
      ],
    );
  }
}

class CategoryTile extends StatelessWidget {
  final String category;

  const CategoryTile({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Ver $category'),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ListaRegistrosPage(category: category),
          ),
        );
      },
    );
  }
}

class ListaRegistrosPage extends StatelessWidget {
  final String category;

  const ListaRegistrosPage({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de $category'),
      ),
      body: FutureBuilder(
        future: _getRegistros(category),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<DocumentSnapshot> registros =
                snapshot.data as List<DocumentSnapshot>;
            return ListView.builder(
              itemCount: registros.length,
              itemBuilder: (context, index) {
                String nombre = registros[index]['nombre'].toString();
                String docId = registros[index].id;

                return ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(nombre),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              // Implementar la edición
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              await _eliminarRegistro(context, category, docId);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

Future<void> _eliminarRegistro(BuildContext context, String category, String docId) async {
  try {
    bool confirmacion = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmación'),
          content: Text('¿Seguro que quieres eliminar este registro?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Sí'),
            ),
          ],
        );
      },
    );

    if (confirmacion == true) {
      await FirebaseFirestore.instance.collection(category).doc(docId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registro eliminado exitosamente'),
        ),
      );
    }
  } catch (e) {
    print('Error al eliminar el registro: $e');
  }
}

Future<List<DocumentSnapshot>> _getRegistros(String category) async {
  try {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection(category).get();
    return querySnapshot.docs;
  } catch (e) {
    throw Exception('Error al obtener registros: $e');
  }
}

void main() {
  runApp(const MaterialApp(
    home: Infop(),
  ));
}
