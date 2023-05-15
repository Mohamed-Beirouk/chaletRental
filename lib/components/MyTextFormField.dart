import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  String? hintText;
  String? labelText;
  TextInputType? inputType;
  final VoidCallback? onchange;
  bool? secure;
  double? width;

  double topPadding = 0;
  int maxLine = 1;
  Widget? widgetIcon;
  Widget? widgetIcon2;
  Color? contentColor;
  FormFieldValidator<String?>? validator;
  TextEditingController? controller;
  MyTextFormField({
    this.hintText,
    this.inputType,
    this.topPadding = 0,
    this.maxLine = 1,
    this.labelText,
    this.contentColor,
    this.validator,
    this.controller,
    this.onchange,
    this.secure,
    this.widgetIcon,
    this.widgetIcon2,
    this.width = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: Container(
        width: width ?? double.infinity,
        child: TextFormField(
          //   onChanged: onchange(value),
          controller: controller,
          validator: validator,
          obscureText: secure!,
          keyboardType: inputType,
          maxLines: maxLine,
          decoration: InputDecoration(
            suffixIcon: widgetIcon2,
            prefixIcon: widgetIcon,
            filled: true,
            contentPadding: EdgeInsets.only(left: 30, top: 30),
            fillColor: contentColor ?? Color(0xFFF1F1F1),
            labelText: labelText,
            hintText: hintText,
            border: const OutlineInputBorder(
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(30.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
