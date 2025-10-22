import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/mail/sendmailinscription_viewmodel.dart';
import '../viewmodels/dhis2/gestionnaire_viewmodel.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  String _usernameError = '';
  String _emailError = '';
  String _passwordError = '';
  String _confirmPasswordError = '';

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _validateFields() {
    bool valid = true;

    setState(() {
      _usernameError = '';
      _emailError = '';
      _passwordError = '';
      _confirmPasswordError = '';

      if (_usernameController.text.trim().isEmpty) {
        _usernameError = "Le nom d'utilisateur est requis.";
        valid = false;
      }

      if (_emailController.text.trim().isEmpty) {
        _emailError = "L'email est requis.";
        valid = false;
      } else if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$")
          .hasMatch(_emailController.text.trim())) {
        _emailError = "L'email n'est pas valide.";
        valid = false;
      }

      if (_passwordController.text.isEmpty) {
        _passwordError = "Le mot de passe est requis.";
        valid = false;
      }

      if (_confirmPasswordController.text.isEmpty) {
        _confirmPasswordError = "Veuillez confirmer le mot de passe.";
        valid = false;
      } else if (_passwordController.text != _confirmPasswordController.text) {
        _confirmPasswordError = "Les mots de passe ne correspondent pas.";
        valid = false;
      }
    });

    return valid;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Inscription")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Consumer2<SendMailInscriptionViewModel, GestionnaireViewModel>(
          builder: (context, mailVM, gestionnaireVM, child) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: "Nom d'utilisateur",
                      prefixIcon: const Icon(Icons.person),
                      errorText: _usernameError.isEmpty ? null : _usernameError,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      prefixIcon: const Icon(Icons.email),
                      errorText: _emailError.isEmpty ? null : _emailError,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: "Mot de passe",
                      prefixIcon: const Icon(Icons.lock),
                      errorText: _passwordError.isEmpty ? null : _passwordError,
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    decoration: InputDecoration(
                      labelText: "Confirmer le mot de passe",
                      prefixIcon: const Icon(Icons.lock),
                      errorText: _confirmPasswordError.isEmpty
                          ? null
                          : _confirmPasswordError,
                      suffixIcon: IconButton(
                        icon: Icon(_obscureConfirmPassword
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButton<String>(
                    value: gestionnaireVM.selectedGestionnaire,
                    hint: const Text("Sélectionnez un gestionnaire"),
                    items: gestionnaireVM.gestionnaires
                        .map((g) => DropdownMenuItem(
                      value: g['code'],
                      child: Text(g['nom']),
                    ))
                        .toList(),
                    onChanged: (value) {
                      gestionnaireVM.setSelectedGestionnaire(value);
                    },
                  ),
                  const SizedBox(height: 16),
                  mailVM.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                    onPressed: () {
                      if (_validateFields()) {
                        final username =
                        _usernameController.text.trim();
                        final email = _emailController.text.trim();
                        final password = _passwordController.text.trim();

                        mailVM.sendMail(
                            username :username,
                            email :  email,
                            password :  password,
                            destinataire:
                            "rrazanatsimba@gmail.com, admin-app-gestionnaire@meah.gov.mg",
                            sujet: "Nouvelle inscription",
                              message : """
                              Bonjour,<br>
                              Une demande d’inscription a été formulée par :<br><br>
                              <strong>Utilisateur :</strong> $username<br>
                              <strong>Email :</strong> $email<br><br>
                              Veuillez procéder à la validation après vérification.<br>
                              Cordialement.
                              """,
                            codeGestionnaire:"",
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: colorScheme.primary,
                    ),
                    child: const Text("Envoyer"),
                  ),
                  const SizedBox(height: 16),
                  if (mailVM.message.isNotEmpty)
                    Text(
                      mailVM.message,
                      style: TextStyle(
                        color: mailVM.message.startsWith("Erreur")
                            ? Colors.red
                            : Colors.green,
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
