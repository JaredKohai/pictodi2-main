import 'data/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'presentation/authentication/init.dart';
//import 'presentation/settings/register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //Crear registros = Crear();

  // Llamadas a funciones de registro (puedes descomentar y usar según sea necesario)
  //await registerProfesor("profesor@gmail.com", "123456", "Profesor Ejemplo", "1A", ["Matemáticas", "Ciencias"]);
  //await registerDirector("director@gmail.com", "123456", "Director Ejemplo", "jaredbastarracheas@gmail.com");
  //await registerNino("nino1@gmail.com", "123456", "Samuel Chim", "Sindrome de Down", "2015-05-05", 1, "leve", "C");
  //await registerPadre("padre1@gmail.com", "123456", "Jorge Magaña", ["2"], true);
  //await registerPsicologo("psicologo1@gmail.com", "123456", "Jaime", "Tratamiento Mental", "2C");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Init(),
    );
  }
}
