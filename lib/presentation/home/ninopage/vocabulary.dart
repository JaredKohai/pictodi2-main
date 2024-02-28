import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(const PageVocabulary());
}

class PageVocabulary extends StatelessWidget {
  const PageVocabulary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Vocabulary(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Vocabulary extends StatefulWidget {
  const Vocabulary({Key? key}) : super(key: key);

  @override
  State<Vocabulary> createState() => _VocabularyState();
}

class _VocabularyState extends State<Vocabulary> {
  TextEditingController _searchController = TextEditingController();
  bool _showDashboard = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          const SizedBox(
            height: 60,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      'Mi Vocabulario',
                      style: GoogleFonts.openSans(
                          textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar...',
                filled: true,
                fillColor: Colors.white,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                prefixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _showDashboard = _searchController.text.isEmpty;
                    });
                  },
                  icon: const Icon(Icons.search),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _showDashboard = value.isEmpty;
                });
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          if (_showDashboard) VocabularyDashboard(),
          if (!_showDashboard)
            Expanded(
              child: FilteredPictogramList(searchText: _searchController.text),
            ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class VocabularyDashboard extends StatelessWidget {
  Items item1 = Items(title: "Comida", img: "assets/burger.png");
  Items item2 = Items(title: "Animales", img: "assets/pet.png");
  Items item4 = Items(title: "Higiene", img: "assets/hygiene-routine.png");
  Items item5 = Items(title: "Deportes", img: "assets/training.png");
  Items item6 = Items(title: "Reglas", img: "assets/rule.png");
  Items item7 = Items(title: "Escuela", img: "assets/stationery.png");
  Items item8 = Items(title: "Arte", img: "assets/art.png");
  Items item9 = Items(title: "Naturaleza", img: "assets/forest.png");

  VocabularyDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Items> myList = [
      item1,
      item2,
      item4,
      item5,
      item6,
      item7,
      item8,
      item9
    ];

    return Flexible(
      child: GridView.count(
        childAspectRatio: 1.0,
        padding: const EdgeInsets.only(left: 16, right: 16),
        crossAxisCount: 2,
        crossAxisSpacing: 18,
        mainAxisSpacing: 18,
        children: myList.map((data) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EmptyPage(
                    category: data.title,
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    data.img,
                    width: 42,
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  Text(
                    data.title,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class Items {
  String title;
  String img;

  Items({required this.title, required this.img});
}

class FilteredPictogramList extends StatelessWidget {
  final String searchText;

  const FilteredPictogramList({required this.searchText});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getPictogramsBySearch(searchText),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          ); // Show a loading indicator while fetching data
        } else {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            ); // Show error message if data fetching fails
          } else {
            List<Pictogram> pictograms = snapshot.data ?? [];
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Two columns
                childAspectRatio:
                    0.7, // Aspect ratio of 0.7 for better appearance
                mainAxisSpacing: 10.0, // Spacing between rows
                crossAxisSpacing: 10.0, // Spacing between columns
              ),
              itemCount: pictograms.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    showPictogramDetails(context, pictograms[index]);
                  },
                  child: Card(
                    elevation: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Image.network(
                            pictograms[index].imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            pictograms[index].title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            pictograms[index].description,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        }
      },
    );
  }

  Future<List<Pictogram>> getPictogramsBySearch(String searchText) async {
    String searchTextLower = searchText.toLowerCase();
    String searchTextCapitalized = searchTextLower.isNotEmpty
        ? searchTextLower[0].toUpperCase() + searchTextLower.substring(1)
        : '';

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('pictograms')
        .where('title', isEqualTo: searchTextLower)
        .get();

    List<Pictogram> pictograms = [];
    querySnapshot.docs.forEach((doc) {
      var data = doc.data();
      if (data != null) {
        pictograms.add(Pictogram.fromMap(data as Map<String, dynamic>));
      }
    });

    // Si no se encontraron resultados con la palabra en minúscula, realizar una nueva consulta con la palabra capitalizada
    if (pictograms.isEmpty) {
      QuerySnapshot querySnapshotCapitalized = await FirebaseFirestore.instance
          .collection('pictograms')
          .where('title', isEqualTo: searchTextCapitalized)
          .get();

      querySnapshotCapitalized.docs.forEach((doc) {
        var data = doc.data();
        if (data != null) {
          pictograms.add(Pictogram.fromMap(data as Map<String, dynamic>));
        }
      });
    }

    return pictograms;
  }

  void showPictogramDetails(BuildContext context, Pictogram pictogram) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(
                pictogram.imageUrl,
                height: 200, // Set the height of the image
                width:
                    double.infinity, // Set the width to fill the entire screen
                fit: BoxFit.cover, // Ensure the image covers the entire space
              ),
              SizedBox(height: 16),
              Text(
                'Title: ${pictogram.title}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Description: ${pictogram.description}',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Author: ${pictogram.author}',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Category: ${pictogram.category}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // To be implemented: Add save functionality
                },
                child: Text("Guardar"),
              ),
            ],
          ),
        );
      },
    );
  }
}

class EmptyPage extends StatelessWidget {
  final String category;

  const EmptyPage({required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
      ),
      body: FutureBuilder(
        future: getPictograms(category),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            ); // Show a loading indicator while fetching data
          } else {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              ); // Show error message if data fetching fails
            } else {
              List<Pictogram> pictograms = snapshot.data ?? [];
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Two columns
                  childAspectRatio:
                      0.7, // Aspect ratio of 0.7 for better appearance
                  mainAxisSpacing: 10.0, // Spacing between rows
                  crossAxisSpacing: 10.0, // Spacing between columns
                ),
                itemCount: pictograms.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      showPictogramDetails(context,
                          pictograms[index]); // Show pictogram details on tap
                    },
                    child: Card(
                      elevation: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Image.network(
                              pictograms[index].imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              pictograms[index].title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              pictograms[index].description,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }

  void showPictogramDetails(BuildContext context, Pictogram pictogram) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(
                pictogram.imageUrl,
                height: 200, // Set the height of the image
                width:
                    double.infinity, // Set the width to fill the entire screen
                fit: BoxFit.cover, // Ensure the image covers the entire space
              ),
              SizedBox(height: 16),
              Text(
                'Title: ${pictogram.title}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Description: ${pictogram.description}',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Author: ${pictogram.author}',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Category: ${pictogram.category}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // To be implemented: Add save functionality
                },
                child: Text("Guardar"),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<List<Pictogram>> getPictograms(String category) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('pictograms')
        .where('category', isEqualTo: category)
        .get();

    List<Pictogram> pictograms = [];
    querySnapshot.docs.forEach((doc) {
      var data = doc.data();
      if (data != null) {
        pictograms.add(Pictogram.fromMap(data as Map<String, dynamic>));
      }
    });

    return pictograms;
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
