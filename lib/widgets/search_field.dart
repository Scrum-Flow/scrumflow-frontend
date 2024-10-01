import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scrumflow/domain/basics/base_text_field.dart';

class SearchField extends StatefulWidget {
  const SearchField({
    super.key,
    this.onFieldSubmitted,
    this.onClear,
  });

  final ValueChanged<String>? onFieldSubmitted;
  final ValueChanged<String>? onClear;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final TextEditingController controller = TextEditingController();
  final StreamController<String> streamController = StreamController<String>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: streamController.stream,
      builder: (context, snapshot) => BaseTextField(
        hint: 'Buscar',
        prefixIcon: Icon(Icons.filter_alt_outlined),
        suffixIcon: snapshot.hasData && snapshot.data?.isNotEmpty == true
            ? GestureDetector(
                child: Icon(Icons.clear),
                onTap: () {
                  controller.text = '';
                  widget.onClear?.call(controller.text);
                  streamController.add(controller.text);
                },
              )
            : GestureDetector(
                child: Icon(Icons.search_outlined),
                onTap: () => widget.onFieldSubmitted?.call(controller.text),
              ),
        keyboardType: TextInputType.text,
        controller: controller,
        onChanged: (value) => streamController.add(value),
        onFieldSubmitted: widget.onFieldSubmitted,
      ),
    );
  }

  @override
  void dispose() async {
    super.dispose();

    controller.dispose();
    await streamController.close();
  }
}
