import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pictodi2/presentation/authentication/login.dart';

class PerfilPage extends StatefulWidget {
  final String nombre;
  final String instituto;

  const PerfilPage({
    Key? key,
    required this.nombre,
    required this.instituto,
  }) : super(key: key);

  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  File? _image;
  String? _profilePictureUrl;
  List<String> hijos = []; // Variable para almacenar la lista de hijos

  Future<void> _loadChildren() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot<Map<String, dynamic>> userData = await FirebaseFirestore
          .instance
          .collection('padres')
          .doc(userId)
          .get();

      setState(() {
        if (userData.exists) {
          hijos = List<String>.from(userData.data()?['hijos'] ?? []);
        } else {
          hijos = [];
        }
      });
    } catch (e) {
      print('Error loading children: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadChildren(); // Cargar la lista de hijos al iniciar la página
  }

  Future<void> _uploadProfilePicture() async {
    try {
      if (_image == null) {
        print('No image selected.');
        return;
      }

      String userId = FirebaseAuth.instance.currentUser!.uid;
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('profile/$userId/profile_picture.jpg');

      UploadTask uploadTask = ref.putFile(_image!);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('padres')
          .doc(userId)
          .update({'profilePicture': downloadUrl});

      setState(() {
        _profilePictureUrl = downloadUrl;
      });

      print('Profile picture uploaded successfully.');
    } catch (e) {
      print('Error uploading profile picture: $e');
    }
  }

  Future<void> _signOut() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      _prefs.remove('profileImagePath_$userId');

      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      print("Error al cerrar sesión: $e");
    }
  }

  Future getImageFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        String userId = FirebaseAuth.instance.currentUser!.uid;
        SharedPreferences.getInstance().then((prefs) {
          prefs.setString('profileImagePath_$userId', pickedFile.path);
        });
      } else {
        print('No image selected.');
      }
    });
  }

  Future getImageFromCamera() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        String userId = FirebaseAuth.instance.currentUser!.uid;
        SharedPreferences.getInstance().then((prefs) {
          prefs.setString('profileImagePath_$userId', pickedFile.path);
        });
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Perfil',
          style: GoogleFonts.openSans(),
        ),
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: _image != null
                          ? DecorationImage(
                              image: FileImage(_image!),
                              fit: BoxFit.cover,
                            )
                          : _profilePictureUrl != null
                              ? DecorationImage(
                                  image: NetworkImage(_profilePictureUrl!),
                                  fit: BoxFit.cover,
                                )
                              : DecorationImage(
                                  image: AssetImage('assets/profile_image.png'),
                                  fit: BoxFit.cover,
                                ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: GestureDetector(
                      child: const Icon(
                        Icons.camera_alt,
                        size: 30,
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Seleccionar imagen"),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    GestureDetector(
                                      child: Text("Galería"),
                                      onTap: () {
                                        getImageFromGallery();
                                        Navigator.pop(context);
                                      },
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                    ),
                                    GestureDetector(
                                      child: Text("Cámara"),
                                      onTap: () {
                                        getImageFromCamera();
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: ListView(
                    children: [
                      ListTile(
                        title: Text('Nombre',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(widget.nombre),
                      ),
                      ListTile(
                        title: Text('Institución',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(widget.instituto),
                      ),
                      ListTile(
                        title: Text('Hijos',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: hijos.map((hijo) => Text(hijo)).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _uploadProfilePicture,
                child: Text('Guardar imagen de perfil'),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _signOut,
                icon: const Icon(Icons.logout,
                    size: 24, color: Color.fromARGB(255, 255, 255, 255)),
                label: Text(
                  'Cerrar sesión',
                  style: GoogleFonts.openSans().copyWith(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
