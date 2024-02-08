import 'package:pictodi2/presentation/home/directorpage/Accounts/acccountProfesor.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const AccountPsicologo());
}

class AccountPsicologo extends StatelessWidget {
  const AccountPsicologo({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AccountsScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Account {
  final String name;
  final String institucion;
  final String imageAssetPath;

  Account(
      {required this.name,
      required this.institucion,
      required this.imageAssetPath});
}

class AccountsScreen extends StatelessWidget {
  final List<Account> accounts = [
    Account(
        name: 'Cuenta 1',
        institucion: 'UNI',
        imageAssetPath: 'assets/doctor.png'),
    Account(
        name: 'Cuenta 2',
        institucion: 'UNI',
        imageAssetPath: 'assets/doctor.png'),
    // Agrega más cuentas según sea necesario
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text(
            'Lista de Psicológos',
            style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.openSans().fontFamily),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.topRight,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AccountProfesor()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF60A9CD),
                ),
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                label: const Text('Agregar',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: accounts.length,
              itemBuilder: (context, index) {
                return AccountCard(account: accounts[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AccountCard extends StatelessWidget {
  final Account account;

  AccountCard({required this.account});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage(account.imageAssetPath),
        ),
        title: Text(
          account.name,
          style: GoogleFonts.openSans(),
        ),
        subtitle: Text(
          account.institucion,
          style: GoogleFonts.openSans(),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
