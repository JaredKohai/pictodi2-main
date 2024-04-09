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

  final String grado;
  final String grupo;

  const PerfilPage({
    Key? key,
    required this.nombre,
    required this.instituto,
    required this.grado,
    required this.grupo,
  }) : super(key: key);

  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  File? _image;
  String? _profilePictureUrl;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _initPrefs();
    _loadProfilePictureUrl();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      String? imagePath = _prefs.getString('profileImagePath_$userId');
      if (imagePath != null) {
        setState(() {
          _image = File(imagePath);
        });
      }
    }
  }

  Future<void> _loadProfilePictureUrl() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot<Map<String, dynamic>> userData = await FirebaseFirestore
          .instance
          .collection('profesores')
          .doc(userId)
          .get();

      setState(() {
        if (userData.exists) {
          _profilePictureUrl = userData.data()?['profilePicture'];
        } else {
          _profilePictureUrl = null;
        }
      });
    } catch (e) {
      print('Error loading profile picture URL: $e');
    }
  }

  Future getImageFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        String userId = FirebaseAuth.instance.currentUser!.uid;
        _prefs.setString('profileImagePath_$userId', pickedFile.path);
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
        _prefs.setString('profileImagePath_$userId', pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
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
          .collection('profesores')
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
      // Limpiar preferencias de la imagen de perfil al cerrar sesión
      String userId = FirebaseAuth.instance.currentUser!.uid;
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
                        title: Text('Grado y grupo que le da clases:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(widget.grado + widget.grupo),
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
                onPressed: () async {
                  try {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  } catch (e) {
                    print("Error al cerrar sesión: $e");
                  }
                },
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
