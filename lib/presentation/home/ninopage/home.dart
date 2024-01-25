import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  final String nombre;
  final String instituto;
  final String diagnostico;
  final String fecha_nacimiento;
  final String grado;
  final String grupo;
  final String gravedad;
  const MainScreen(
      {Key? key,
      required this.nombre,
      required this.instituto,
      required this.diagnostico,
      required this.fecha_nacimiento,
      required this.grado,
      required this.grupo,
      required this.gravedad})
      : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundImage: AssetImage('assets/profile_image.png'),
                      radius: 30,
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.notifications),
                      style: IconButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        backgroundColor: Colors.white,
                        fixedSize: const Size(55, 55),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                // Nuevo Contenedor para el mensaje de bienvenida
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Bienvenido, ${widget.nombre}',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Fin del mensaje de bienvenida
                const SizedBox(height: 20),
                Column(
                  children: [
                    buildImageContainer(
                      imageUrl:
                          'https://es.tobiidynavox.com/cdn/shop/products/PCS-Classic-12-825x675_1_1200x.png?v=1627033284',
                      text: 'Pictogramas',
                    ),
                    const SizedBox(height: 30),
                    buildImageContainer(
                      imageUrl:
                          'https://img.freepik.com/vector-premium/juego-papeleria-ilustracion-dibujos-animados-plana_2175-5702.jpg',
                      text: 'Actividades',
                    ),
                    const SizedBox(height: 30),
                    buildImageContainer(
                      imageUrl:
                          'https://s.allright.com/blog/Frame_313404758_0c2ffc0f60.png',
                      text: 'Área de vocabulario',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildImageContainer({required String imageUrl, required String text}) {
    return Container(
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          Center(
            child: Text(
              text,
              style: const TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
