import 'package:d2_touch/modules/metadata/program/entities/program_stage_data_element.entity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:d2_touch/modules/metadata/data_element/entities/data_element.entity.dart';
import 'package:d2_touch/modules/metadata/program/entities/program.entity.dart';
import 'package:d2_touch/modules/metadata/program/entities/program_stage.entity.dart';
import '../../model/data_element_with_options.dart';

import '../provider/d2_init.dart';
import '../dhis2/program_form_service.dart';
import '../widgets/date_field.dart';

class ProgramFormPage extends StatefulWidget {
  final String programUid;
  final String stageUid;

  const ProgramFormPage({
    super.key,
    required this.programUid,
    required this.stageUid,
  });

  @override
  State<ProgramFormPage> createState() => _ProgramFormPageState();
}

class _ProgramFormPageState extends State<ProgramFormPage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};

  late Future<_FormBundle> _future;

  @override
  void initState() {
    super.initState();
    _future = _loadForm();
  }

  Future<_FormBundle> _loadForm() async {
    final d2 = context.read<D2Provider>().d2;
    final service = ProgramFormService(d2);

    // 1️⃣ Charger Program
    final program = await service.loadProgram(widget.programUid);

    // 2️⃣ Charger Stage
    final stage = await service.loadStage(widget.stageUid);

    // 3️⃣ Charger PSDE
    final psdes = await service.loadStageElements(stage.id!);
    if (psdes.isEmpty) {
      throw Exception("Aucun champ configuré pour ce stage");
    }

    // 4️⃣ Charger DataElements (download un par un)
    final dataElements = await service.loadDataElements(
      program.id!,
      stage.id!,
    );
    final dataElementsMap = {
      for (final de in dataElements) de.id!: de
    };
    final optionSetDataElements = await service.getOptionSetDataElements(
    program.id!,
    stage.id!) ;

    return _FormBundle(
      program: program,
      stage: stage,
      psdes: psdes,
      dataElements: dataElementsMap,
      optionSets: optionSetDataElements
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Formulaire de collecte"),
      ),
      body: FutureBuilder<_FormBundle>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Erreur : ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final data = snapshot.data!;

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  data.program.displayName ?? '',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 6),
                Text(
                  data.stage.displayName ?? '',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 24),

                ...data.psdes.map((psde) {
                  final de = data.dataElements[psde.dataElementId];
                  final os = data.optionSets;

                  if (de == null) {
                    return const SizedBox.shrink();
                  }
                  return _buildField(psde, de,os);
                }),

                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text("Enregistrer"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ================================
  // 🔹 CHAMP DYNAMIQUE
  // ================================
  Widget _buildField(
      ProgramStageDataElement psde,
      DataElement de,
      List<DataElementWithOptions> optionSetDataElement
      ) {
    final uid = de.id!;
    final isRequired = psde.compulsory == true;
    Widget field;
    String label(String text) =>
        isRequired ? "$text *" : text;

    String? requiredValidator(dynamic v) {
      if (!isRequired) return null;
      if (v == null || v.toString().isEmpty) {
        return "Champ obligatoire";
      }
      return null;
    }
    final Map<String, DataElementWithOptions> optionSetMap = {
      for (final opt in optionSetDataElement) opt.dataElementId: opt
    };

    final deWithOptions = optionSetMap[uid] ??
        DataElementWithOptions(dataElementId: uid, options: []);

    final options = deWithOptions.options;

    switch (de.valueType) {
      case 'TEXT':
      case 'LONG_TEXT':
      if (options.isNotEmpty) {
        field = DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: label(de.displayName ?? uid),
            border: const OutlineInputBorder(),
          ),
          items: options.map((o) => DropdownMenuItem(
            value: o.code ?? o.name,
            child: Text(o.name ?? o.code ?? ''),
          )).toList(),
          validator: isRequired ? (v) => v == null || v.isEmpty ? 'Champ requis' : null : null,
          onChanged: (value) => setState(() => _formData[uid] = value),
          value: _formData[uid],
        );
      } else {
        // Sinon TextFormField classique
        field = TextFormField(
          decoration: InputDecoration(
            labelText: label(de.displayName ?? uid),
            border: const OutlineInputBorder(),
          ),
          validator: requiredValidator,
          onSaved: (v) => _formData[uid] = v,
        );
      }
      break;

      case 'NUMBER':
      case 'INTEGER':
      case 'INTEGER_POSITIVE':
      if (options.isNotEmpty) {
        field = DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: label(de.displayName ?? uid),
            border: const OutlineInputBorder(),
          ),
          items: options.map((o) => DropdownMenuItem(
            value: o.code ?? o.name,
            child: Text(o.name ?? o.code ?? ''),
          )).toList(),
          validator: isRequired ? (v) => v == null || v.isEmpty ? 'Champ requis' : null : null,
          onChanged: (value) => setState(() => _formData[uid] = value),
          value: _formData[uid],
        );
      } else {
        field = TextFormField(
          decoration: InputDecoration(
            labelText: label(de.displayName ?? uid),
            border: const OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          validator: requiredValidator,
          onSaved: (v) =>
          _formData[uid] = num.tryParse(v ?? ''),
        );
        break;
      }

      case 'DATE':
        field = DateField(
          label: label(de.displayName ?? uid),
          required: isRequired,
          validator: requiredValidator,
          onSaved: (v) => _formData[uid] = v,
        );
        break;



      case 'BOOLEAN':
        field = Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: RichText(
                  text: TextSpan(
                    text: de.displayName ?? uid,
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: isRequired
                        ? const [
                      TextSpan(
                        text: ' *',
                        style: TextStyle(color: Colors.red),
                      )
                    ]
                        : [],
                  ),
                ),
              ),
              Switch(
                value: (_formData[uid] ?? false) as bool,
                onChanged: (v) =>
                    setState(() => _formData[uid] = v),
              ),
            ],
          ),
        );
        break;

      default:
        field = Text(
          "Type non supporté : ${de.valueType}",
          style: const TextStyle(color: Colors.orange),
        );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: field,
    );
  }

  // ================================
  // 🔹 SUBMIT
  // ================================
  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
          Text("Veuillez remplir les champs obligatoires"),
        ),
      );
      return;
    }

    _formKey.currentState!.save();

    debugPrint("📦 Données saisies :");
    _formData.forEach(
          (k, v) => debugPrint(" - $k : $v"),
    );

    // 👉 Prochaine étape :
    // d2.eventModule.event.create(...)
  }
}

// ================================
// 🔹 BUNDLE
// ================================
class _FormBundle {
  final Program program;
  final ProgramStage stage;
  final List<ProgramStageDataElement> psdes;
  final Map<String, DataElement> dataElements;
  final List<DataElementWithOptions> optionSets;

  _FormBundle({
    required this.program,
    required this.stage,
    required this.psdes,
    required this.dataElements,
    required this.optionSets,
  });

}
