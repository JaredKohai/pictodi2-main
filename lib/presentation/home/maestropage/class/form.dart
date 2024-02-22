import 'package:flutter/material.dart';

// Enum para representar los tipos de actividad
enum TipoActividad { Memorama, Unir, SeleccionaOpcion }

class CustomForm extends StatefulWidget {
  @override
  _CustomFormState createState() => _CustomFormState();
}

class _CustomFormState extends State<CustomForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController classNameController = TextEditingController();
  TextEditingController teacherNameController = TextEditingController();
  TextEditingController gradeController = TextEditingController();
  TextEditingController groupController = TextEditingController();
  TipoActividad?
      selectedActividad; // Variable para almacenar el tipo de actividad seleccionada

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildDropdownField(
                labelText: 'Tipo de Actividad',
                value: selectedActividad,
                onChanged: (value) {
                  setState(() {
                    selectedActividad = value as TipoActividad?;
                  });
                },
                items: TipoActividad.values
                    .map((tipo) => DropdownMenuItem(
                          value: tipo,
                          child: Text(_getActividadLabel(tipo)),
                        ))
                    .toList(),
              ),
              _buildTextField(
                controller: classNameController,
                labelText: 'Clase',
                icon: Icons.school,
              ),
              _buildTextField(
                controller: teacherNameController,
                labelText: 'Profesor',
                icon: Icons.person,
              ),
              _buildTextField(
                controller: gradeController,
                labelText: 'Grado',
                icon: Icons.grade,
              ),
              _buildTextField(
                controller: groupController,
                labelText: 'Grupo',
                icon: Icons.group,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Realiza acciones con los datos del formulario
                    print('Datos enviados:');
                    print(
                        'Tipo de Actividad: ${_getActividadLabel(selectedActividad)}');
                    print('Clase: ${classNameController.text}');
                    print('Profesor: ${teacherNameController.text}');
                    print('Grado: ${gradeController.text}');
                    print('Grupo: ${groupController.text}');
                    // Redirige al formulario correspondiente según el tipo de actividad seleccionado
                    _navigateToNextForm();
                  }
                },
                child: Text('Enviar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Método para construir un campo de texto
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor, ingresa $labelText';
          }
          return null;
        },
      ),
    );
  }

  // Método para construir un campo de selección (Dropdown)
  Widget _buildDropdownField({
    required String labelText,
    required dynamic value,
    required Function(dynamic?) onChanged,
    required List<DropdownMenuItem<dynamic>> items,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField(
        value: value,
        onChanged: onChanged as void Function(dynamic?)?,
        items: items,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null) {
            return 'Por favor, selecciona el $labelText';
          }
          return null;
        },
      ),
    );
  }

  // Método para obtener la etiqueta de un tipo de actividad
  String _getActividadLabel(TipoActividad? tipo) {
    switch (tipo) {
      case TipoActividad.Memorama:
        return 'Memorama';
      case TipoActividad.Unir:
        return 'Unir';
      case TipoActividad.SeleccionaOpcion:
        return 'Selecciona la opción correcta';
      default:
        return '';
    }
  }

  // Método para navegar al formulario correspondiente según el tipo de actividad seleccionado
  void _navigateToNextForm() {
    switch (selectedActividad) {
      case TipoActividad.Memorama:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MemoramaForm()),
        );
        break;
      case TipoActividad.Unir:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UnirForm()),
        );
        break;
      case TipoActividad.SeleccionaOpcion:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SeleccionaOpcionForm()),
        );
        break;
      default:
        break;
    }
  }
}

// Formulario para la actividad Memorama
// Formulario para la actividad Memorama
// Formulario para la actividad Memorama
class MemoramaForm extends StatefulWidget {
  @override
  _MemoramaFormState createState() => _MemoramaFormState();
}

class _MemoramaFormState extends State<MemoramaForm> {
  List<String> fichas = [];
  TextEditingController preguntaController = TextEditingController();
  TextEditingController tituloController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Memorama Form'),
      ),
      body: ListView(
        children: [
          TextField(
            controller: tituloController,
            decoration: InputDecoration(labelText: 'Título'),
          ),
          TextField(
            controller: preguntaController,
            decoration: InputDecoration(labelText: 'Pregunta'),
          ),
          for (int i = 0; i < fichas.length; i++)
            ListTile(
              title: Text('Ficha ${i + 1}: ${fichas[i]}'),
            ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                fichas.add('Ficha ${fichas.length + 1}');
              });
            },
            child: Text('Añadir Ficha'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (fichas.isNotEmpty) {
                  fichas.removeLast();
                }
              });
            },
            child: Text('Quitar Última Ficha'),
          ),
        ],
      ),
    );
  }
}

// Formulario para la actividad Unir
class UnirForm extends StatefulWidget {
  @override
  _UnirFormState createState() => _UnirFormState();
}

class _UnirFormState extends State<UnirForm> {
  List<String> izquierda = [];
  List<String> derecha = [];
  TextEditingController preguntaController = TextEditingController();
  TextEditingController tituloController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Unir Form'),
      ),
      body: ListView(
        children: [
          TextField(
            controller: tituloController,
            decoration: InputDecoration(labelText: 'Título'),
          ),
          TextField(
            controller: preguntaController,
            decoration: InputDecoration(labelText: 'Pregunta'),
          ),
          for (int i = 0; i < izquierda.length; i++)
            ListTile(
              title: Text('Izquierda ${i + 1}: ${izquierda[i]}'),
            ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                izquierda.add('Izquierda ${izquierda.length + 1}');
              });
            },
            child: Text('Añadir a la Izquierda'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (izquierda.isNotEmpty) {
                  izquierda.removeLast();
                }
              });
            },
            child: Text('Quitar Última Izquierda'),
          ),
          for (int i = 0; i < derecha.length; i++)
            ListTile(
              title: Text('Derecha ${i + 1}: ${derecha[i]}'),
            ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                derecha.add('Derecha ${derecha.length + 1}');
              });
            },
            child: Text('Añadir a la Derecha'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (derecha.isNotEmpty) {
                  derecha.removeLast();
                }
              });
            },
            child: Text('Quitar Última Derecha'),
          ),
        ],
      ),
    );
  }
}

// Formulario para la actividad Selecciona la opción correcta
class SeleccionaOpcionForm extends StatefulWidget {
  @override
  _SeleccionaOpcionFormState createState() => _SeleccionaOpcionFormState();
}

class _SeleccionaOpcionFormState extends State<SeleccionaOpcionForm> {
  List<String> opciones = [];
  TextEditingController preguntaController = TextEditingController();
  TextEditingController tituloController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selecciona Opción Form'),
      ),
      body: ListView(
        children: [
          TextField(
            controller: tituloController,
            decoration: InputDecoration(labelText: 'Título'),
          ),
          TextField(
            controller: preguntaController,
            decoration: InputDecoration(labelText: 'Pregunta'),
          ),
          for (int i = 0; i < opciones.length; i++)
            ListTile(
              title: Text('Opción ${i + 1}: ${opciones[i]}'),
            ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                opciones.add('Opción ${opciones.length + 1}');
              });
            },
            child: Text('Añadir Opción'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (opciones.isNotEmpty) {
                  opciones.removeLast();
                }
              });
            },
            child: Text('Quitar Última Opción'),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CustomForm(),
  ));
}
