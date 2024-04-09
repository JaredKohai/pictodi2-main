import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:pictodi2/presentation/home/maestropage/iagen.dart';
import 'padrepage/iniciopage.dart';
import 'maestropage/iagen.dart';
import 'padrepage/profiel.dart';
import 'padrepage/DashboardVocabulary.dart';

class PadrePage extends StatefulWidget {
  final String nombre;
  final String instituto;

  const PadrePage({
    Key? key,
    required this.nombre,
    required this.instituto,
  }) : super(key: key);

  @override
  State<PadrePage> createState() => _PadrePageState();
}

class _PadrePageState extends State<PadrePage> {
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
      InicioPage(nombre: widget.nombre,),
      VocabularyDashboard(),
      GeneradorIA(),
      PerfilPage(
        nombre: widget.nombre,
        instituto: widget.instituto,
      )
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
              icon: Icons.groups_2,
              text: 'Clases',
              iconActiveColor: Colors.white,
              textColor: Colors.white,
            ),
            GButton(
              icon: Icons.all_inbox,
              text: 'Pictogramas',
              iconActiveColor: Colors.white,
              textColor: Colors.white,
            ),
            GButton(
              icon: Icons.generating_tokens_rounded,
              text: 'Generador',
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
