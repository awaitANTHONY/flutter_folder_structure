import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter/services.dart';
import '/consts/consts.dart';
import '/utils/helpers.dart';

class TextboxWidget extends StatefulWidget {
  const TextboxWidget({
    super.key,
    required this.title,
    this.fieldName,
    this.initialValue,
    this.keyboardType = TextInputType.name,
    this.isPassword = false,
    this.hintText = '',
    this.lableText = '',
    this.isRequired = true,
    this.suffix,
    this.prefix,
    this.controller,
    this.customValidator,
    this.inputFormatters,
    this.isReadOnly = false,
    this.isEnabled = true,
    this.externalErrorText,
    this.onChanged,
    this.maxLength,
    this.maxLines = 1,
    this.minLines,
    this.onTap,
  });

  final String title;
  final String? fieldName;
  final String? initialValue;
  final bool isPassword;
  final TextInputType keyboardType;
  final String lableText;
  final String hintText;
  final bool isRequired;
  final Widget? suffix;
  final Widget? prefix;
  final TextEditingController? controller;
  final String? Function(String?)? customValidator;
  final List<TextInputFormatter>? inputFormatters;
  final bool isReadOnly;
  final bool isEnabled;
  final String? externalErrorText;
  final void Function(String?)? onChanged;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final VoidCallback? onTap;

  @override
  State<TextboxWidget> createState() => _TextboxWidgetState();
}

class _TextboxWidgetState extends State<TextboxWidget> {
  bool isObscureText = false;

  @override
  void initState() {
    super.initState();
    isObscureText = widget.isPassword;
  }

  String getFieldName(String title) {
    return title.toLowerCase().replaceAll(' ', '_');
  }

  @override
  Widget build(BuildContext context) {
    final fieldName = widget.fieldName ?? getFieldName(widget.title);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: lang(widget.title),
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                  color: AppColors.black,
                ),
              ),
              if (widget.isRequired)
                TextSpan(
                  text: ' *',
                  style: TextStyle(fontSize: 15.sp, color: Colors.red),
                ),
              // else
              //   TextSpan(
              //     text: ' (optional)',
              //     style: TextStyle(fontSize: 15.sp, color: Colors.red),
              //   ),
            ],
          ),
        ),
        10.verticalSpace,
        Container(
          width: double.infinity,
          alignment: Alignment.center,
          child: FormBuilderTextField(
            name: fieldName,
            initialValue: widget.initialValue,
            obscureText: isObscureText,
            keyboardType: widget.keyboardType,
            controller: widget.controller,
            enabled: widget.isEnabled,
            readOnly: widget.isReadOnly,
            maxLength: widget.maxLength,
            maxLines: widget.maxLines ?? (widget.isPassword ? 1 : null),
            minLines: widget.minLines,
            inputFormatters: [
              if (widget.keyboardType == TextInputType.number)
                FilteringTextInputFormatter.digitsOnly,
              if (widget.inputFormatters != null) ...widget.inputFormatters!,
            ],
            style: TextStyle(
              color: AppColors.black,
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
              height: 1,
            ),
            decoration: AppStyles.textInputDecoration(
              lableText: widget.lableText,
              hintText: (widget.hintText),
              prefix: widget.prefix,
              suffix: widget.isPassword
                  ? InkWell(
                      onTap: () {
                        setState(() {
                          isObscureText = !isObscureText;
                        });
                      },
                      child: Icon(
                        isObscureText ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.black.withValues(alpha: 0.5),
                        size: 18.sp,
                      ),
                    )
                  : widget.suffix,
              errorText: widget.externalErrorText,
              isEnabled: widget.isEnabled,
            ),
            cursorColor: AppColors.primary,
            validator: FormBuilderValidators.compose([
              if (widget.isRequired)
                FormBuilderValidators.required(
                  errorText: lang('This field is required'),
                ),
              if (widget.customValidator != null) widget.customValidator!,
            ]),
            onChanged: widget.onChanged,
            onTap: widget.onTap,
          ),
        ),
      ],
    );
  }
}
