import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Enum para representar los tipos de actividad
enum TipoActividad { Memorama, Unir, SeleccionaOpcion }

class CustomForm extends StatefulWidget {
  @override
  _CustomFormState createState() => _CustomFormState();
}

class _CustomFormState extends State<CustomForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController titleNameController = TextEditingController();
  TextEditingController teacherNameController = TextEditingController();
  TextEditingController gradeController = TextEditingController();
  TextEditingController groupController = TextEditingController();
  TextEditingController materiaController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime? selectedDate; // Nueva variable para almacenar la fecha seleccionada
  TipoActividad? selectedActividad;

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
          child: SingleChildScrollView(
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
                  controller: titleNameController,
                  labelText: 'Titulo',
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
                _buildTextField(
                  controller: materiaController,
                  labelText: 'Materia',
                  icon: Icons.book,
                ),
                _buildTextField(
                  controller: descriptionController,
                  labelText: 'Descripción',
                  icon: Icons.description,
                ),
                _buildDateField(), // Nuevo campo para seleccionar la fecha
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _saveDataToFirestore();
                    }
                  },
                  child: Text('Enviar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

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

  Widget _buildDropdownField({
    required String labelText,
    required dynamic value,
    required Function(dynamic) onChanged,
    required List<DropdownMenuItem<dynamic>> items,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField(
        value: value,
        onChanged: onChanged as void Function(dynamic)?,
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

  Widget _buildDateField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: () {
          _selectDate(context);
        },
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: 'Fecha de Vencimiento',
            prefixIcon: Icon(Icons.calendar_today),
            border: OutlineInputBorder(),
          ),
          child: Text(
            selectedDate != null
                ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                : 'Selecciona una fecha',
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  void _saveDataToFirestore() async {
    String titulo = titleNameController.text;
    String instrucciones = descriptionController.text;
    String tipoActividad = _getActividadLabel(selectedActividad);
    String evaluacion = gradeController.text;
    String fecha = groupController.text;
    String grado = gradeController.text;
    String grupo = groupController.text;
    String materia = materiaController.text;

    // Obtén la fecha de vencimiento del controlador
    DateTime? fechaVencimiento = selectedDate;

    // Registrar la actividad con la fecha de vencimiento
    await FirebaseFirestore.instance.collection('actividades').add({
      'titulo': titulo,
      'instrucciones': instrucciones,
      'tipo': tipoActividad,
      'evaluacion': evaluacion,
      'fecha': fecha,
      'grado': grado,
      'grupo': grupo,
      'alumnos': [], // Aquí debes usar la lista de identificadores de alumnos
      'finalizado': false,
      'materia': materia,
      'fecha_vencimiento': fechaVencimiento, // Añadir la fecha de vencimiento
    });

    // Limpiar los campos después de guardar los datos
    titleNameController.clear();
    teacherNameController.clear();
    gradeController.clear();
    groupController.clear();
    materiaController.clear();
    descriptionController.clear();
    selectedDate = null; // Limpiar la fecha seleccionada

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Datos guardados correctamente en Firestore.'),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CustomForm(),
  ));
}
