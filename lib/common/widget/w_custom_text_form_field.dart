import 'package:actual/common/const/color.dart';
import 'package:flutter/material.dart';

class WCustomTextFormField extends StatelessWidget {
  final String? hintText;
  final Icon? icon;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final bool obscureText;
  final bool autofocus;

  const WCustomTextFormField({
    super.key,
    this.hintText,
    this.icon,
    this.errorText,
    this.onChanged,
    this.obscureText = false,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          onChanged: onChanged,
          obscureText: obscureText,
          autofocus: autofocus,
          cursorColor: COLOR_PRIMARY,
          decoration: InputDecoration(
            prefixIcon: icon,
            hintText: hintText,
            hintStyle: const TextStyle(color: COLOR_BODY_TEXT, fontSize: 14),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            filled: true,
            fillColor: COLOR_TEXT_FIELD_BACKGROUND,
            border: baseBorder,
            enabledBorder:
                baseBorder.copyWith(borderSide: baseBorder.borderSide.copyWith(color: COLOR_TEXT_FIELD_BACKGROUND)),
            focusedBorder: baseBorder.copyWith(borderSide: baseBorder.borderSide.copyWith(color: COLOR_PRIMARY)),
            errorBorder: baseBorder.copyWith(
              borderSide: baseBorder.borderSide.copyWith(color: Colors.red),
            ),
            focusedErrorBorder: baseBorder.copyWith(
              borderSide: baseBorder.borderSide.copyWith(color: Colors.red),
            ),
          ),
        ),
        SizedBox(
          height: 20,
          child: errorText != null
              ? Padding(
                  padding: const EdgeInsets.only(top: 4, left: 12),
                  child: Text(
                    errorText!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                )
              : null,
        ),
      ],
    );
  }
}

final baseBorder = OutlineInputBorder(
  borderSide: const BorderSide(
    color: COLOR_TEXT_FIELD_BACKGROUND,
  ),
  borderRadius: BorderRadius.circular(8),
);
