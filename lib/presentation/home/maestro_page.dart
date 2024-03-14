import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:pictodi2/presentation/home/maestropage/iagen.dart';
import 'maestropage/activities.dart';
import 'maestropage/class/classes.dart';
import 'maestropage/notifications.dart';

class MaestroPages extends StatefulWidget {
  final String nombre;
  final String instituto;
  final List asignaturas; // Cambiar a List<dynamic>
  final String grado;
  final String grupo;

  const MaestroPages({
    Key? key,
    required this.nombre,
    required this.instituto,
    required this.asignaturas,
    required this.grado,
    required this.grupo,
  }) : super(key: key);

  @override
  State<MaestroPages> createState() => _MaestroPagesState();
}

class _MaestroPagesState extends State<MaestroPages> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late List<Widget> screens;

  final colors = [
    const Color(0xFF60A9CD),
    Colors.purple,
    Colors.green,
    Colors.red,
  ];

  // ignore: unused_field
  double _scaleFactor = 1.0;

  @override
  void initState() {
    super.initState();
    screens = [
      const NotificationClass(),
      ClassesTabContent(
          nombre: widget.nombre,
          instituto: widget.instituto,
          asignaturas: widget.asignaturas
              .map((e) => e.toString())
              .toList(), // Convertir a List<String>/ Convertir a List<String>
          grado: widget.grado,
          grupo: widget.grupo),
      VocabularyDashboard(),
      const GeneradorIA()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          screens[_currentIndex],
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        margin: const EdgeInsets.only(bottom: 10),
        child: GNav(
          tabBackgroundColor: colors[0],
          selectedIndex: _currentIndex,
          tabBorderRadius: 10,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          onTabChange: (index) {
            setState(() {
              _currentIndex = index;
              _scaleFactor = 1.0;
            });
          },
          tabs: const [
            GButton(
              icon: Icons.notifications,
              text: 'Actividades',
              iconActiveColor: Colors.white,
              textColor: Colors.white,
            ),
            GButton(
              icon: Icons.groups_2,
              text: 'Clases',
              iconActiveColor: Colors.white,
              textColor: Colors.white,
            ),
            GButton(
              icon: Icons.all_inbox,
              text: 'Pictograms',
              iconActiveColor: Colors.white,
              textColor: Colors.white,
            ),
            GButton(
              icon: Icons.generating_tokens_rounded,
              text: 'Generador',
              iconActiveColor: Colors.white,
              textColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
