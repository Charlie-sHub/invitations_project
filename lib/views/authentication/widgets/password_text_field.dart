import 'package:flutter/material.dart';
import 'package:invitations_project/domain/core/validation/objects/password.dart';
import 'package:invitations_project/views/core/validator_typedef.dart';

class PasswordTextField extends StatelessWidget {
  const PasswordTextField({
    required this.eventToAdd,
    required this.validator,
    super.key,
  });

  final void Function(String) eventToAdd;
  final Validator<String?> validator;

  @override
  Widget build(BuildContext context) => TextFormField(
      maxLength: Password.maxLength,
      autocorrect: false,
      obscureText: true,
      onChanged: (value) => eventToAdd(value.trim()),
      validator: validator,
      decoration: const InputDecoration(
        labelText: 'Contraseña',
        counterText: '',
        prefixIcon: Icon(
          Icons.lock,
        ),
        filled: true,
      ),
    );
}
