import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../dhis2/synchronisation_service.dart'; // ton service de sync
import '../provider/d2_init.dart';
import '../provider/sync_progress_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? error;

  @override
  void initState() {
    super.initState();
    Future.microtask(_start);
  }

  Future<void> _start() async {
    try {
      final d2Provider = context.read<D2Provider>();
      final progressProvider = context.read<SyncProgressProvider>();

      progressProvider.reset();

      // Initialisation D2 si nécessaire
      if (!d2Provider.isInitialized) {
        await d2Provider.init();
      }

      final prefs = await SharedPreferences.getInstance();
      final isSynced = prefs.getBool('metadata_downloaded') ?? false;

      if (!isSynced) {
        await SynchronisationService().syncMetadata(d2Provider, progressProvider);
      }

      // Navigation après succès
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      setState(() => error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (error != null) {
      return _ErrorView(
        error: error!,
        onRetry: _start,
      );
    }

    return const Scaffold(
      body: Center(
        child: SyncProgressWidget(),
      ),
    );
  }
}

/// Widget pour afficher une erreur et bouton de retry
class _ErrorView extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const _ErrorView({
    required this.error,
    required this.onRetry,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_off, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Erreur de synchronisation',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(error, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onRetry,
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Exemple simple de ProgressBar pour suivre la sync
class SyncProgressWidget extends StatelessWidget {
  const SyncProgressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SyncProgressProvider>(
      builder: (_, progress, __) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(progress.message),
            const SizedBox(height: 16),
            LinearProgressIndicator(value: progress.progress),
            const SizedBox(height: 8),
            Text('${(progress.progress * 100).toStringAsFixed(0)} %'),
          ],
        );
      },
    );
  }
}
