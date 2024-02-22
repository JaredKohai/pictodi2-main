import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ContainerOptions.dart';
import 'iagen.dart'; // Importa la página PagePictograms

void main() {
  
  runApp(const PagePictograms(nombre: '',));
}

class PagePictograms extends StatelessWidget {final String nombre;
  const PagePictograms({Key? key, required this.nombre}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const GeneratorPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class GeneratorPage extends StatefulWidget {
  const GeneratorPage({Key? key}) : super(key: key);
  
  get nombre => null;

  @override
  State<GeneratorPage> createState() => _GeneratorPageState();
}

class _GeneratorPageState extends State<GeneratorPage> {
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      GeneradorIA(), // Redirige a PagePictograms
                ),
              );
            },
            icon: const Icon(Icons.auto_fix_normal_sharp),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(
            height: 110,
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
                      'Generador de Pictogramas',
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
          GridDashboard()
        ],
      ),
    );
  }
}
