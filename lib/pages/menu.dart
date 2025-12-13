import 'package:flutter/material.dart';
import 'dynamic_form_page.dart';
class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Theme.of(context).colorScheme.background,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // --- HEADER COMPACT PERSONNALISÉ ---
            Container(
              height: 100,
              color: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logoEAH.png',
                    height: 55,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Application AEP',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // --- ÉLÉMENTS DU MENU ---
            ListTile(
              leading: Icon(Icons.home,
                  color: Theme.of(context).colorScheme.primary),
              title: const Text('Accueil'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.person,
                  color: Theme.of(context).colorScheme.primary),
              title: const Text('Formulaires'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DynamicFormPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.bar_chart,
                  color: Theme.of(context).colorScheme.primary),
              title: const Text('Rapports'),
              onTap: () {},
            ),

            const Divider(),

            ListTile(
              leading: Icon(Icons.settings,
                  color: Theme.of(context).colorScheme.tertiary),
              title: const Text('Paramètres'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text('Déconnexion'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
