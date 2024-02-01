import 'dart:typed_data';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stability_image_generation/stability_image_generation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const GeneradorIA());
}

class GeneradorIA extends StatelessWidget {
  const GeneradorIA({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const Test(title: 'Generador de Pictogramas con IA'),
    );
  }
}

class Test extends StatefulWidget {
  final String title;

  const Test({Key? key, required this.title}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  final TextEditingController _queryController = TextEditingController();
  final StabilityAI _ai = StabilityAI();
  final String apiKey = 'sk-4Ur70Hm5zWqp5qnnTDNlxQCFuCmIFR9y3rXNVfWFXMLcVV2m';
  final ImageAIStyle imageAIStyle = ImageAIStyle.sovietCartoon;
  bool run = false;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _category = 'Comida';
  final TextEditingController _authorController = TextEditingController();

  late BuildContext
      _modalContext; // Variable para almacenar el contexto del modal

  @override
  Widget build(BuildContext context) {
    final double size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "Pictogramas",
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
              Container(
                width: double.infinity,
                height: 50,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                  border: Border.all(
                    width: 0.5,
                    color: Colors.grey.shade300,
                  ),
                ),
                child: TextField(
                  controller: _queryController,
                  decoration: InputDecoration(
                    hintText: 'Ingresar texto...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 8),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  height: size,
                  width: size,
                  child: GestureDetector(
                    onTap: () {
                      _showImageFormModal(context);
                    },
                    child: run
                        ? FutureBuilder<Uint8List>(
                            future: _generateImage(_queryController.text),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: const CircularProgressIndicator(),
                                );
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else if (snapshot.hasData) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.memory(snapshot.data!),
                                );
                              } else {
                                return Container();
                              }
                            },
                          )
                        : const Center(
                            child: Text(
                              'Resultados de busqueda',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          String query = _queryController.text;
          if (query.isNotEmpty) {
            setState(() {
              run = true;
            });
          } else {
            if (kDebugMode) {
              print('Query is empty !!');
            }
          }
        },
        tooltip: 'Generate',
        child: const Icon(Icons.gesture),
      ),
    );
  }

  Future<Uint8List> _generateImage(String query) async {
    try {
      Uint8List image = await _ai.generateImage(
        apiKey: apiKey,
        imageAIStyle: imageAIStyle,
        prompt: query,
      );

      return image;
    } catch (e) {
      print('Error generating image: $e');
      throw e;
    }
  }

  void _showImageFormModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        // Guarda el contexto del modal
        _modalContext = context;

        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Título',
                  ),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Descripción',
                  ),
                ),
                DropdownButtonFormField<String>(
                  value: _category,
                  onChanged: (value) {
                    setState(() {
                      _category = value!;
                    });
                  },
                  items: <String>[
                    'Comida',
                    'Animales',
                    'Higiene',
                    'Deportes',
                    'Reglas',
                    'Escuela',
                    'Arte',
                    'Naturaleza',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Categoría',
                  ),
                ),
                TextField(
                  controller: _authorController,
                  decoration: InputDecoration(
                    labelText: 'Autor',
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      Uint8List imageBytes =
                          await _generateImage(_queryController.text);

                      String title = _titleController.text;
                      String description = _descriptionController.text;
                      String category = _category;
                      String author = _authorController.text;

                      await _saveImage(
                        imageBytes,
                        title: title,
                        description: description,
                        category: category,
                        author: author,
                      );

                      Navigator.pop(context);
                    } catch (e) {
                      print('Error saving image and data: $e');
                      ScaffoldMessenger.of(_modalContext).showSnackBar(
                        SnackBar(
                          content: Text('Error al guardar la imagen.'),
                        ),
                      );
                    }
                  },
                  child: Text('Guardar'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _saveImage(
    Uint8List imageBytes, {
    required String title,
    required String description,
    required String category,
    required String author,
  }) async {
    try {
      final fileName =
          DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';
      final firebase_storage.Reference firebaseStorageRef = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('images')
          .child(fileName);

      await firebaseStorageRef.putData(imageBytes);

      String imageUrl = await firebaseStorageRef.getDownloadURL();

      // Guarda los datos del formulario en Firestore
      await FirebaseFirestore.instance.collection('pictograms').add({
        'title': title,
        'description': description,
        'category': category,
        'author': author,
        'imageUrl': imageUrl,
      });

      // Muestra un mensaje de éxito
      ScaffoldMessenger.of(_modalContext).showSnackBar(
        SnackBar(
          content:
              Text('Imagen y datos del formulario guardados correctamente.'),
        ),
      );
    } catch (e) {
      print('Error al guardar la imagen en Firebase Storage: $e');
      throw e;
    }
  }
}
