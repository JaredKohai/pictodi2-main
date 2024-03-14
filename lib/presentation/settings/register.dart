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
      // Verificar si el correo electrónico ya está en uso
      final existingUser =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      if (existingUser.isNotEmpty) {
        print('El correo electrónico ya está en uso.');
        return; // Salir del método si el correo ya está en uso
      }

      // Registrar al nuevo profesor si el correo es único
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
        'permiso': 'profesor', // Agregar el campo 'permiso'
        'instituto': instituto,
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
      String grado,
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

  Future<void> registerActividad({
    required String titulo,
    required String instrucciones,
    required String tipoActividad,
    required String grado,
    required String grupo,
    required String materia,
    required String instituto,
    required List<String> selectedImages,
  }) async {
    try {
      // Obtener la lista de alumnos con el mismo grado, grupo e instituto
      QuerySnapshot alumnosQuery = await FirebaseFirestore.instance
          .collection('niños')
          .where('grado', isEqualTo: grado)
          .where('grupo', isEqualTo: grupo)
          .where('instituto', isEqualTo: instituto)
          .get();

      // Crear una lista de identificadores de alumnos
      List<String> alumnosIds = [];
      alumnosQuery.docs.forEach((doc) {
        alumnosIds.add(doc.id);
      });

      // Registrar la actividad
      DocumentReference actividadDocRef =
          await FirebaseFirestore.instance.collection('actividades').add({
        'id': '', // Crear el campo 'id' vacío
        'titulo': titulo,
        'instrucciones': instrucciones,
        'tipo': tipoActividad,
        'grado': grado,
        'grupo': grupo,
        'alumnos': alumnosIds,
        'finalizado': false,
        'materia': materia,
        'instituto': instituto,
      });

      // Obtener el ID de la nueva actividad
      String actividadId = actividadDocRef.id;

      // Actualizar el campo 'id' con el ID de la actividad
      await actividadDocRef.update({'id': actividadId});

      // Guardar las imágenes seleccionadas y el ID de la actividad
      await FirebaseFirestore.instance
          .collection('actividades_memorama')
          .doc(actividadId)
          .set({
        'id': actividadId, // Agregar el ID de la actividad
        'titulo': titulo,
        'instrucciones': instrucciones,
        'tipo': tipoActividad,
        'grado': grado,
        'grupo': grupo,
        'alumnos': alumnosIds,
        'finalizado': false,
        'materia': materia,
        'instituto': instituto,
        'imagenes_seleccionadas': selectedImages,
      });

      print('Actividad registrada exitosamente.');
    } catch (e) {
      print('Error al registrar actividad: $e');
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
