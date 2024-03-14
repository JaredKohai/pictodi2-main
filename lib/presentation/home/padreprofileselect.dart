import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PadresPages extends StatelessWidget {
  final String nombre;

  const PadresPages({Key? key, required this.nombre}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance.collection('padres').doc(nombre).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(
              child: Text('No se encontraron datos para el padre.'),
            );
          }

          // Obtener los datos del padre
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          String nombrePadre = data['nombre'];
          List<dynamic> hijos = data['hijos'];

          List<Widget> perfiles = [];

          // Crear un perfil para cada hijo del padre
          for (var hijo in hijos) {
            perfiles.add(ProfileBox(
                imageUrl: 'https://via.placeholder.com/150', name: hijo));
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '¿En qué cuenta deseas entrar, $nombrePadre?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(height: 20.0),
                GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  shrinkWrap: true,
                  children: perfiles,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ProfileBox extends StatelessWidget {
  final String imageUrl;
  final String name;

  const ProfileBox({Key? key, required this.imageUrl, required this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.grey,
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      margin: EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            ),
          ),
        ],
      ),
    );
  }
}
