import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'ninopage/GeneratorPictogram.dart';
import 'ninopage/activitypage.dart';
import 'ninopage/classpage.dart';
import 'ninopage/home.dart';
import 'ninopage/profiel.dart';
import 'ninopage/vocabulary.dart';

class KidDrawerScreen extends StatefulWidget {
  final String nombre;
  final String instituto;
  final String diagnostico;
  final String fecha_nacimiento;
  final String grado;
  final String grupo;
  final String gravedad;
  const KidDrawerScreen(
      {Key? key,
      required this.nombre,
      required this.instituto,
      required this.diagnostico,
      required this.fecha_nacimiento,
      required this.grado,
      required this.grupo,
      required this.gravedad});

  @override
  _KidDrawerScreenState createState() => _KidDrawerScreenState();
}

class _KidDrawerScreenState extends State<KidDrawerScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF60A9CD),
      child: Padding(
        padding: const EdgeInsets.only(top: 50, left: 40, bottom: 70),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: const Image(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/profile_image.png'),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  widget.nombre,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                DrawerItem(
                  text: 'Inicio',
                  icon: Icons.home_rounded,
                  onTap: () {
                    Navigator.pop(context); // Cierra el drawer
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePageKid(
                          nombre: widget.nombre,
                          instituto: widget.instituto,
                          diagnostico: widget.diagnostico,
                          fecha_nacimiento: widget.fecha_nacimiento,
                          grado: widget.grado,
                          grupo: widget.grupo,
                          gravedad: widget.gravedad,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                DrawerItem(
                  text: 'Pictogramas',
                  icon: Icons.search_rounded,
                  onTap: () {
                    Navigator.pop(context); // Cierra el drawer
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PagePictograms(nombre: widget.nombre,),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                DrawerItem(
                  text: 'Vocabulario',
                  icon: Icons.bookmark_added_rounded,
                  onTap: () {
                    Navigator.pop(context); // Cierra el drawer
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PageVocabulary(),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                DrawerItem(
                  text: 'Clases',
                  icon: Icons.class_rounded,
                  onTap: () {
                    Navigator.pop(context); // Cierra el drawer
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ClasesPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                DrawerItem(
                  text: 'Actividades',
                  icon: Icons.assignment,
                  onTap: () {
                    Navigator.pop(context); // Cierra el drawer
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ActivityPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                DrawerItem(
                  text: 'Profile',
                  icon: Icons.person_2_rounded,
                  onTap: () {
                    Navigator.pop(context); // Cierra el drawer
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
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
            const Row(
              children: <Widget>[
                Icon(
                  Icons.logout_rounded,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Log out',
                  style: TextStyle(color: Colors.white),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const DrawerItem({
    Key? key,
    required this.icon,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: <Widget>[
          Icon(
            icon,
            color: Colors.white,
          ),
          const SizedBox(
            width: 20,
          ),
          Text(
            text,
            style: const TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }
}

class HomePageKid extends StatefulWidget {
  final String nombre;
  final String instituto;
  final String diagnostico;
  final String fecha_nacimiento;
  final String grado;
  final String grupo;
  final String gravedad;
  const HomePageKid(
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
  State<HomePageKid> createState() => _HomePageKidState();
}

class _HomePageKidState extends State<HomePageKid> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late List<Widget> screens;

  @override
  void initState() {
    super.initState();
    screens = [
      MainScreen(
        nombre: widget.nombre,
        instituto: widget.instituto,
        diagnostico: widget.diagnostico,
        fecha_nacimiento: widget.fecha_nacimiento,
        grado: widget.grado,
        grupo: widget.grupo,
        gravedad: widget.gravedad,
      ),
      PagePictograms(nombre: widget.nombre),
      const ActivityPage(),
      PerfilPage(
        nombre: widget.nombre,
        instituto: widget.instituto,
        diagnostico: widget.diagnostico,
        fecha_nacimiento: widget.fecha_nacimiento,
        grado: widget.grado,
        grupo: widget.grupo,
        gravedad: widget.gravedad,
      ),
    ];
  }

  final colors = [
    const Color(0xFF60A9CD),
    Colors.purple,
    Colors.green,
    Colors.red,
  ];

  // ignore: unused_field
  double _scaleFactor = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          screens[_currentIndex],
          Positioned(
            left: 10,
            top: 50,
            child: IconButton(
              icon: const Icon(Icons.menu),
              iconSize: 35,
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
                setState(() {
                  _scaleFactor = 0.8;
                });
              },
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: KidDrawerScreen(
          nombre: widget.nombre,
          instituto: widget.instituto,
          diagnostico: widget.diagnostico,
          fecha_nacimiento: widget.fecha_nacimiento,
          grado: widget.grado,
          grupo: widget.grupo,
          gravedad: widget.gravedad,
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        margin: const EdgeInsets.only(bottom: 10),
        child: GNav(
          tabBackgroundColor: colors[0],
          selectedIndex: _currentIndex,
          tabBorderRadius: 10,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          onTabChange: (index) {
            setState(() {
              _currentIndex = index;
              _scaleFactor = 1.0;
            });
          },
          tabs: const [
            GButton(
              icon: Icons.home,
              text: 'Inicio',
              iconActiveColor: Colors.white,
              textColor: Colors.white,
            ),
            GButton(
              icon: Icons.search,
              text: 'Pictogramas',
              iconActiveColor: Colors.white,
              textColor: Colors.white,
            ),
            GButton(
              icon: Icons.assignment,
              text: 'Actividades',
              iconActiveColor: Colors.white,
              textColor: Colors.white,
            ),
            GButton(
              icon: Icons.person,
              text: 'Perfil',
              iconActiveColor: Colors.white,
              textColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
