import 'package:flutter/material.dart';
import '../settings/register.dart';

class AnadirMaestroPage extends StatefulWidget {
  final String instituto;

  AnadirMaestroPage({required this.instituto});

  @override
  _AnadirMaestroPageState createState() => _AnadirMaestroPageState();
}

class _AnadirMaestroPageState extends State<AnadirMaestroPage> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _gradoController = TextEditingController();
  final TextEditingController _grupoController = TextEditingController();

  List<String> _asignaturasSeleccionadas = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Añadir Maestro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nombreController,
              decoration: InputDecoration(labelText: 'Nombre del Maestro'),
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Correo del Maestro'),
            ),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Contraseña del Maestro'),
            ),
            TextFormField(
              controller: _gradoController,
              decoration: InputDecoration(labelText: 'Grado del Maestro'),
            ),
            TextFormField(
              controller: _grupoController,
              decoration: InputDecoration(labelText: 'Grupo del Maestro'),
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(labelText: 'Asignaturas'),
              onTap: () async {
                List<String>? result = await showDialog(
                  context: context,
                  builder: (context) => AsignaturasDialog(),
                );

                if (result != null) {
                  setState(() {
                    _asignaturasSeleccionadas = result;
                  });
                }
              },
            ),
            ElevatedButton(
              onPressed: () {
                _confirmarDatos();
              },
              child: const Text('Registrar Maestro'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmarDatos() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar Datos'),
          content: Column(
            children: [
              Text('Nombre: ${_nombreController.text}'),
              Text('Correo: ${_emailController.text}'),
              Text('Contraseña: ${_passwordController.text}'),
              Text('Grado: ${_gradoController.text}'),
              Text('Grupo: ${_grupoController.text}'),
              Text('Asignaturas: ${_asignaturasSeleccionadas.join(', ')}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el cuadro de diálogo
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el cuadro de diálogo
                _registrarMaestro(); // Registrar el maestro
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  void _registrarMaestro() {
    Crear().registerProfesor(
      _emailController.text,
      _passwordController.text,
      _nombreController.text,
      _gradoController.text,
      _grupoController.text,
      _asignaturasSeleccionadas,
      instituto: widget.instituto,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Maestro registrado con éxito!'),
      ),
    );

    // Puedes agregar más lógica aquí, como navegar a otra página.
  }
}

class AsignaturasDialog extends StatefulWidget {
  @override
  _AsignaturasDialogState createState() => _AsignaturasDialogState();
}

class _AsignaturasDialogState extends State<AsignaturasDialog> {
  List<String> _asignaturas = [];
  List<String> _asignaturasSeleccionadas = [];

  @override
  void initState() {
    _asignaturas = ['Matemáticas', 'Ciencias', 'Español', 'Sociocultura'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Selecciona Asignaturas'),
      content: MultiSelectChip(
        items: _asignaturas,
        selectedItems: _asignaturasSeleccionadas,
        onSelectionChanged: (selectedAsignaturas) {
          setState(() {
            _asignaturasSeleccionadas = selectedAsignaturas;
          });
        },
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(_asignaturasSeleccionadas);
          },
          child: Text('Aceptar'),
        ),
      ],
    );
  }
}

class MultiSelectChip extends StatefulWidget {
  final List<String> items;
  final List<String> selectedItems;
  final ValueChanged<List<String>>? onSelectionChanged;

  MultiSelectChip({
    required this.items,
    required this.selectedItems,
    this.onSelectionChanged,
  });

  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }

  List<Widget> _buildChoiceList() {
    List<Widget> choices = [];
    widget.items.forEach((item) {
      choices.add(
        ChoiceChip(
          label: Text(item),
          selected: widget.selectedItems.contains(item),
          onSelected: (selected) {
            setState(() {
              widget.selectedItems.contains(item)
                  ? widget.selectedItems.remove(item)
                  : widget.selectedItems.add(item);
              widget.onSelectionChanged?.call(widget.selectedItems);
            });
          },
        ),
      );
    });
    return choices;
  }
}
