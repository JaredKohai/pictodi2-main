import 'package:flutter/material.dart';

void main() {
  runApp(const NotificationClass());
}

class NotificationClass extends StatelessWidget {
  const NotificationClass({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notificaciones Teams',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const NotificationScreen(),
    );
  }
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late TextEditingController _searchController;
  bool _onlyUnread = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: AssetImage('assets/teachers.png'),
            ),
            SizedBox(width: 10.0),
            Text('Actividades'),
          ],
        ),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            onSelected: (String option) {
              _handleMenuOption(option);
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 'opcion1',
                  child: Text('Marcar todo como leído'),
                ),
                // Agrega más opciones según sea necesario
              ];
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Buscar',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const SizedBox(width: 4.0),
                  Transform.scale(
                    scale: 0.8,
                    child: Switch(
                      value: _onlyUnread,
                      onChanged: (value) {
                        setState(() {
                          _onlyUnread = value;
                        });
                      },
                    ),
                  ),
                  const Text(
                    'No leídas',
                    style: TextStyle(fontSize: 14.0),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () {
                  _showFilterOptions(context);
                },
              ),
            ],
          ),
          Expanded(
            child: NotificationList(),
          ),
        ],
      ),
    );
  }

  void _handleMenuOption(String option) {
    // Aquí puedes realizar acciones basadas en la opción seleccionada
    print('Opción seleccionada: $option');
  }

  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Filtrar por:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ListTile(
                title: const Text('Filtro 1'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Filtro 2'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class NotificationList extends StatefulWidget {
  @override
  _NotificationListState createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  List<bool> isReadStatusList = List.generate(5, (index) => false);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            _toggleReadStatus(index);
            // Simular acción de ver la notificación
            _showNotificationDetails(context, index);
          },
          child: Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.black, width: 0.5),
              ),
            ),
            child: NotificationItem(
              index: index,
              isRead: isReadStatusList[index],
            ),
          ),
        );
      },
    );
  }

  void _toggleReadStatus(int index) {
    setState(() {
      isReadStatusList[index] = !isReadStatusList[index];
    });
  }

  void _showNotificationDetails(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotificationDetailScreen(index: index),
      ),
    );
  }
}

class NotificationItem extends StatelessWidget {
  final int index;
  final bool isRead;

  NotificationItem({required this.index, this.isRead = false});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isRead ? Color(0xFF60A9CD) : Colors.black,
        child: Icon(
          Icons.assignment_sharp,
          color: Colors.white,
        ),
      ),
      title: Text(
        'Notificación $index',
        style: TextStyle(
          fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
        ),
      ),
      subtitle: Text(
        'Descripción de la notificación $index',
        style: TextStyle(
          fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
        ),
      ),
    );
  }
}

class NotificationDetailScreen extends StatelessWidget {
  final int index;

  NotificationDetailScreen({required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de Notificación $index'),
      ),
      body: Center(
        child: Text('Contenido de la notificación $index'),
      ),
    );
  }
}
