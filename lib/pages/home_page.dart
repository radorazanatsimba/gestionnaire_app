import 'package:flutter/material.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      drawer: Drawer(
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
                leading: Icon(Icons.home, color: Theme.of(context).colorScheme.primary),
                title: const Text('Accueil'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.person, color: Theme.of(context).colorScheme.primary),
                title: const Text('Gestionnaires'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.bar_chart, color: Theme.of(context).colorScheme.primary),
                title: const Text('Statistiques'),
                onTap: () {},
              ),

              const Divider(),

              ListTile(
                leading: Icon(Icons.settings, color: Theme.of(context).colorScheme.tertiary),
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
      ),

      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/logoEAH.png',
              width: 60,
              height: 60,
            ),
            const SizedBox(width: 8),
            const Text('Application de gestion des gestionnaires AEP'),
          ],
        ),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}