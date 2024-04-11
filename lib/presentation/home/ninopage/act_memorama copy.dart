import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ActMemoramaPage extends StatefulWidget {
  final List<String> imagenesSeleccionadas;
  final String nombre;

  const ActMemoramaPage(
      {Key? key, required this.imagenesSeleccionadas, required this.nombre})
      : super(key: key);

  @override
  _ActMemoramaPageState createState() => _ActMemoramaPageState();
}

class _ActMemoramaPageState extends State<ActMemoramaPage> {
  late List<String> cartas;
  late List<bool> cartasVolteadas;
  int? primeraSeleccionIndex;
  int? segundaSeleccionIndex;

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
    primeraSeleccionIndex = null;
    segundaSeleccionIndex = null;
  }

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
            childAspectRatio: 2 / 3,
          ),
          itemCount: cartas.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                if (!cartasVolteadas[index]) {
                  voltearCarta(index);
                }
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                margin: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: cartasVolteadas[index] ? Colors.grey : Colors.white,
                ),
                child: Center(
                  child: cartasVolteadas[index]
                      ? Image.network(
                          cartas[index],
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          "https://cdn.pixabay.com/photo/2012/05/07/18/52/card-game-48980_1280.png",
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void voltearCarta(int index) {
    setState(() {
      if (primeraSeleccionIndex == null) {
        primeraSeleccionIndex = index;
        cartasVolteadas[index] = true;
      } else if (segundaSeleccionIndex == null &&
          index != primeraSeleccionIndex) {
        segundaSeleccionIndex = index;
        cartasVolteadas[index] = true;
        if (cartas[primeraSeleccionIndex!] == cartas[segundaSeleccionIndex!]) {
          primeraSeleccionIndex = null;
          segundaSeleccionIndex = null;
          if (cartasVolteadas.every((element) => element)) {
            mostrarDialogo();
            // Buscar la actividad correspondiente en la colección 'actividades'
            buscarActividad();
          }
        } else {
          Future.delayed(const Duration(milliseconds: 500), () {
            setState(() {
              cartasVolteadas[primeraSeleccionIndex!] = false;
              cartasVolteadas[segundaSeleccionIndex!] = false;
              primeraSeleccionIndex = null;
              segundaSeleccionIndex = null;
            });
          });
        }
      }
    });
  }

  void mostrarDialogo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('¡Felicidades!'),
        content: Text('¡Has encontrado todos los pares!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  void buscarActividad() {
    FirebaseFirestore.instance
        .collection('actividades')
        .where('imagenes_seleccionadas',
            isEqualTo: widget.imagenesSeleccionadas)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        // Obtener el ID de la actividad
        String actividadId = doc.id;
        // Agregar el nombre del niño a la matriz 'alumnos' en la colección de actividades
        FirebaseFirestore.instance
            .collection('actividades')
            .doc(actividadId)
            .update({
          'alumnos': FieldValue.arrayUnion([widget.nombre]),
        });
      });
    });
  }
}
