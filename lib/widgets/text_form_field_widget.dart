import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Utils/app_colors.dart';
import '../Utils/common_widgets.dart';

class TextFormFieldWidget extends StatefulWidget {
  double widthRatio;
  String hintText, labelText;
  Icon? icon;
  TextEditingController? textEditingController;
  final List<TextInputFormatter> inputFormatters;
  final TextInputType keyboardType;
  final initialValue;
  final FormFieldValidator<String>? validator;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final int? maxLength;
  bool? readOnly = false;

  TextFormFieldWidget({
    super.key,
    required this.widthRatio,
    required this.textEditingController,
    required this.hintText,
    required this.labelText,
    required this.icon,
    required this.inputFormatters,
    required this.keyboardType,
    required this.validator,
    required this.onChanged,
    required this.initialValue,
    required this.maxLength,
    required this.onTap,
    required this.readOnly,
  });

  @override
  State<TextFormFieldWidget> createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      width: widget.widthRatio,
      child: Padding(
        padding: EdgeInsets.only(
            left: screenWidth * 0.008,
            right: screenWidth * 0.008,
            top: screenWidth * 0.001),
        child: TextFormField(
          maxLength: widget.maxLength,
          onTap: widget.onTap,
          controller: widget.textEditingController,
          validator: widget.validator,
          initialValue: widget.initialValue,
          cursorColor: Theme.of(context).primaryColor,
          style: TextStyle(
              color: AppColors.blackColor,
              fontSize: isTablet(context) ? 15 : screenWidth * 0.035),
          keyboardType: widget.keyboardType,
          inputFormatters: widget.inputFormatters,
          onChanged: widget.onChanged,
          readOnly: widget.readOnly!,
          decoration: InputDecoration(
            counterText: "",
            filled: true,
            // fillColor: AppColors.backgroundColor,
            fillColor: AppColors.whiteColor,
            hintText: widget.hintText,
            hintStyle: const TextStyle(
              fontFamily: 'Poppins',
              color: AppColors.hintLabelTextColor,
            ),
            enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)),
            focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.primaryBlur1Color)),
            // labelText: widget.labelText,
            // labelStyle: const TextStyle(fontFamily: 'Poppins', color: AppColors.hintLabelTextColor,),
            contentPadding:
                EdgeInsets.only(right: 0, left: screenWidth * 0.012),
          ),
        ),
      ),
    );
  }
}
