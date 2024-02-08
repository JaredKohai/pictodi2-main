import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HeaderScreen extends StatelessWidget {
  final String nombre;
  final String instituto;
  final Size size;

  const HeaderScreen({
    Key? key,
    required this.size,
    required this.nombre,
    required this.instituto,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10 * 2.5),
      height: size.height * .30,
      child: Stack(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 56),
            height: size.height * 0.35 - 27,
            decoration: const BoxDecoration(
              color: Color(0xFF60A9CD),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(36),
                bottomRight: Radius.circular(36),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'Hola $instituto', // Mostrar el nombre proporcionado
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 38,
                      ),
                ),
                const Spacer(),
                Image.asset(
                  'assets/profile_image.png',
                  height: size.height * .08,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 35,
            left: 0,
            right: 0,
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              height: 54,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 10),
                    blurRadius: 50,
                    color: const Color(0xFF60A9CD).withOpacity(0.23),
                  )
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Buscar",
                        hintStyle: TextStyle(
                          color: const Color(0xFF60A9CD).withOpacity(0.5),
                        ),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  SvgPicture.asset('assets/search.svg'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
