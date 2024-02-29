import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'activities/memorama.dart'; // Importar la página Memorama
import 'activities/unir.dart'; // Importar la página Unir
import 'activities/seleccionar.dart'; // Importar la página Seleccionar

// Enum para representar los tipos de actividad
enum TipoActividad { Memorama, Unir, SeleccionaOpcion }

class CustomForm extends StatefulWidget {
  final String nombre;
  final String instituto;
  final String grado;
  final String grupo;
  final List<String> asignaturas;
  final String nombreMateria; // Nuevo parámetro para el nombre de la materia

  CustomForm({
    required this.nombre,
    required this.instituto,
    required this.grado,
    required this.grupo,
    required this.asignaturas,
    required this.nombreMateria, // Agregar el parámetro al constructor
  });

  @override
  _CustomFormState createState() => _CustomFormState();
}

class _CustomFormState extends State<CustomForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController titleNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime? selectedDate; // Nueva variable para almacenar la fecha seleccionada
  TipoActividad? selectedActividad;
  List<String> selectedImages = []; // Lista para almacenar las imágenes seleccionadas

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Profesor: ${widget.nombre}'),
            Text('Instituto: ${widget.instituto}'),
            Text('Grado: ${widget.grado}'),
            Text('Grupo: ${widget.grupo}'),
            Text(
                'Materia: ${widget.nombreMateria}'), // Mostrar el nombre de la materia
            SizedBox(height: 20),
            Form(
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
                      controller: descriptionController,
                      labelText: 'Descripción',
                      icon: Icons.description,
                    ),
                    _buildDateField(), // Nuevo campo para seleccionar la fecha
                    SizedBox(height: 20),
                    Visibility( // Agregar Visibility
                      visible: selectedActividad == TipoActividad.Memorama,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _navigateToSeleccionarPictogramas(context);
                          }
                        },
                        child: Text('Agregar los pictogramas'), // Cambiar el texto del botón
                      ),
                    ),
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
          ],
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

  void _navigateToSeleccionarPictogramas(BuildContext context) async {
    // Navegar a la página de selección de pictogramas
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MemoramaPage(
          nombre: widget.nombre,
          instituto: widget.instituto,
          grado: widget.grado,
          grupo: widget.grupo,
          nombreMateria: widget.nombreMateria,
          asignaturas: widget.asignaturas,
        ),
      ),
    );

    // Verificar si se seleccionaron imágenes
    if (result != null && result is List<String>) {
      setState(() {
        selectedImages = result;
      });
    }
  }

  void _saveDataToFirestore() async {
    String titulo = titleNameController.text;
    String instrucciones = descriptionController.text;
    String tipoActividad = _getActividadLabel(selectedActividad);
    String evaluacion = widget.grado;
    String fecha = widget.grupo;
    String grado = widget.grado;
    String grupo = widget.grupo;
    String materia =
        widget.nombreMateria; // Utilizar el nombre de la materia del widget
    String instituto = widget.instituto; // Obtener el valor del instituto

    // Obtén la fecha de vencimiento del controlador
    DateTime? fechaVencimiento = selectedDate;

    // Guardar las imágenes seleccionadas y el ID de la actividad de memorama
    DocumentReference actividadRef =
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
      'instituto': instituto, // Agregar el valor del Instituto
      'fecha_vencimiento': fechaVencimiento, // Añadir la fecha de vencimiento
      'imagenes_seleccionadas': selectedImages, // Guardar las imágenes seleccionadas
    });

    // Limpiar los campos después de guardar los datos
    titleNameController.clear();
    descriptionController.clear();
    selectedDate = null; // Limpiar la fecha seleccionada
    selectedImages.clear(); // Limpiar la lista de imágenes seleccionadas

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Datos guardados correctamente en Firestore.'),
      ),
    );
  }
}

class SeleccionarPictogramasPage extends StatefulWidget {
  @override
  _SeleccionarPictogramasPageState createState() => _SeleccionarPictogramasPageState();
}

class _SeleccionarPictogramasPageState extends State<SeleccionarPictogramasPage> {
  // Aquí puedes implementar la lógica para seleccionar los pictogramas

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seleccionar Pictogramas'),
      ),
      body: Center(
        child: Text('Página de selección de pictogramas'),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CustomForm(
      nombre: 'Nombre del profesor',
      instituto: 'Nombre del instituto',
      grado: 'Grado',
      grupo: 'Grupo',
      asignaturas: ['Asignatura 1', 'Asignatura 2'],
      nombreMateria: 'Nombre de la clase', // Pasar el nombre de la materia
    ),
  ));
}
