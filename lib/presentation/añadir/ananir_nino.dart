import 'package:flutter/material.dart';
import '../settings/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class AnadirNinoPage extends StatefulWidget {
  final String instituto;

  AnadirNinoPage({required this.instituto});

  @override
  _AnadirNinoPageState createState() => _AnadirNinoPageState();
}

class _AnadirNinoPageState extends State<AnadirNinoPage> {
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _diagnosticoController = TextEditingController();
  final TextEditingController _fechaNacimientoController =
      TextEditingController();
  final TextEditingController _gradoController = TextEditingController();
  final TextEditingController _grupoController = TextEditingController();
  final TextEditingController _gravedadController = TextEditingController();

  DateTime? _selectedDate;

  // Método para manejar el registro del niño
  void _registrarNino() {
    if (_camposNoVacios() && _validarCampos()) {
      Crear creador = Crear();
      User? currentUser = FirebaseAuth.instance.currentUser;
      String userId = currentUser?.uid ?? '';

      creador.registerNino(
        _correoController.text,
        _contrasenaController.text,
        _nombreController.text,
        _diagnosticoController.text,
        _fechaNacimientoController.text,
        int.parse(_gradoController.text),
        _grupoController.text,
        _gravedadController.text,
        userId,
        widget.instituto, // Añadido el parámetro instituto
      );

      // Muestra un SnackBar indicando que el registro fue exitoso
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registro exitoso'),
        ),
      );

      // Puedes agregar más lógica aquí, como navegar a otra página.
    }
  }

  bool _camposNoVacios() {
    return _correoController.text.isNotEmpty &&
        _contrasenaController.text.isNotEmpty &&
        _nombreController.text.isNotEmpty &&
        _diagnosticoController.text.isNotEmpty &&
        _fechaNacimientoController.text.isNotEmpty &&
        _gradoController.text.isNotEmpty &&
        _grupoController.text.isNotEmpty &&
        _gravedadController.text.isNotEmpty;
  }

  bool _validarCampos() {
    // Validar el formato de fecha
    RegExp dateRegex = RegExp(r'^\d{2}/\d{2}/\d{4}$');
    if (!dateRegex.hasMatch(_fechaNacimientoController.text)) {
      _mostrarMensajeError('Formato de fecha no válido. Utiliza DD/MM/YYYY.');
      return false;
    }

    // Validar el límite de caracteres en grupo y grado
    if (_grupoController.text.length != 1) {
      _mostrarMensajeError(
          'El campo "Grupo" debe contener exactamente 1 letra.');
      return false;
    }

    if (_gradoController.text.isEmpty ||
        int.tryParse(_gradoController.text) == null) {
      _mostrarMensajeError('El campo "Grado" debe contener un número.');
      return false;
    }

    // Nuevas validaciones
    if (_contrasenaController.text.length < 6) {
      _mostrarMensajeError('La contraseña debe tener al menos 6 caracteres.');
      return false;
    }

    if (!_correoController.text.contains('@')) {
      _mostrarMensajeError('Formato de correo no válido. Debe contener "@".');
      return false;
    }

    // Validar que todos los campos estén llenos
    if (!_camposNoVacios()) {
      _mostrarMensajeError('Rellena todos los datos.');
      return false;
    }

    return true;
  }

  void _mostrarMensajeError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _fechaNacimientoController.text =
            DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Añadir Niño'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _correoController,
                decoration: const InputDecoration(labelText: 'Correo'),
              ),
              TextFormField(
                controller: _contrasenaController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Contraseña'),
              ),
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre del niño'),
              ),
              TextFormField(
                controller: _diagnosticoController,
                decoration: const InputDecoration(labelText: 'Diagnóstico'),
              ),
              TextFormField(
                controller: _fechaNacimientoController,
                decoration: const InputDecoration(
                    labelText: 'Fecha de Nacimiento (DD/MM/YYYY)'),
                onTap: () {
                  _selectDate(context);
                },
              ),
              TextFormField(
                controller: _gradoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Grado'),
              ),
              TextFormField(
                controller: _grupoController,
                maxLength: 1,
                decoration: const InputDecoration(labelText: 'Grupo'),
              ),
              TextFormField(
                controller: _gravedadController,
                decoration: const InputDecoration(labelText: 'Gravedad'),
              ),
              ElevatedButton(
                onPressed: () {
                  _registrarNino();
                },
                child: const Text('Registrar Niño'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
