import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MemoramaPage extends StatefulWidget {
  final String nombre;
  final String instituto;
  final String grado;
  final String grupo;
  final String nombreMateria;
  final List<String> asignaturas;

  MemoramaPage({
    required this.nombre,
    required this.instituto,
    required this.grado,
    required this.grupo,
    required this.nombreMateria,
    required this.asignaturas,
  });

  @override
  _MemoramaPageState createState() => _MemoramaPageState();
}

class _MemoramaPageState extends State<MemoramaPage> {
  late Future<List<Pictogram>> _futurePictograms;
  List<String> _selectedImages = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _futurePictograms = _getPictograms();
  }

  Future<List<Pictogram>> _getPictograms() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('pictograms').get();

    List<Pictogram> pictograms = [];
    querySnapshot.docs.forEach((doc) {
      var data = doc.data();
      if (data != null) {
        pictograms.add(Pictogram.fromMap(data as Map<String, dynamic>));
      }
    });

    return pictograms;
  }

  List<Pictogram> _filterPictograms(List<Pictogram> pictograms, String query) {
    return pictograms
        .where((pictogram) =>
            pictogram.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Widget _buildImageItem(Pictogram pictogram) {
    bool isSelected = _selectedImages.contains(pictogram.imageUrl);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_selectedImages.contains(pictogram.imageUrl)) {
            _selectedImages.remove(pictogram.imageUrl);
          } else {
            if (_selectedImages.length < 5) {
              _selectedImages.add(pictogram.imageUrl);
            } else {
              // Aquí puedes mostrar un mensaje de error si se seleccionan más de 5 imágenes
            }
          }
        });
      },
      child: Card(
        elevation: 3,
        child: Stack(
          children: [
            Image.network(
              pictogram.imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            if (isSelected)
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 64,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selección de Imágenes para Memoramas'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context, _selectedImages);
            },
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar por título...',
                hintStyle: TextStyle(color: Colors.black54),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              style:
                  TextStyle(color: Colors.black), // Estilo del texto ingresado
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Pictogram>>(
              future: _futurePictograms,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  List<Pictogram> allPictograms = snapshot.data ?? [];
                  List<Pictogram> filteredPictograms =
                      _filterPictograms(allPictograms, _searchController.text);
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1,
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10.0,
                    ),
                    itemCount: filteredPictograms.length,
                    itemBuilder: (context, index) {
                      return _buildImageItem(filteredPictograms[index]);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Pictogram {
  final String author;
  final String category;
  final String description;
  final String imageUrl;
  final String title;

  Pictogram({
    required this.author,
    required this.category,
    required this.description,
    required this.imageUrl,
    required this.title,
  });

  factory Pictogram.fromMap(Map<String, dynamic> map) {
    return Pictogram(
      author: map['author'] ?? '',
      category: map['category'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      title: map['title'] ?? '',
    );
  }
}
