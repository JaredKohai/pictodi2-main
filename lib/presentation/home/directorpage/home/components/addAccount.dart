import 'package:flutter/material.dart';
import 'package:pictodi2/presentation/ananir/ananir_maestro.dart';
import 'package:pictodi2/presentation/ananir/ananir_nino.dart';
import 'package:pictodi2/presentation/ananir/ananir_padre.dart';
import 'package:pictodi2/presentation/ananir/ananir_psicologo.dart';


class RecomendsAddAccount extends StatelessWidget {
  final String nombre;
  final String instituto;
  const RecomendsAddAccount(
      {Key? key, required this.nombre, required this.instituto})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              RecomendAccountCard(
                image: "assets/boy.png",
                title: "Niño",
                icon: Icons.add,
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AnadirNinoPage(instituto: instituto),
                    ),
                  );
                },
              ),
              RecomendAccountCard(
                image: "assets/doctor.png",
                title: "Psicólogo",
                icon: Icons.add,
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AnadirPsicologoPage(instituto: instituto),
                    ),
                  );
                },
              ),
            ],
          ),
          Row(
            children: <Widget>[
              RecomendAccountCard(
                image: "assets/teachers.png",
                title: "Profesor",
                icon: Icons.add,
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AnadirMaestroPage(
                        instituto: instituto,
                      ),
                    ),
                  );
                },
              ),
              RecomendAccountCard(
                image: "assets/father-and-daughter.png",
                title: "Padre",
                icon: Icons.add,
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AnadirPadrePage(instituto: instituto),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class RecomendAccountCard extends StatelessWidget {
  const RecomendAccountCard({
    Key? key,
    required this.image,
    required this.title,
    required this.icon,
    required this.press,
  }) : super(key: key);

  final String image, title;
  final IconData icon;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(
        left: 20,
        top: 10,
        bottom: 20,
        right: 20,
      ),
      width: size.width * 0.4,
      child: Column(
        children: <Widget>[
          Image.asset(
            image,
            height: size.height * 0.2,
          ),
          GestureDetector(
            onTap: press,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 10),
                    blurRadius: 50,
                    color: Colors.grey.withOpacity(0.2),
                  ),
                ],
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: title.toUpperCase(),
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Icon(
                    icon,
                    color: Colors.green,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
