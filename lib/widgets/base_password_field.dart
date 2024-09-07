import 'package:flutter/material.dart';
import 'package:scrumflow/widgets/base_text_field.dart';

class BasePasswordField extends StatefulWidget {
  const BasePasswordField({
    super.key,
    this.hint,
    this.onChanged,
    this.validator,
  });

  final String? hint;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;

  @override
  State<BasePasswordField> createState() => _BasePasswordFieldState();
}

class _BasePasswordFieldState extends State<BasePasswordField> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return BaseTextField(
      hint: widget.hint,
      obscureText: obscureText,
      prefixIcon: const Icon(Icons.lock_outline_rounded),
      keyboardType: TextInputType.visiblePassword,
      autofillHints: const [AutofillHints.password],
      suffixIcon: GestureDetector(
        onTap: () => setState(() => obscureText = !obscureText),
        child: obscureText
            ? const Icon(Icons.visibility_off)
            : const Icon(Icons.visibility),
      ),
      validator: widget.validator,
      onChanged: widget.onChanged,
    );
  }
}
