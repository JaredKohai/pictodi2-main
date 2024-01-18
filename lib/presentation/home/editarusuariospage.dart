import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditarUsuarioPage extends StatefulWidget {
  final String category;
  final String docId;

  EditarUsuarioPage({required this.category, required this.docId});

  @override
  _EditarUsuarioPageState createState() => _EditarUsuarioPageState();
}

class _EditarUsuarioPageState extends State<EditarUsuarioPage> {
  late TextEditingController _nombreController;
  late TextEditingController _gradoController;
  late TextEditingController _grupoController;

  String? _permiso;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController();
    _gradoController = TextEditingController();
    _grupoController = TextEditingController();

    // Lógica para obtener el permiso del usuario
    _obtenerPermiso();
  }

  Future<void> _obtenerPermiso() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection(widget.category)
          .doc(widget.docId)
          .get();

      if (documentSnapshot.exists) {
        setState(() {
          _permiso = documentSnapshot.get('permiso');
          // Obtener otros datos del usuario y asignarlos a los controladores
          _nombreController.text = documentSnapshot.get('nombre').toString();
          _gradoController.text = documentSnapshot.get('grado').toString();
          _grupoController.text = documentSnapshot.get('grupo').toString();
        });
      }
    } catch (e) {
      print('Error al obtener el permiso: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_permiso !=
                  'padre') // Mostrar solo si el permiso no es "padre"
                TextFormField(
                  controller: _nombreController,
                  decoration: InputDecoration(labelText: 'Nombre'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo vacío';
                    }
                    return null;
                  },
                ),
              if (_permiso !=
                  'padre') // Mostrar solo si el permiso no es "padre"
                TextFormField(
                  controller: _gradoController,
                  decoration: InputDecoration(labelText: 'Grado'),
                  maxLength: 1,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo vacío';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Solo se permite un número';
                    }
                    return null;
                  },
                ),
              if (_permiso !=
                  'padre') 
                TextFormField(
                  controller: _grupoController,
                  decoration: InputDecoration(labelText: 'Grupo'),
                  maxLength: 1,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo vacío';
                    }
                    if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                      return 'Solo se permite una letra';
                    }
                    return null;
                  },
                ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Validar el formulario antes de guardar los cambios
                  if (_formKey.currentState?.validate() ?? false) {
                    // Lógica para guardar los cambios según el permiso
                    _guardarCambios();
                  }
                },
                child: Text('Guardar Cambios'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _guardarCambios() async {
    // Lógica para guardar cambios en Firestore según el permiso
    try {
      // Obtener los datos del formulario y actualizar Firestore
      String nuevoNombre = _nombreController.text;
      String nuevoGrado = _gradoController.text;
      String nuevoGrupo = _grupoController.text;

      // Actualizar los campos correspondientes según el permiso
      if (_permiso == 'profesor' ||
          _permiso == 'nino' ||
          _permiso == 'psicologo') {
        await FirebaseFirestore.instance
            .collection(widget.category)
            .doc(widget.docId)
            .update({
          'nombre': nuevoNombre,
          'grado': nuevoGrado,
          'grupo': nuevoGrupo,
        });
      } else if (_permiso == 'padre') {
        await FirebaseFirestore.instance
            .collection(widget.category)
            .doc(widget.docId)
            .update({
          'nombre': nuevoNombre,
        });
      }

      // Cerrar la página después de guardar cambios
      Navigator.pop(context);
    } catch (e) {
      print('Error al guardar cambios: $e');
    }
  }
}
