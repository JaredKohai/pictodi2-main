import 'package:flutter/material.dart';
import 'package:pictodi2/presentation/home/maestropage/iagen.dart';
import 'package:pictodi2/presentation/home/padrepage/profiel.dart';
import 'package:pictodi2/presentation/home/ninopage/vocabulary.dart';
import 'package:pictodi2/presentation/home/padrepage/ninospadres.dart';

class InicioPage extends StatelessWidget {
  final String nombre;
  final String instituto;

  const InicioPage({Key? key, required this.nombre, required this.instituto})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '¡Bienvenido a la aplicación, $nombre!',
                style: TextStyle(fontSize: 24.0),
              ),
              SizedBox(height: 20),
              _buildCard(
                context,
                'Inspeccionar Niños',
                'assets/niños.jpg',
                Colors.lightBlue[100],
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NinosPadres(nombre: nombre),
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              _buildCard(
                context,
                'Generar Pictogramas',
                'assets/pictogen.jpg',
                Colors.orange[100],
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          GeneradorIA(), // Cambié a GeneradorIA
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

  Widget _buildCard(BuildContext context, String title, String imagePath,
      Color? color, Function onTap) {
    return Card(
      elevation: 4,
      color: color ??
          Colors.transparent, // Si color es nulo, usa Colors.transparent
      child: InkWell(
        onTap: onTap as void Function()?,
        child: Column(
          children: [
            FractionallySizedBox(
              widthFactor: 1.0,
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: TextStyle(fontSize: 18.0),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
