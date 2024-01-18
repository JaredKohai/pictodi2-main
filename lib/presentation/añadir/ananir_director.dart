import 'package:flutter/material.dart';
import '../settings/register.dart';

class RegisterDirectorPage extends StatefulWidget {
  @override
  _RegisterDirectorPageState createState() => _RegisterDirectorPageState();
}

class _RegisterDirectorPageState extends State<RegisterDirectorPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();

  // Agrega más campos según tus necesidades

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Director'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Correo Electrónico'),
            ),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Contraseña'),
            ),
            TextFormField(
              controller: _nombreController,
              decoration: InputDecoration(labelText: 'Nombre del Director'),
            ),
            TextFormField(
              controller: _correoController,
              decoration: InputDecoration(labelText: 'Correo del Director'),
            ),
            // Puedes agregar más TextFormField para otros campos

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _registrarDirector();
              },
              child: Text('Registrar Director'),
            ),
          ],
        ),
      ),
    );
  }

  void _registrarDirector() {
    if (_camposNoVacios()) {
      Crear().registerDirector(
        _emailController.text,
        _passwordController.text,
        _nombreController.text,
        _correoController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Director registrado exitosamente.'),
        ),
      );

      // Puedes agregar más lógica aquí, como navegar a otra página.
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, rellena todos los campos.'),
        ),
      );
    }
  }

  bool _camposNoVacios() {
    return _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _nombreController.text.isNotEmpty &&
        _correoController.text.isNotEmpty;
    // Agrega más validaciones según tus necesidades
  }
}
