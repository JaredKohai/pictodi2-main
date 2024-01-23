import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pictodi2/presentation/authentication/login.dart';
import '../home/generadoia.dart';
import '../home/generador.dart';
import 'package:firebase_storage/firebase_storage.dart'
    as firebase_storage; // Importa el paquete de Firebase Storage

class NinoPage extends StatelessWidget {
  final String nombre;

  const NinoPage({Key? key, required this.nombre}) : super(key: key);

  Future<void> _showGeneradorConfirmation(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ir al Generador'),
          content: Text('¿Quieres ir al generador de pictogramas?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
                // Navegar a la página GeneradorPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GeneradorPage()),
                );
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showLogoutConfirmation(BuildContext context) async {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Wrap(
            children: <Widget>[
              ListTile(
                title: const Text('¿Quieres cerrar sesión?'),
                onTap: () async {
                  // Cerrar sesión y navegar a la pantalla de inicio de sesión
                  await FirebaseAuth.instance.signOut();
                  Navigator.pop(context); // Cerrar el menú
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido, $nombre'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              _showGeneradorConfirmation(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.account_circle_outlined),
            onPressed: () {
              _showLogoutConfirmation(context);
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Text(
            'Actividades Pendientes',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Container(
            width: 150,
            height: 150,
            color: Colors.grey[300],
          ),
          SizedBox(height: 20),
          const Text('Texto o descripción de las actividades pendientes'),
          SizedBox(height: 20),
          Text(
            'Pictogramas',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          // Row de imágenes
          FutureBuilder(
            future: Future.wait([
              '2024-01-12 19:14:07.537816.png',
              '2024-01-11 07:23:02.310851.png',
              '2024-01-18 05:26:01.323700.png',
              '2024-01-18 05:28:59.653639.png',
              '2024-01-18 05:34:06.442461.png'
            ].map((imageName) async {
              final ref = firebase_storage.FirebaseStorage.instance
                  .ref()
                  .child('images/$imageName');
              return await ref.getDownloadURL();
            })),
            builder: (context, AsyncSnapshot<List<String>> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                List<String> imageUrls = snapshot.data!;
                return Container(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: imageUrls.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.network(
                          imageUrls[index],
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
          Expanded(
            child: Center(
              child: Text('Bienvenido!, $nombre'),
            ),
          ),
        ],
      ),
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.reactCircle,
        items: [
          TabItem(icon: Icons.home, title: 'Inicio'),
          TabItem(icon: Icons.search, title: 'Pictogramas'),
          TabItem(icon: Icons.assignment, title: 'Actividades'),
          TabItem(icon: Icons.account_circle_outlined, title: 'Cuenta'),
        ],
        onTap: (index) {
          if (index == 1) {
            _showGeneradorConfirmation(context);
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => GeneradorIA()),
            );
          } else if (index == 3) {
            _showLogoutConfirmation(context);
          }
        },
      ),
    );
  }
}
