import 'package:flutter/material.dart';
import 'menu.dart';

class DynamicFormPage extends StatefulWidget {
  @override
  _DynamicFormPageState createState() => _DynamicFormPageState();
}

class _DynamicFormPageState extends State<DynamicFormPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Collecte des données")),
      drawer: AppDrawer(),
      body: Center(child: Text("Bienvenue sur la page Collecte des données")),
    );
  }
}
