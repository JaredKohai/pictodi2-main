import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Crear {
  Future<void> registerProfesor(
    String email,
    String password,
    String nombre,
    String grado,
    String grupo,
    List<String> asignaturas, {
    required String instituto,
  }) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String userId = userCredential.user!.uid;

      await FirebaseFirestore.instance
          .collection('profesores')
          .doc(userId)
          .set({
        'id': userId,
        'nombre': nombre,
        'grado': grado,
        'grupo': grupo,
        'asignaturas': asignaturas,
        'permiso': 'profesor',
        'instituto': instituto, // Agregar el campo 'instituto'
      });

      print('Profesor registrado exitosamente.');
    } catch (e) {
      print('Error al registrar profesor: $e');
    }
  }

  Future<void> registerDirector(
      String email, String password, String nombre, String correo,
      {String? instituto}) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String userId = userCredential.user!.uid;

      await FirebaseFirestore.instance
          .collection('directores')
          .doc(userId)
          .set({
        'id': userId,
        'nombre': nombre,
        'correo': correo,
        'instituto': instituto,
        'permiso': 'director',
      });

      print('Director registrado exitosamente.');
    } catch (e) {
      print('Error al registrar director: $e');
    }
  }

  Future<void> registerNino(
      String email,
      String password,
      String nombre,
      String diagnostico,
      String fechaNacimiento,
      int grado,
      String grupos,
      String gravedad,
      [String? userId,
      String? instituto]) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String userId = userCredential.user!.uid;

      await FirebaseFirestore.instance.collection('niños').doc(userId).set({
        'id': userId,
        'nombre': nombre,
        'diagnostico': diagnostico,
        'fecha_nacimiento': fechaNacimiento,
        'grado': grado,
        'grupo': grupos,
        'gravedad': gravedad,
        'instituto': instituto,
        'permiso': 'nino',
      });

      print('Niño registrado exitosamente.');
    } catch (e) {
      print('Error al registrar niño: $e');
    }
  }

  Future<void> registerPadre(
      String email, String password, String nombre, List<String> hijos,
      {String? instituto}) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String userId = userCredential.user!.uid;

      await FirebaseFirestore.instance.collection('padres').doc(userId).set({
        'id': userId,
        'nombre': nombre,
        'hijos': hijos,
        'instituto': instituto,
        'permiso': 'padre',
      });

      print('Padre registrado exitosamente.');
    } catch (e) {
      print('Error al registrar padre: $e');
    }
  }

  Future<void> registerPsicologo({
    required String email,
    required String password,
    required String nombre,
    required String especialidad,
    required String grado,
    required String grupo,
    required String instituto,
  }) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String userId = userCredential.user!.uid;

      await FirebaseFirestore.instance
          .collection('psicologos')
          .doc(userId)
          .set({
            'id': userId,
            'nombre': nombre,
            'especialidad': especialidad,
            'grado': grado, // Nuevo campo 'grado'
            'grupo': grupo, // Nuevo campo 'grupo'
            'permiso': 'psicologo',
            'instituto': instituto,
          });

      print('Psicólogo registrado exitosamente.');
    } catch (e) {
      print('Error al registrar psicólogo: $e');
    }
  }


  Future<void> registerAdmin(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String userId = userCredential.user!.uid;

      await FirebaseFirestore.instance.collection('admins').doc(userId).set({
        'id': userId,
        'email': email,
        'permiso': 'admin',
      });

      print('Admin registrado exitosamente.');
    } catch (e) {
      print('Error al registrar admin: $e');
    }
  }
}
