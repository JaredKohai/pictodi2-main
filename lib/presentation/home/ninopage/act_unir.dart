import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UnirPage extends StatefulWidget {
  final List<String> imagenesSeleccionadas;
  final String nombre;

  const UnirPage(
      {Key? key, required this.imagenesSeleccionadas, required this.nombre})
      : super(key: key);

  @override
  _UnirPageState createState() => _UnirPageState();
}

class _UnirPageState extends State<UnirPage> {
  late List<String> imagenesIzquierda;
  late List<String> imagenesDerecha;
  late List<bool> imagenesSeleccionadas;
  int? primeraSeleccionIndex;
  int? segundaSeleccionIndex;

  @override
  void initState() {
    super.initState();
    inicializarJuego();
  }

  void inicializarJuego() {
    // Dividir las imágenes en dos listas y mezclarlas
    imagenesIzquierda = List<String>.from(widget.imagenesSeleccionadas);
    imagenesDerecha = List<String>.from(widget.imagenesSeleccionadas);
    imagenesIzquierda.shuffle();
    imagenesDerecha.shuffle();
    imagenesSeleccionadas = List<bool>.filled(imagenesIzquierda.length, false);
    primeraSeleccionIndex = null;
    segundaSeleccionIndex = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Unir Imágenes'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildColumn(imagenesIzquierda),
          _buildColumn(imagenesDerecha),
          if (primeraSeleccionIndex != null && segundaSeleccionIndex != null)
            CustomPaint(
              painter: LinePainter(
                primeraIndex: primeraSeleccionIndex!,
                segundaIndex: segundaSeleccionIndex!,
                imagenesIzquierda: imagenesIzquierda,
                imagenesDerecha: imagenesDerecha,
                imagenesSeleccionadas: imagenesSeleccionadas,
              ),
              size: Size.infinite,
            ),
        ],
      ),
    );
  }

  Widget _buildColumn(List<String> imagenes) {
    return Column(
      children: imagenes.asMap().entries.map((entry) {
        int index = entry.key;
        String imagen = entry.value;
        return DragTarget<int>(
          onWillAccept: (data) =>
              !imagenesSeleccionadas[index] &&
              (primeraSeleccionIndex == null || segundaSeleccionIndex == null),
          onAccept: (data) {
            _onAccept(index, data);
          },
          builder: (context, candidateData, rejectedData) {
            return Stack(
              children: [
                AnimatedOpacity(
                  opacity: imagenesSeleccionadas[index] ? 0.0 : 1.0,
                  duration: Duration(milliseconds: 500),
                  child: Container(
                    margin: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    child: Draggable<int>(
                      data: index,
                      child: Image.network(
                        imagen,
                        fit: BoxFit.cover,
                        width: 100.0,
                        height: 100.0,
                      ),
                      feedback: Image.network(
                        imagen,
                        fit: BoxFit.cover,
                        width: 100.0,
                        height: 100.0,
                      ),
                      childWhenDragging: Container(
                        margin: EdgeInsets.all(4),
                        width: 100.0,
                        height: 100.0,
                      ),
                    ),
                  ),
                ),
                if (primeraSeleccionIndex != null &&
                    segundaSeleccionIndex != null &&
                    (primeraSeleccionIndex == index ||
                        segundaSeleccionIndex == index))
                  Positioned.fill(
                    child: Icon(
                      Icons.check,
                      color: Colors.green,
                    ),
                  ),
              ],
            );
          },
        );
      }).toList(),
    );
  }

  void _onAccept(int index, int? data) {
    if (primeraSeleccionIndex == null) {
      primeraSeleccionIndex = index;
    } else if (segundaSeleccionIndex == null &&
        primeraSeleccionIndex != index) {
      segundaSeleccionIndex = index;
      if (imagenesIzquierda[primeraSeleccionIndex!] ==
          imagenesDerecha[segundaSeleccionIndex!]) {
        imagenesSeleccionadas[primeraSeleccionIndex!] = true;
        imagenesSeleccionadas[segundaSeleccionIndex!] = true;
        setState(() {
          primeraSeleccionIndex = null;
          segundaSeleccionIndex = null;
        });
        Future.delayed(const Duration(milliseconds: 1000), () {
          _borrarImagenes();
        });
      } else {
        Future.delayed(const Duration(milliseconds: 500), () {
          setState(() {
            primeraSeleccionIndex = null;
            segundaSeleccionIndex = null;
          });
        });
      }
    }
  }

  void _borrarImagenes() {
    bool quedanPares = false;
    for (int i = 0; i < imagenesSeleccionadas.length; i++) {
      if (!imagenesSeleccionadas[i]) {
        quedanPares = true;
        break;
      }
    }
    if (!quedanPares) {
      // Se han unido todas las imágenes, guardar el nombre del niño
      buscarActividad();
      mostrarDialogo();
      setState(() {
        imagenesSeleccionadas =
            List<bool>.filled(imagenesSeleccionadas.length, false);
      });
    }
  }

  void mostrarDialogo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('¡Felicidades!'),
        content: Text('¡Has unido todas las imágenes!'),
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

class LinePainter extends CustomPainter {
  final int primeraIndex;
  final int segundaIndex;
  final List<String> imagenesIzquierda;
  final List<String> imagenesDerecha;
  final List<bool> imagenesSeleccionadas;

  LinePainter({
    required this.primeraIndex,
    required this.segundaIndex,
    required this.imagenesIzquierda,
    required this.imagenesDerecha,
    required this.imagenesSeleccionadas,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (primeraIndex >= imagenesIzquierda.length ||
        segundaIndex >= imagenesDerecha.length) {
      return;
    }
    if (!imagenesSeleccionadas[primeraIndex] ||
        !imagenesSeleccionadas[segundaIndex]) {
      return;
    }

    final Paint paint = Paint()
      ..color = Colors.yellow
      ..strokeWidth = 5;

    final firstImageCenter = Offset(size.width / 4,
        size.height * ((primeraIndex + 0.5) / imagenesIzquierda.length));
    final secondImageCenter = Offset(size.width * (3 / 4),
        size.height * ((segundaIndex + 0.5) / imagenesDerecha.length));

    canvas.drawLine(firstImageCenter, secondImageCenter, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
