import 'package:flutter/material.dart';

class DateField extends FormField<String> {
  DateField({
    super.key,
    required String label,
    bool required = false,
    String? initialValue,
    FormFieldSetter<String>? onSaved,
    FormFieldValidator<String>? validator,
  }) : super(
    initialValue: initialValue,
    onSaved: onSaved,
    validator: validator ??
            (value) {
          if (required && (value == null || value.isEmpty)) {
            return 'Champ obligatoire';
          }
          return null;
        },
    builder: (state) {
      final theme = Theme.of(state.context);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Label avec *
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: RichText(
              text: TextSpan(
                text: label,
                style: theme.textTheme.bodyMedium,
                children: required
                    ? const [
                  TextSpan(
                    text: ' *',
                    style: TextStyle(color: Colors.red),
                  ),
                ]
                    : [],
              ),
            ),
          ),

          // 🔹 Champ date cliquable
          InkWell(
            onTap: () async {
              final picked = await showDatePicker(
                context: state.context,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                initialDate: DateTime.now(),
              );

              if (picked != null) {
                state.didChange(
                  picked.toIso8601String().substring(0, 10),
                );
              }
            },
            child: InputDecorator(
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                errorText: state.errorText,
                suffixIcon: const Icon(Icons.calendar_today),
              ),
              child: Text(
                state.value ?? 'Sélectionner une date',
                style: state.value == null
                    ? theme.textTheme.bodyMedium
                    ?.copyWith(color: Colors.grey)
                    : theme.textTheme.bodyMedium,
              ),
            ),
          ),
        ],
      );
    },
  );
}
