import 'package:flutter/material.dart';
import 'theme/theme.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'package:provider/provider.dart';
import 'viewmodels/mail/sendmailinscription_viewmodel.dart';
import 'viewmodels/dhis2/gestionnaire_viewmodel.dart';
import 'pages/dynamic_form_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/provider/d2_init.dart';
import 'main.reflectable.dart';
import '../core/dhis2/auth_service.dart';



Future<void> main() async {
  try {
    await dotenv.load(fileName: "assets/.env");
  } catch (e) {
    print("⚠️ Fichier .env introuvable, valeurs par défaut utilisées.");
  }

  initializeReflectable();
  final d2Provider = D2Provider();
  await d2Provider.init();


  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<D2Provider>.value(value: d2Provider),
          ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => SendMailInscriptionViewModel()),
          ChangeNotifierProvider(create: (_) => GestionnaireViewModel()),

        ],
        child: const GestionnaireApp(),
      ),
  );
}

class GestionnaireApp extends StatelessWidget {
  const GestionnaireApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Application Gestionnaire AEP',
      theme: meahTheme,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(title: 'Accueil AEP'),
      },
    );

  }

}
