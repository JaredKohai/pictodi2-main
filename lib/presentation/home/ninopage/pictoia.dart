import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stability_image_generation/stability_image_generation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class PictoIA extends StatelessWidget {
  const PictoIA({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const Test(title: 'PictoIA'),
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
  final String apiKey = 'sk-QQcBlMoLK4sAz1SOXYeyoIm8C3EsbZYsWoqs86RUZsnDfeMl';
  final ImageAIStyle imageAIStyle = ImageAIStyle.render3D;
  bool run = false;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  @override
  void dispose() {
    _queryController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

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
            children: <Widget>[
              Text(
                "Generador de Pictogramas",
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
                    hintText: 'Ingrese el texto aquí',
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
                  child: run
                      ? FutureBuilder<String>(
                          future: _generateImageAndUpload(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: const CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (snapshot.hasData) {
                              return GestureDetector(
                                onTap: () {
                                  _showEditDialog(snapshot.data!);
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(snapshot.data!),
                                ),
                              );
                            } else {
                              return Container();
                            }
                          },
                        )
                      : const Center(
                          child: Text(
                            'Ingrese el texto y presione "Generar" ',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
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
          String userQuery = _queryController.text;

          if (userQuery.isNotEmpty) {
            String fullQuery =
                '$userQuery En formato de pictograma minimalista';

            _queryController.text = fullQuery;

            setState(() {
              run = true;
            });
          } else {
            if (kDebugMode) {
              print('¡La consulta está vacía!');
            }
          }
        },
        tooltip: 'Generar',
        child: const Icon(Icons.gesture),
      ),
    );
  }

  Future<void> _showEditDialog(String imageUrl) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Pictograma'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: 'Título'),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Descripción'),
                ),
                TextField(
                  controller: _categoryController,
                  decoration: InputDecoration(labelText: 'Categoría'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                _saveEditedInfo(imageUrl);
                Navigator.of(context).pop();
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveEditedInfo(String imageUrl) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try {
      await _firestore.collection('Pictogramas').add({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'category': _categoryController.text,
        'image_url': imageUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _titleController.clear();
      _descriptionController.clear();
      _categoryController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pictograma editado y guardado en Firebase'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('Error al guardar en Firebase: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al guardar en Firebase'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<String> _generateImageAndUpload() async {
    Uint8List imageBytes = await _generate(
        '${_titleController.text} En formato de pictograma minimalista');

    // Convierte los bytes de la imagen a formato base64
    String base64Image = base64Encode(imageBytes);

    // Convierte la imagen de base64 a formato PNG
    Uint8List pngImage = await convertBase64ToPng(base64Image);

    // Guarda la imagen en Firebase Storage
    String imageUrl = await _uploadImageToStorage(pngImage);

    return imageUrl;
  }

  Future<Uint8List> _generate(String query) async {
    Uint8List image = await _ai.generateImage(
      apiKey: apiKey,
      imageAIStyle: imageAIStyle,
      prompt: query,
    );
    return image;
  }

  Future<String> _uploadImageToStorage(Uint8List pngImage) async {
    // Crea una referencia a Firebase Storage
    final Reference storageReference = FirebaseStorage.instance.ref().child(
        'pictogramas/${DateTime.now()}.png'); // Cambia el nombre del archivo según tus necesidades

    // Sube la imagen en formato PNG
    await storageReference.putData(pngImage);

    // Obtiene la URL de descarga de la imagen
    return await storageReference.getDownloadURL();
  }

  Future<Uint8List> convertByteDataToUint8List(ByteData byteData) async {
    return byteData.buffer.asUint8List();
  }

  Future<Uint8List> convertBase64ToPng(String base64Image) async {
    // Convierte la cadena base64 a bytes
    Uint8List bytes = base64.decode(base64Image);

    // Decodifica los bytes en una imagen
    ui.Image image = await decodeImageFromList(bytes);

    // Convierte la imagen a bytes en formato PNG
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = await convertByteDataToUint8List(byteData!);

    return pngBytes;
  }
}
