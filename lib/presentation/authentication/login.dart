// ignore_for_file: unused_local_variable
//a
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pictodi2/presentation/home/ninopage.dart';
import 'forgotPassword.dart';
import '../home/director_pages.dart';
import '../home/profesor_page.dart';
import '../home/psicologo_page.dart';
import '../home/padre_page.dart';
import '../home/admin_page.dart';
import '../home/director_page.dart';
import '../home/maestro_page.dart';

class LoginPage extends StatefulWidget {
  final List asignaturas;
  const LoginPage({Key? key, this.asignaturas = const []}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late String diagnostico;
  late String fecha_nacimiento;
  late String grado;
  late String grupo;
  late String gravedad;
  late List<String> asignaturas = [];

  Future<void> _signIn(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        DocumentSnapshot userDoc;

        if (await FirebaseFirestore.instance
            .collection('directores')
            .doc(user.uid)
            .get()
            .then((value) => value.exists)) {
          userDoc = await FirebaseFirestore.instance
              .collection('directores')
              .doc(user.uid)
              .get();
        } else if (await FirebaseFirestore.instance
            .collection('profesores')
            .doc(user.uid)
            .get()
            .then((value) => value.exists)) {
          userDoc = await FirebaseFirestore.instance
              .collection('profesores')
              .doc(user.uid)
              .get();
        } else if (await FirebaseFirestore.instance
            .collection('padres')
            .doc(user.uid)
            .get()
            .then((value) => value.exists)) {
          userDoc = await FirebaseFirestore.instance
              .collection('padres')
              .doc(user.uid)
              .get();
        } else if (await FirebaseFirestore.instance
            .collection('psicologos')
            .doc(user.uid)
            .get()
            .then((value) => value.exists)) {
          userDoc = await FirebaseFirestore.instance
              .collection('psicologos')
              .doc(user.uid)
              .get();
        } else if (await FirebaseFirestore.instance
            .collection('niños')
            .doc(user.uid)
            .get()
            .then((value) => value.exists)) {
          userDoc = await FirebaseFirestore.instance
              .collection('niños')
              .doc(user.uid)
              .get();
        } else if (await FirebaseFirestore.instance
            .collection('admin')
            .doc(user.uid)
            .get()
            .then((value) => value.exists)) {
          userDoc = await FirebaseFirestore.instance
              .collection('admin')
              .doc(user.uid)
              .get();
        } else {
          // Manejar el caso cuando el usuario no pertenece a ninguna categoría conocida
          return;
        }

        if (userDoc.exists) {
          String permiso = userDoc['permiso'];
          String nombre = userDoc['nombre'];
          String instituto = userDoc['instituto'] ?? '';

          if (permiso == 'nino') {
            diagnostico = userDoc['diagnostico'];
            fecha_nacimiento = userDoc['fecha_nacimiento'];
            grado = userDoc['grado'];
            grupo = userDoc['grupo'];
            gravedad = userDoc['gravedad'];
          }

          if (permiso == 'profesor') {
            List<dynamic> asignaturasDynamic = userDoc['asignaturas'];
            asignaturas = asignaturasDynamic.map((e) => e.toString()).toList();
            grado = userDoc['grado'];
            grupo = userDoc['grupo'];
          }
          // Muestra el nombre del usuario
          print('¡Bienvenido, $nombre!');

          String loginname = nombre;

          // Redirige al usuario según su permiso
          if (permiso == 'director') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      DirectPage(nombre: nombre, instituto: instituto)),
            );
          } else if (permiso == 'profesor') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => MaestroPages(
                      nombre: nombre,
                      instituto: instituto,
                      asignaturas: asignaturas,
                      grado: grado,
                      grupo: grupo)),
            );
          } else if (permiso == 'padre') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => PadrePage(
                        nombre: nombre,
                      )),
            );
          } else if (permiso == 'psicologo') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => PsicologoPage(nombre: nombre)),
            );
          } else if (permiso == 'admin') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => AdminPage(nombre: nombre)),
            );
          } else if (permiso == 'nino') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePageKid(
                      nombre: nombre,
                      instituto: instituto,
                      diagnostico: diagnostico,
                      fecha_nacimiento: fecha_nacimiento,
                      grado: grado,
                      grupo: grupo,
                      gravedad: gravedad)),
            );
          }
        }
      }
    } catch (e) {
      // Manejo de errores durante el inicio de sesión
      print('Error al iniciar sesión: $e');

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content:
            Text('Datos invalidos, por favor revise el correo o su contraseña'),
        duration: Duration(seconds: 3),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 330,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    left: 30,
                    width: 80,
                    height: 290,
                    child: FadeInUp(
                      duration: const Duration(seconds: 1),
                      child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/light-1.png'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 230,
                    width: 80,
                    height: 620,
                    child: FadeInUp(
                      duration: const Duration(milliseconds: 1200),
                      child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/light-2.png'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 40,
                    top: 40,
                    width: 80,
                    height: 120,
                    child: FadeInUp(
                      duration: const Duration(milliseconds: 1300),
                      child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/clock.png'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    child: FadeInUp(
                      duration: const Duration(milliseconds: 1600),
                      child: Container(
                        margin: const EdgeInsets.only(top: 50),
                        child: const Center(
                          child: Text(
                            "PictoDi",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: <Widget>[
                  FadeInUp(
                    duration: const Duration(milliseconds: 1800),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color.fromRGBO(143, 148, 251, 1),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(143, 148, 251, .2),
                            blurRadius: 20.0,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Color.fromRGBO(143, 148, 251, 1),
                                ),
                              ),
                            ),
                            child: TextField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Correo Electronico",
                                hintStyle: TextStyle(color: Colors.grey[700]),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Contraseña",
                                hintStyle: TextStyle(color: Colors.grey[700]),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  FadeInUp(
                    duration: const Duration(milliseconds: 1900),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromRGBO(255, 255, 255, 1),
                            Color.fromRGBO(255, 255, 255, 0.6),
                          ],
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          _signIn(context);
                        },
                        child: const Center(
                          child: Text(
                            "Iniciar Sesión",
                            style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 70,
                  ),
                  FadeInUp(
                    duration: const Duration(milliseconds: 2000),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotPasswordPage()),
                        );
                      },
                      child: const Text("¿Olvidaste tu contraseña?",
                          style: TextStyle(
                            color: Color.fromRGBO(143, 148, 251, 1),
                          )),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
