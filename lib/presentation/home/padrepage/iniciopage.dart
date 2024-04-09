import 'package:flutter/material.dart';
import 'ninospadres.dart';

class InicioPage extends StatelessWidget {
  final String nombre;

  const InicioPage({Key? key, required this.nombre}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Página de Inicio'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '¡Bienvenido a mi aplicación, $nombre!',
                style: TextStyle(fontSize: 24.0),
              ),
              SizedBox(height: 20),
              Card(
                elevation: 4,
                color: Colors.lightBlue[100],
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NinosPadres(
                              nombre:
                                  nombre)), // Navega a la página NiñosPadres.dart
                    );
                  },
                  child: Column(
                    children: [
                      FractionallySizedBox(
                        widthFactor: 1.0,
                        child: Image.asset(
                          'assets/niños.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Inspeccionar Niños',
                          style: TextStyle(fontSize: 18.0),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Card(
                elevation: 4,
                color: Colors.yellow[100],
                child: InkWell(
                  onTap: () {
                    // Aquí puedes añadir la lógica para navegar a la biblioteca de pictogramas
                  },
                  child: Column(
                    children: [
                      FractionallySizedBox(
                        widthFactor: 1.0,
                        child: Image.asset(
                          'assets/biblioteca.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Ir a tu biblioteca de pictogramas',
                          style: TextStyle(fontSize: 18.0),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Card(
                elevation: 4,
                color: Colors.orange[100],
                child: InkWell(
                  onTap: () {
                    // Aquí puedes añadir la lógica para navegar a la página de generación de pictogramas
                  },
                  child: Column(
                    children: [
                      FractionallySizedBox(
                        widthFactor: 1.0,
                        child: Image.asset(
                          'assets/pictogen.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Generar Pictogramas',
                          style: TextStyle(fontSize: 18.0),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Card(
                elevation: 4,
                color: Colors.red[100],
                child: InkWell(
                  onTap: () {
                    // Aquí puedes añadir la lógica para navegar a la página de perfil del padre
                  },
                  child: Column(
                    children: [
                      FractionallySizedBox(
                        widthFactor: 1.0,
                        child: Image.asset(
                          'assets/perfil.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Perfil',
                          style: TextStyle(fontSize: 18.0),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
