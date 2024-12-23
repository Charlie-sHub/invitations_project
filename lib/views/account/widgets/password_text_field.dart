import 'package:flutter/material.dart';
import 'package:invitations_project/domain/core/validation/objects/password.dart';
import 'package:invitations_project/views/account/validator_typedef.dart';

class PasswordTextField extends StatelessWidget {
  const PasswordTextField({
    required this.eventToAdd,
    required this.validator,
    super.key,
  });

  final Function eventToAdd;
  final Validator<String?> validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: Password.maxLength,
      autocorrect: false,
      obscureText: true,
      onChanged: (value) => eventToAdd(value.trim()),
      validator: validator,
      decoration: InputDecoration(
        labelText: "Contraseña",
        counterText: "",
        prefixIcon: const Icon(
          Icons.lock,
        ),
        filled: true,
      ),
    );
  }
}
