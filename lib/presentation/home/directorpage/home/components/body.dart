import 'addAccount.dart';
import 'header.dart';
import 'package:flutter/material.dart';

class Body extends StatelessWidget {
  final String nombre;
  final String instituto;

  const Body({super.key, required this.nombre, required this.instituto});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          HeaderScreen(
            size: size,
            nombre: '',
            instituto: '',
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                TitleCaro(),
              ],
            ),
          ),
          RecomendsAddAccount(
            nombre: nombre,
            instituto: instituto,
          )
        ],
      ),
    );
  }
}

class TitleCaro extends StatelessWidget {
  const TitleCaro({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      child: Stack(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(left: 5),
            child: Text('Agregar Usuarios',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                margin: const EdgeInsets.only(right: 20 / 4),
                height: 7,
                color: const Color(0xFF60A9CD).withOpacity(0.2),
              ))
        ],
      ),
    );
  }
}
