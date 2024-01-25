import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:pictodi2/presentation/home/ninopage/pictoia.dart';
import 'ninopage/generatorpictograms.dart';
import 'ninopage/home.dart';
import 'ninopage/profile.dart';

class NinoInit extends StatefulWidget {
  final String nombre;
  final String instituto;
  final String diagnostico;
  final String fecha_nacimiento;
  final String grado;
  final String grupo;
  final String gravedad;

  const NinoInit(
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
  State<NinoInit> createState() => _NinoInitState();
}

class _NinoInitState extends State<NinoInit> {
  int _currentIndex = 0;

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
      PagePictograms(),
      PictoIA(),
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
    Colors.cyan,
    Colors.purple,
    Colors.green,
    Colors.red,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        margin: const EdgeInsets.only(bottom: 10),
        child: GNav(
          tabBackgroundColor: colors[0],
          selectedIndex: _currentIndex,
          tabBorderRadius: 10,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          onTabChange: (index) => {setState(() => _currentIndex = index)},
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
