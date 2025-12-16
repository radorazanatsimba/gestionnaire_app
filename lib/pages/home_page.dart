import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/provider/d2_init.dart';
import '../core/dhis2/auth_service.dart';
import '../core/dhis2/synchronisation_service.dart';
import '../core/pages/program_form_page.dart';
import '../core/provider/sync_progress_provider.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _syncing = false; // état pour afficher le spinner

  @override
  Widget build(BuildContext context) {
    final d2Provider = context.watch<D2Provider>();
    final auth = context.watch<AuthProvider>();

    if (!d2Provider.isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Accueil")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Bienvenue sur la page d’accueil"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: auth.isLoading || _syncing
                  ? null
                  : () async {
                setState(() => _syncing = true);

                final bool success = await auth.login(
                  d2: d2Provider.d2,
                  url: "http://seam.meah.gov.mg:8081/dhis",
                  username: "admin",//mobilegestionnaire
                  password: "district",//Gestionnaire123@
                );

                if (!success) {
                  setState(() => _syncing = false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Erreur de connexion")),
                  );
                } else {
                  setState(() => _syncing = false);
                  final prefs = await SharedPreferences.getInstance();
                  final isSynchronized = prefs.getBool('metadata_downloaded') ?? false;

                  if (!isSynchronized) {
                    await SynchronisationService().syncMetadata(
                      d2Provider,
                      context.read<SyncProgressProvider>(),
                    );
                  }


                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Connecté et metadata synchronisées")),
                  );

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProgramFormPage(
                        programUid: "kkIrznYvmhb",
                        stageUid: "Z0aFYcrFF6L",
                      ),
                    ),
                  );
                }
              },
              child: const Text("Se connecter et synchroniser"),
            ),
            const SizedBox(height: 20),
            if (_syncing) ...[
              const CircularProgressIndicator(),
              const SizedBox(height: 10),
              const Text("Téléchargement des metadata en cours..."),
            ],
          ],
        ),
      ),
    );
  }
}