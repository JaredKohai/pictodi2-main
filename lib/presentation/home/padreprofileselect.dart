import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pictodi2/presentation/home/ninopage.dart';
import 'package:pictodi2/presentation/home/padrepage/init.dart';

class PadresPages extends StatelessWidget {
  final String nombre;

  const PadresPages({Key? key, required this.nombre}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('padres')
            .where('nombre', isEqualTo: nombre)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No se encontraron datos para el padre.'),
            );
          }

          QueryDocumentSnapshot padreDoc = snapshot.data!.docs.first;
          Map<String, dynamic> data = padreDoc.data() as Map<String, dynamic>;
          String nombrePadre = data['nombre'];
          List<dynamic> hijos = data['hijos'];

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
                ProfileBox(
                  imageUrl: 'https://via.placeholder.com/150',
                  name: nombrePadre,
                  size: 100.0,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PadresHome(currentUserData: data),
                      ),
                    );
                    _buscarDatosHijo(nombrePadre, context);
                  },
                ),
                SizedBox(height: 20.0),
                Wrap(
                  alignment: WrapAlignment.start,
                  spacing: 10.0,
                  runSpacing: 10.0,
                  children: hijos
                      .map((nombreHijo) => ProfileBox(
                            imageUrl: 'https://via.placeholder.com/150',
                            name: nombreHijo,
                            size: 100.0,
                            onPressed: () {
                              _buscarDatosHijo(nombreHijo, context);
                            },
                          ))
                      .toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _buscarDatosHijo(String nombreHijo, BuildContext context) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('niños')
        .where('nombre', isEqualTo: nombreHijo)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      QueryDocumentSnapshot hijoDoc = querySnapshot.docs.first;
      Map<String, dynamic> data = hijoDoc.data() as Map<String, dynamic>;

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => HomePageKid(
            nombre: data['nombre'],
            instituto: data['instituto'],
            diagnostico: data['diagnostico'],
            fecha_nacimiento: data['fecha_nacimiento'],
            grado: data['grado'],
            grupo: data['grupo'],
            gravedad: data['gravedad'],
          ),
        ),
      );
    }
  }
}

class ProfileBox extends StatelessWidget {
  final String imageUrl;
  final String name;
  final double size;
  final VoidCallback onPressed;

  const ProfileBox(
      {Key? key,
      required this.imageUrl,
      required this.name,
      required this.size,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.grey,
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
