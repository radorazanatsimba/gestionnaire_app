import 'package:flutter/material.dart';
import 'menu.dart';
import 'package:gestionnaire_app/features/auth_service.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Accueil")),
      drawer: AppDrawer(), // Drawer partagé
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Bienvenue sur la page d’accueil"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                  AuthService.login(url: "http://seam.meah.gov.mg:8081/dhis",
                    username: "admin",
                    password: "district");
              },
              child: const Text("Cliquer ici"),
            ),
          ],
        ),
      ),
    );
  }
}
