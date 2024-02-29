import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';

class ActMemoramaPage extends StatefulWidget {
  final List<String> imagenesSeleccionadas;

  const ActMemoramaPage({Key? key, required this.imagenesSeleccionadas})
      : super(key: key);

  @override
  _ActMemoramaPageState createState() => _ActMemoramaPageState();
}

class _ActMemoramaPageState extends State<ActMemoramaPage> {
  late List<String> cartas;
  late List<bool> cartasVolteadas;
  late List<int> cartasVolteadasIndices;
  late bool primeraSeleccion;
  late int primeraSeleccionIndex;

  @override
  void initState() {
    super.initState();
    inicializarCartas();
  }

  void inicializarCartas() {
    cartas = List<String>.from(widget.imagenesSeleccionadas);
    cartas.addAll(widget.imagenesSeleccionadas);
    cartas.shuffle();
    cartasVolteadas = List<bool>.filled(cartas.length, false);
    cartasVolteadasIndices = [];
    primeraSeleccion = true;
    primeraSeleccionIndex = -1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Memorama'),
      ),
      body: Center(
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio:
                2 / 3, // Aspect ratio to maintain correct card size
          ),
          itemCount: cartas.length,
          itemBuilder: (context, index) {
            return FlipCard(
              flipOnTouch: !cartasVolteadas[index],
              onFlip: () {
                if (!cartasVolteadas[index]) {
                  setState(() {
                    if (primeraSeleccion) {
                      primeraSeleccion = false;
                      primeraSeleccionIndex = index;
                    } else {
                      if (cartas[primeraSeleccionIndex] != cartas[index]) {
                        Future.delayed(const Duration(seconds: 1), () {
                          setState(() {
                            cartasVolteadas[primeraSeleccionIndex] = false;
                            cartasVolteadas[index] = false;
                          });
                        });
                      }
                      primeraSeleccion = true;
                    }
                    cartasVolteadasIndices.add(index);
                    if (cartasVolteadasIndices.length == cartas.length) {
                      // Activity completed
                      completarActividad(context);
                    }
                  });
                }
              },
              front: _buildCardContainer(
                  Icon(Icons.question_answer, color: Colors.white)),
              back: _buildCardContainer(Image.network(
                cartas[index],
                fit: BoxFit.cover,
              )),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCardContainer(Widget child) {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: child,
      ),
    );
  }

  void completarActividad(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Actividad completada'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Return to previous page (ClasesPage)
            },
            child: Text('Aceptar'),
          ),
        ],
      ),
    );
  }
}
