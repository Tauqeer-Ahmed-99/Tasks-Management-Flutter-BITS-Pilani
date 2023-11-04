import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    required this.textInputAction,
    required this.labelText,
    required this.keyboardType,
    required this.controller,
    super.key,
    this.onChanged,
    this.validator,
    this.obscureText,
    this.suffixIcon,
    this.onEditingComplete,
    this.autofocus,
    this.focusNode,
    this.minLines,
    this.maxLines,
    this.noBorder,
    this.fontSize,
    this.textDecoration,
    this.disabled,
  });

  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final bool? obscureText;
  final Widget? suffixIcon;
  final String labelText;
  final bool? autofocus;
  final FocusNode? focusNode;
  final int? minLines;
  final int? maxLines;
  final bool? noBorder;
  final double? fontSize;
  final TextDecoration? textDecoration;
  final bool? disabled;
  final void Function()?
      onEditingComplete; // Use 'super(key: key)' to pass the key parameter

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        enabled: disabled ?? false ? false : true,
        controller: controller,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        focusNode: focusNode,
        onChanged: onChanged,
        autofocus: autofocus ?? false,
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        obscureText: (maxLines != null && maxLines! > 1)
            ? false
            : (obscureText ?? false),
        obscuringCharacter: '*',
        onEditingComplete: onEditingComplete,
        minLines: minLines,
        maxLines: maxLines,
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          labelText: labelText,
          labelStyle: const TextStyle(
            color: Color(0xff1E2E3D),
          ),
          floatingLabelBehavior:
              noBorder ?? false ? FloatingLabelBehavior.always : null,
          border: noBorder ?? false
              ? (minLines != null && minLines! > 1)
                  ? InputBorder.none
                  : const UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF81A1BF), width: 2),
                    )
              : const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
          focusedBorder: noBorder ?? false
              ? (minLines != null && minLines! > 1)
                  ? InputBorder.none
                  : const UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xff1E2E3D), width: 2),
                    )
              : const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                  borderSide: BorderSide(color: Color(0xff1E2E3D), width: 2),
                ),
        ),
        onTapOutside: (event) => FocusScope.of(context).unfocus(),
        style: TextStyle(
          fontSize: fontSize ?? 16.0, // Provide a default font size
          fontWeight: FontWeight.w500,
          color: Colors.black,
          decoration: textDecoration,
        ),
      ),
    );
  }
}
