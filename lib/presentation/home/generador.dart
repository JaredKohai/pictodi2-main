import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GeneradorPage extends StatefulWidget {
  const GeneradorPage({Key? key}) : super(key: key);

  @override
  _GeneradorPageState createState() => _GeneradorPageState();
}

class _GeneradorPageState extends State<GeneradorPage> {
  TextEditingController _searchController = TextEditingController();
  List<ImageResult> _imageResults = [];

  Future<void> _searchImages(String query) async {
    String apiKey = '41009551-dd8e2f45154bae5454fcea5ba';
    String apiUrl =
        'https://pixabay.com/api/?key=$apiKey&q=${Uri.encodeQueryComponent(query)}';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _imageResults = List.from(data['hits'])
              .map((result) => ImageResult.fromJson(result))
              .toList();
        });
      } else {
        print('Error al buscar imágenes: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al buscar imágenes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generador de Pictogramas'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Buscar imágenes',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    _searchImages(_searchController.text);
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _imageResults.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _showImageDetails(context, _imageResults[index]);
                  },
                  child: Hero(
                    tag: _imageResults[index].tags,
                    child: Image.network(
                      _imageResults[index].previewURL,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showImageDetails(BuildContext context, ImageResult imageResult) {
    TextEditingController _titleController = TextEditingController();
    TextEditingController _descriptionController = TextEditingController();

    _titleController.text = imageResult.tags;
    _descriptionController.text = 'Descripción de la imagen aquí...';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Detalles de la Imagen'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                imageResult.previewURL,
                fit: BoxFit.cover,
                height: 150,
              ),
              SizedBox(height: 10),
              Text('Título:'),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Ingrese el título',
                ),
              ),
              SizedBox(height: 10),
              Text('Descripción:'),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  hintText: 'Ingrese la descripción',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                String editedTitle = _titleController.text;
                String editedDescription = _descriptionController.text;

                // Subir imagen a Firebase Storage y guardar datos en Firestore
                await _saveDataToFirestore(
                    editedTitle, editedDescription, imageResult.previewURL);

                // Cerrar el cuadro de diálogo
                Navigator.pop(context);
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveDataToFirestore(
      String editedTitle, String editedDescription, String imageUrl) async {
    try {
      // Subir imagen a Firebase Storage y obtener la URL de descarga
      String downloadUrl = await _uploadImageToStorage(imageUrl);

      // Guardar datos en Firestore
      await FirebaseFirestore.instance.collection('images').add({
        'title': editedTitle,
        'description': editedDescription,
        'imageUrl': downloadUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });

      print('Datos guardados correctamente en Firestore.');
    } catch (error) {
      print('Error al guardar datos en Firestore: $error');
    }
  }

  Future<String> _uploadImageToStorage(String imageUrl) async {
    try {
      Reference storageReference =
          FirebaseStorage.instance.ref().child('images/${DateTime.now()}.png');

      // Subir la imagen al almacenamiento
      await storageReference
          .putData((await http.get(Uri.parse(imageUrl))).bodyBytes);

      // Obtener la URL de descarga de la imagen almacenada
      String downloadUrl = await storageReference.getDownloadURL();
      return downloadUrl;
    } catch (error) {
      print('Error al subir la imagen al almacenamiento: $error');
      throw error;
    }
  }
}

class ImageResult {
  final String tags;
  final String previewURL;

  ImageResult({required this.tags, required this.previewURL});

  factory ImageResult.fromJson(Map<String, dynamic> json) {
    return ImageResult(
      tags: json['tags'],
      previewURL: json['previewURL'],
    );
  }
}
