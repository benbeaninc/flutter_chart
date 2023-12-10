import 'package:flutter/material.dart';

class SelectPickerInput extends StatefulWidget {
  const SelectPickerInput({
    super.key,
    this.title,
    required this.items,
    this.value,
    this.onSaved,
    this.validator,
    this.loading = false,
  });
  final String? title;
  final String? value;
  final Map<String, String> items;
  final Function? onSaved;
  final Function? validator;
  final bool loading;

  @override
  _SelectPickerInput createState() => _SelectPickerInput();
}

class _SelectPickerInput extends State<SelectPickerInput> {
  String? selected;

  List<DropdownMenuItem> getList() {
    List<DropdownMenuItem> arr = [];
    widget.items.forEach((code, text) {
      arr.add(DropdownMenuItem(
        value: code,
        child: Text(text),
      ));

      if (selected == null) {
        if (widget.value != null && widget.value != '') {
          if (code == widget.value) {
            setState(() {
              selected = code;
            });
          }
        } else {
          setState(() {
            selected = code;
          });
        }
      }
    });
    return arr.toList();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      icon: const Icon(Icons.keyboard_arrow_down),
      items: getList(),
      value: selected ?? widget.value,
      isExpanded: true,
      decoration: const InputDecoration(border: OutlineInputBorder()),
      onChanged: (newValue) {
        if (widget.loading) return;
        if (widget.validator != null) {
          widget.validator!(newValue);
        }
        if (widget.onSaved != null) {
          widget.onSaved!(newValue);
        }
        setState(() {
          selected = newValue!;
        });
      },
    );
  }
}
