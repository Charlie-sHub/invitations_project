import 'package:flutter/material.dart';
import 'package:invitations_project/views/core/validator_typedef.dart';

class EmailTextField extends StatelessWidget {
  const EmailTextField({
    required this.eventToAdd,
    required this.validator,
    this.initialValue,
    super.key,
  });

  final void Function(String) eventToAdd;
  final Validator<String?> validator;
  final String? initialValue;

  @override
  Widget build(BuildContext context) => TextFormField(
      onChanged: (value) => eventToAdd(value.trim()),
      initialValue: initialValue,
      validator: validator,
      autocorrect: false,
      decoration: const InputDecoration(
        labelText: 'Correo electronico',
        prefixIcon: Icon(
          Icons.email,
        ),
        filled: true,
      ),
    );
}
