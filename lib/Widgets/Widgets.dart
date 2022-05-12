import 'package:flutter/material.dart';
import 'package:iv_calculator/model.dart';

class TxtFrmFld extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? nextFocus;
  final String? label;
  final String? hint;
  final TextInputAction? action;
  final FocusNode? fcNode;

  const TxtFrmFld({
    Key? key,
    required this.controller,
    this.label,
    this.hint,
    this.action,
    this.fcNode,
    this.nextFocus,

  }) : super(key: key);

  @override
  State<TxtFrmFld> createState() => _TxtFrmFldState();
}

class _TxtFrmFldState extends State<TxtFrmFld> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: widget.hint,
        labelText: widget.label,
      ),
      textInputAction: widget.action,
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(widget.nextFocus);
      },
      focusNode: widget.fcNode
    );
  }
}

typedef VoidCallback = void Function();

class DropDown extends StatefulWidget {
  dynamic typeVal;
  final List<String>? type;
  final VoidCallback? callback;

  DropDown({
    Key? key,
    this.typeVal,
    this.type,
    this.callback,
  }) : super(key: key);

  @override
  State<DropDown> createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton(
        value: widget.typeVal,
        icon: const Icon(Icons.keyboard_arrow_down),
        underline: const SizedBox(),
        items: widget.type?.map((valueItem) {
          return DropdownMenuItem(
            value: valueItem,
            child: Text(valueItem),
          );
        }).toList(),
        onChanged: (newValue) {
          widget.typeVal = newValue;
          print (widget.typeVal);
          print (valDoseType);
          widget.callback;
          setState(() {});
        });
  }
}
