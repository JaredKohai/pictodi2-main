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

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Añadir Psicólogo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextFormField(
                controller: _nombreController,
                labelText: 'Nombre del Psicólogo',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa el nombre del Psicólogo';
                  }
                  return null;
                },
              ),
              _buildTextFormField(
                controller: _emailController,
                labelText: 'Correo del Psicólogo',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa el correo del Psicólogo';
                  }
                  if (!value.contains('@')) {
                    return 'Formato de correo no válido. Debe contener "@"';
                  }
                  return null;
                },
              ),
              _buildTextFormField(
                controller: _passwordController,
                labelText: 'Contraseña del Psicólogo',
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa la contraseña del Psicólogo';
                  }
                  if (value.length < 6) {
                    return 'La contraseña debe tener al menos 6 caracteres.';
                  }
                  return null;
                },
              ),
              _buildTextFormField(
                controller: _especialidadController,
                labelText: 'Especialidad del Psicólogo',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa la especialidad del Psicólogo';
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildTextFormField(
                      controller: _gradoController,
                      labelText: 'Grado del Psicólogo',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingresa el grado del Psicólogo';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildTextFormField(
                      controller: _grupoController,
                      labelText: 'Grupo del Psicólogo',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingresa el grupo del Psicólogo';
                        }
                        return null;
                      },
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
      ),
    );
  }

  void _registrarPsicologo() {
    if (_formKey.currentState?.validate() ?? false) {
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

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    TextInputType? keyboardType,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: labelText),
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validator,
      ),
    );
  }
}
