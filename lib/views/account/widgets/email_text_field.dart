import 'package:flutter/material.dart';
import 'package:invitations_project/views/account/validator_typedef.dart';

class EmailTextField extends StatelessWidget {
  const EmailTextField({
    required this.eventToAdd,
    required this.validator,
    this.initialValue,
    super.key,
  });

  final Function eventToAdd;
  final Validator<String?> validator;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (value) => eventToAdd(value.trim()),
      initialValue: initialValue,
      validator: validator,
      autocorrect: false,
      decoration: InputDecoration(
        labelText: "Correo electronico",
        prefixIcon: const Icon(
          Icons.email,
        ),
        filled: true,
      ),
    );
  }
}
