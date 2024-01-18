// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pictodi2/presentation/authentication/login.dart';
import 'package:pictodi2/presentation/home/editarusuariospage.dart';
import '../añadir/ananir_maestro.dart';
import '../añadir/ananir_psicologo.dart';
import '../añadir/ananir_nino.dart';
import '../añadir/ananir_padre.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DirectorPage extends StatelessWidget {
  final String nombre;
  final String instituto;

  const DirectorPage({Key? key, required this.nombre, required this.instituto})
      : super(key: key);

  Future<void> signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  Future<void> _showAccountMenu(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: const Text('Cerrar Sesión'),
                onTap: () async {
                  await _signOut(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido, $nombre'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: const Color.fromARGB(255, 255, 255, 255),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '¡Bienvenido al Menú de Gestión del Director!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'Aquí encontrarás todas las opciones para gestionar tu instituto: $instituto',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              // Puedes añadir más widgets según sea necesario
            ],
          ),
        ),
      ),
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.reactCircle,
        items: const [
          TabItem(icon: Icons.home, title: 'Inicio'),
          TabItem(icon: Icons.add_reaction_rounded, title: 'Añadir'),
          TabItem(icon: Icons.auto_fix_normal_sharp, title: 'Editar'),
          TabItem(icon: Icons.exit_to_app, title: 'Salir'),
        ],
        onTap: (index) {
          if (index == 1) {
            _showAddOptions(context);
          } else if (index == 2) {
            _showEditOptions(context);
          } else if (index == 3) {
            _showAccountMenu(context);
          }
        },
      ),
    );
  }

  Future<void> _showAddOptions(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Wrap(
            children: <Widget>[
              _buildAddCategoryTile(context, 'profesores'),
              _buildAddCategoryTile(context, 'niños'),
              _buildAddCategoryTile(context, 'padres'),
              _buildAddCategoryTile(context, 'psicologos'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAddCategoryTile(BuildContext context, String category) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        _navigateToAddCategory(context, category);
      },
      child: Container(
        width: 100,
        height: 100,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _getCategoryIcon(category),
            SizedBox(height: 10),
            Text('Añadir $category', textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  void _navigateToAddCategory(BuildContext context, String category) {
    if (category == 'profesores') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AnadirMaestroPage(
            instituto: instituto,
          ),
        ),
      );
    } else if (category == 'niños') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AnadirNinoPage(instituto: instituto),
        ),
      );
    } else if (category == 'padres') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AnadirPadrePage(instituto: instituto),
        ),
      );
    } else if (category == 'psicologos') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AnadirPsicologoPage(instituto: instituto),
        ),
      );
    }
  }

  Icon _getCategoryIcon(String category) {
    switch (category) {
      case 'profesores':
        return const Icon(Icons.school, size: 40, color: Colors.white);
      case 'directores':
        return const Icon(Icons.people, size: 40, color: Colors.white);
      case 'niños':
        return const Icon(Icons.person, size: 40, color: Colors.white);
      case 'padres':
        return const Icon(Icons.people, size: 40, color: Colors.white);
      case 'psicologos':
        return const Icon(Icons.psychology, size: 40, color: Colors.white);
      default:
        return const Icon(Icons.category, size: 40, color: Colors.white);
    }
  }

  Future<void> _showEditOptions(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Wrap(
            children: <Widget>[
              _buildEditCategoryTile(context, 'profesores'),
              _buildEditCategoryTile(context, 'niños'),
              _buildEditCategoryTile(context, 'padres'),
              _buildEditCategoryTile(context, 'psicologos'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEditCategoryTile(BuildContext context, String category) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        _navigateToEditCategory(context, category);
      },
      child: ListTile(
        title: Text('Editar $category'),
        leading: _getCategoryIcon(category),
      ),
    );
  }

  void _navigateToEditCategory(BuildContext context, String category) {
    // Navega a la página ListaRegistrosPage con la categoría seleccionada
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListaRegistrosPage(category: category),
      ),
    );
  }
}

class ListaRegistrosPage extends StatelessWidget {
  final String category;

  ListaRegistrosPage({required this.category});

  Future<void> _eliminarRegistro(BuildContext context, String docId) async {
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
        // Obtener el documento correspondiente
        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
            .collection(category)
            .doc(docId)
            .get();

        // Verificar si el documento existe
        if (documentSnapshot.exists) {
          // Obtener el id del usuario del documento
          String userIdFirestore = documentSnapshot.get('id').toString();

          // Eliminar el registro de Firestore
          await FirebaseFirestore.instance
              .collection(category)
              .doc(docId)
              .delete();

          // Buscar el usuario en Firebase Authentication con el mismo UID
          List<User?> users = await FirebaseAuth.instance
              .userChanges()
              .where((user) => user?.uid == userIdFirestore)
              .toList();

          if (users.isNotEmpty) {
            User? userToDelete = users.first;

            await userToDelete?.delete();
            print('Usuario en Authentication eliminado con éxito');

            // Mostrar Snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Registro eliminado exitosamente'),
              ),
            );

            // Volver a la página anterior
            Navigator.pop(context);
          } else {
            print('No se encontró el usuario en Authentication');
          }
        }
      }
    } catch (e) {
      print('Error al eliminar el registro: $e');
    }
  }

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
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (context) => EditarUsuarioPage(
                                    category: category,
                                    docId: docId,
                                  ),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              print('Botón de eliminar presionado');
                              await _eliminarRegistro(context, docId);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Agregar más detalles según sea necesario
                );
              },
            );
          }
        },
      ),
    );
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
    home: DirectorPage(
      nombre: '',
      instituto: " ",
    ),
  ));
}
