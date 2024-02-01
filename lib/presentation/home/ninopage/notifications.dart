import 'package:flutter/material.dart';

void main() {
  runApp(const NotificationPage());
}

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NotificationScreen(),
    );
  }
}

// ignore: use_key_in_widget_constructors
class NotificationScreen extends StatelessWidget {
  final List<String> notifications = [
    'Canto agrego una nueva tarea.',
    'Tu tarea ha sido calificada.',
    'No se que poner de ejemplo.',
    // Agrega más notificaciones según sea necesario
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: Center(
        child: Container(
          padding: const EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.notifications,
                color: Colors.blue,
                size: 50,
              ),
              const SizedBox(height: 10),
              const Text(
                'Notificaciones',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[200],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(10),
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: const Icon(
                            Icons.notifications,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          notifications[index],
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onTap: () {
                          // Acción al hacer clic en una notificación específica
                          // Puedes implementar la navegación a una pantalla específica
                        },
                      ),
                    );
                  },
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
