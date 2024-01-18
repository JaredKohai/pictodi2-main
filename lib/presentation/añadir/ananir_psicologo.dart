import 'package:flutter/material.dart';
import '../settings/register.dart';

class AnadirPsicologoPage extends StatefulWidget {
  final String instituto;

  AnadirPsicologoPage({required this.instituto});

  @override
  _AnadirPsicologoPageState createState() => _AnadirPsicologoPageState();
}

class _AnadirPsicologoPageState extends State<AnadirPsicologoPage> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _especialidadController = TextEditingController();
  final TextEditingController _gradoController = TextEditingController();
  final TextEditingController _grupoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Añadir Psicólogo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nombreController,
              decoration: InputDecoration(labelText: 'Nombre del Psicólogo'),
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Correo del Psicólogo'),
            ),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration:
                  InputDecoration(labelText: 'Contraseña del Psicólogo'),
            ),
            TextFormField(
              controller: _especialidadController,
              decoration:
                  InputDecoration(labelText: 'Especialidad del Psicólogo'),
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _gradoController,
                    decoration:
                        InputDecoration(labelText: 'Grado del Psicólogo'),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _grupoController,
                    decoration:
                        InputDecoration(labelText: 'Grupo del Psicólogo'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _registrarPsicologo();
              },
              child: const Text('Registrar Psicólogo'),
            ),
          ],
        ),
      ),
    );
  }

  void _registrarPsicologo() {
    if (_camposNoVacios() && _validarCampos()) {
      Crear().registerPsicologo(
        email: _emailController.text,
        password: _passwordController.text,
        nombre: _nombreController.text,
        especialidad: _especialidadController.text,
        grado: _gradoController.text,
        grupo: _grupoController.text,
        instituto: widget.instituto,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Psicólogo registrado correctamente'),
        ),
      );
    }
  }

  bool _camposNoVacios() {
    return _nombreController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _especialidadController.text.isNotEmpty &&
        _gradoController.text.isNotEmpty &&
        _grupoController.text.isNotEmpty;
  }

  bool _validarCampos() {
    // Puedes agregar más lógica de validación según tus requisitos
    return true;
  }
}
