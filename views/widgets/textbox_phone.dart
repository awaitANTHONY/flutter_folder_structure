import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter/services.dart';
import '/consts/consts.dart';

class TextboxPhoneWidget extends StatefulWidget {
  const TextboxPhoneWidget({
    super.key,
    required this.title,
    this.fieldName,
    this.keyboardType = TextInputType.phone,
    this.hintText = '',
    this.lableText = '',
    this.isRequired = true,
    this.suffix,
    this.prefix,
    this.controller,
    this.customValidator,
    this.inputFormatters,
    this.isReadOnly = false,
    this.externalErrorText,
    this.onChanged,
    this.initialValue,
  });

  final String title;
  final String? fieldName;
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
  final String? externalErrorText;
  final void Function(String?)? onChanged;
  final String? initialValue;

  @override
  State<TextboxPhoneWidget> createState() => _TextboxPhoneWidgetState();
}

class _TextboxPhoneWidgetState extends State<TextboxPhoneWidget> {
  @override
  void initState() {
    super.initState();
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
                text: widget.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                  color: AppColors.black,
                ),
              ),
              if (widget.isRequired)
                TextSpan(
                  text: ' *',
                  style: TextStyle(fontSize: 15.sp, color: Colors.red),
                )
              else
                TextSpan(
                  text: ' (optional)',
                  style: TextStyle(fontSize: 15.sp, color: Colors.red),
                ),
            ],
          ),
        ),
        10.verticalSpace,
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
          child: FormBuilderField<String>(
            name: fieldName,
            validator: FormBuilderValidators.compose([
              if (widget.isRequired)
                FormBuilderValidators.required(
                  errorText: 'This field is required',
                ),
              if (widget.customValidator != null) widget.customValidator!,
            ]),
            builder: (FormFieldState<String> field) {
              return IntlPhoneField(
                controller: widget.controller,
                enabled: !widget.isReadOnly,
                style: TextStyle(
                  color: AppColors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                ),
                flagsButtonPadding: EdgeInsets.only(left: 10.sp, right: 0.sp),
                decoration: AppStyles.phoneInputDecoration(
                  lableText: widget.lableText,
                  hintText: widget.hintText,
                  prefix: widget.prefix,
                  suffix: widget.suffix,
                  errorText: field.errorText ?? widget.externalErrorText,
                  isReadOnly: widget.isReadOnly,
                ).copyWith(errorText: field.errorText),
                initialValue: field.value,
                dropdownIconPosition: IconPosition.leading,
                dropdownIcon: Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.black,
                  size: 20.sp,
                ),
                onChanged: (phone) {
                  final completeNumber = phone.completeNumber;

                  field.didChange(completeNumber);

                  if (widget.onChanged != null) {
                    widget.onChanged!(completeNumber);
                  }
                },
                onCountryChanged: (country) {
                  //
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
