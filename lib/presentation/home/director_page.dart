import 'directorpage/add.dart';
import 'directorpage/home/home.dart';
import 'directorpage/profile.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class DirectPage extends StatefulWidget {
  final String nombre;
  final String instituto;
  const DirectPage({Key? key, required this.nombre, required this.instituto})
      : super(key: key);

  @override
  State<DirectPage> createState() => _DirectPageState();
}

class _DirectPageState extends State<DirectPage> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          _buildScreen(_currentIndex),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        margin: const EdgeInsets.only(bottom: 10),
        child: GNav(
          tabBackgroundColor: const Color(0xFF60A9CD),
          selectedIndex: _currentIndex,
          tabBorderRadius: 10,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          onTabChange: (index) {
            setState(() {
              _currentIndex = index;
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
              text: 'Ver',
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

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        return HomeDirect(
          nombre: widget.nombre,
          instituto: widget.instituto,
        );
      case 1:
        return Infop();
      case 2:
        return PerfilPage(
          nombre: widget.nombre,
          instituto: widget.instituto,
        );
      default:
        return Container();
    }
  }
}
