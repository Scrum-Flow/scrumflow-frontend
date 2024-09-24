import 'package:flutter/material.dart';
import 'package:scrumflow/utils/helper.dart';
import 'package:scrumflow/widgets/base_text_field.dart';

class BaseDatePicker extends StatefulWidget {
  const BaseDatePicker({
    Key? key,
    this.hint,
    this.initialValue,
    this.onChanged,
    this.validator,
    this.enabled = true,
  }) : super(key: key);

  final String? hint;
  final DateTime? initialValue;
  final ValueChanged<DateTime?>? onChanged;
  final FormFieldValidator<DateTime>? validator;
  final bool enabled;

  @override
  State<BaseDatePicker> createState() => _BaseDatePickerState();
}

class _BaseDatePickerState extends State<BaseDatePicker> {
  TextEditingController controller = TextEditingController();

  DateTime? selectedValue;

  @override
  void initState() {
    super.initState();

    selectedValue = widget.initialValue;
    controller.text = Helper.formatDate(selectedValue) ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return BaseTextField(
      hint: widget.hint,
      controller: controller,
      readOnly: true,
      validator: (value) => widget.validator?.call(selectedValue),
      enabled: widget.enabled,
      onTap: () async {
        DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedValue ?? DateTime.now(),
          firstDate: DateTime(2015, 8),
          lastDate: DateTime(2101),
        );

        if (picked != null) {
          picked = picked.copyWith(
              minute: 0, millisecond: 0, microsecond: 0, hour: 0, second: 0);
        }

        controller.text = Helper.formatDate(picked) ?? '';

        selectedValue = picked;

        widget.onChanged?.call(selectedValue);
      },
    );
  }
}
