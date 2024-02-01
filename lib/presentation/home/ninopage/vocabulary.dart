import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'DashboardVocabulary.dart';

void main() {
  runApp(const PageVocabulary());
}

class PageVocabulary extends StatelessWidget {
  const PageVocabulary({super.key});

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
  const Vocabulary({super.key});

  @override
  State<Vocabulary> createState() => _VocabularyState();
}

class _VocabularyState extends State<Vocabulary> {
  TextEditingController _searchController = TextEditingController();

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
                    onPressed: () {}, icon: const Icon(Icons.search)),
              ),
              onChanged: (value) {
                // Puedes realizar acciones cuando el texto cambia
                // Por ejemplo, puedes filtrar una lista de resultados.
                // Ejemplo: filtrarLista(value);
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          VocabularyDashboard()
        ],
      ),
    );
  }
}
