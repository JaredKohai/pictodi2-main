import 'package:flutter/material.dart';
import 'GeneratorPictogram.dart';
import 'activitypage.dart';
import 'notifications.dart';
import 'profiel.dart';
import 'vocabulary.dart';

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
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        // Navegar a la pantalla de notificaciones al hacer clic en el icono
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const NotificationPage()),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: const Icon(Icons.notifications),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // Navegar a la pantalla de notificaciones al hacer clic en la imagen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PerfilPage(
                                    nombre: widget.nombre,
                                    instituto: widget.instituto,
                                    diagnostico: widget.diagnostico,
                                    fecha_nacimiento: widget.fecha_nacimiento,
                                    grado: widget.grado,
                                    grupo: widget.grupo,
                                    gravedad: widget.gravedad,
                                  )),
                        );
                      },
                      child: const CircleAvatar(
                        backgroundImage: AssetImage('assets/profile_image.png'),
                        radius: 30,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hola ${widget.nombre}👋',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            height: 1,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Bienvenido a PictoDi',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    buildImageContainer(
                      imageUrl:
                          'https://es.tobiidynavox.com/cdn/shop/products/PCS-Classic-12-825x675_1_1200x.png?v=1627033284',
                      text: 'Pictogramas',
                      onTap: () {
                        // Navegar a la pantalla de Pictogramas
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PagePictograms(nombre: widget.nombre,)),
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                    buildImageContainer(
                      imageUrl:
                          'https://img.freepik.com/vector-premium/juego-papeleria-ilustracion-dibujos-animados-plana_2175-5702.jpg',
                      text: 'Actividades',
                      onTap: () {
                        // Navegar a la pantalla de Actividades
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ActivityPage( nombre: widget.nombre, instituto: widget.instituto,  grado: widget.grado, grupo: widget.grupo,)),
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                    buildImageContainer(
                      imageUrl:
                          'https://s.allright.com/blog/Frame_313404758_0c2ffc0f60.png',
                      text: 'Área de vocabulario',
                      onTap: () {
                        // Navegar a la pantalla de Área de Vocabulario
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PageVocabulary()),
                        );
                      },
                    ),
                    // Puedes agregar más contenedores según sea necesario
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildImageContainer(
      {required String imageUrl, required String text, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
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
      ),
    );
  }
}
