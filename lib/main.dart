import 'package:flutter/material.dart';
import 'theme/theme.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'package:provider/provider.dart';
import 'viewmodels/mail/sendmailinscription_viewmodel.dart';
import 'viewmodels/dhis2/gestionnaire_viewmodel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() {
  dotenv.load(fileName: ".env");
  runApp(
      MultiProvider(
        providers: [
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


