import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/settings_provider.dart';
import '../theme/app_theme.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField(
      {super.key,
      required this.label,
      required this.hint,
      required this.controller,
      required this.validator
      //required this.onChanged
      });

  final String label;
  final String hint;
  final TextEditingController controller;

  //final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<SettingsProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        //onChanged: onChanged,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          labelStyle:
              TextStyle(color: provider.isDark() ? Colors.white : Colors.black),
          hintText: hint,
          hintStyle:
              TextStyle(color: provider.isDark() ? Colors.white : Colors.black),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AppTheme.primaryColor, width: 2),
          ),
        ),
      ),
    );
  }
}
