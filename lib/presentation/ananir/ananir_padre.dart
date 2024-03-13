import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import '../settings/register.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AnadirPadrePage extends StatefulWidget {
  final String instituto;

  AnadirPadrePage({required this.instituto});

  @override
  _AnadirPadrePageState createState() => _AnadirPadrePageState();
}

class _AnadirPadrePageState extends State<AnadirPadrePage> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();

  List<String> _ninosSeleccionados = [];
  List<Nino> _ninos = [];

  Future<void> _cargarNinosDesdeFirestore() async {
    QuerySnapshot ninosSnapshot =
        await FirebaseFirestore.instance.collection('niños').get();

    setState(() {
      _ninos = ninosSnapshot.docs.map((doc) {
        return Nino(id: doc.id, nombre: doc['nombre']);
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _cargarNinosDesdeFirestore();
  }

  void _registrarPadre() {
    if (_camposNoVacios() && _validarCampos()) {
      Crear creador = Crear();

      creador.registerPadre(
        _correoController.text,
        _contrasenaController.text,
        _nombreController.text,
        _ninosSeleccionados,
        instituto: widget.instituto, // Pasar el instituto como parámetro
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Padre registrado exitosamente.'),
        ),
      );
    }
  }

  bool _camposNoVacios() {
    return _nombreController.text.isNotEmpty &&
        _correoController.text.isNotEmpty &&
        _contrasenaController.text.isNotEmpty;
  }

  bool _validarCampos() {
    // Validar el formato de correo electrónico
    if (!_correoValido(_correoController.text)) {
      _mostrarMensajeError('Formato de correo no válido.');
      return false;
    }

    // Validar la longitud de la contraseña
    if (_contrasenaController.text.length < 6) {
      _mostrarMensajeError('La contraseña debe tener al menos 6 caracteres.');
      return false;
    }

    return true;
  }

  bool _correoValido(String correo) {
    // Implementa tu lógica de validación de correo electrónico aquí
    // Puedes usar expresiones regulares o cualquier otro método de validación
    return correo.contains('@');
  }

  void _mostrarMensajeError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: $mensaje'),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Añadir Padre'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _nombreController,
              decoration: InputDecoration(labelText: 'Nombre del Padre'),
            ),
            TextFormField(
              controller: _correoController,
              decoration: InputDecoration(labelText: 'Correo del Padre'),
            ),
            TextFormField(
              controller: _contrasenaController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Contraseña del Padre'),
            ),
            SizedBox(height: 20),
            MultiSelectDialogField(
              items: _ninos
                  .map((nino) => MultiSelectItem<Nino>(nino, nino.nombre))
                  .toList(),
              listType: MultiSelectListType.CHIP,
              onConfirm: (values) {
                setState(() {
                  _ninosSeleccionados = values
                      .whereType<Nino>()
                      .map((nino) => nino.nombre)
                      .toList();
                });
              },
              chipDisplay: MultiSelectChipDisplay(
                onTap: (value) {
                  setState(() {
                    _ninosSeleccionados.remove(value);
                  });
                },
              ),
              buttonText: Text('Seleccionar Niños'),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _registrarPadre();
              },
              child: const Text('Registrar Padre'),
            ),
          ],
        ),
      ),
    );
  }
}

class Nino {
  final String id;
  final String nombre;

  Nino({required this.id, required this.nombre});
}
