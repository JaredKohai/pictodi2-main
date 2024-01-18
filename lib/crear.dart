import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Crear {
  // ... (otros métodos de registro)

  Future<void> registerAdmin(String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String userId = userCredential.user!.uid;

      await FirebaseFirestore.instance
          .collection('admin')
          .doc(userId)
          .set({
            'id': userId,
            'email': email,
            'permiso': 'admin',
          });

      print('Administrador registrado exitosamente.');
    } catch (e) {
      print('Error al registrar administrador: $e');
    }
  }
}
