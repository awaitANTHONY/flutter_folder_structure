import '/consts/consts.dart';
import '/utils/helpers.dart';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

class PasscodeWidget extends StatefulWidget {
  const PasscodeWidget({
    super.key,
    this.controller,
    this.fieldName,
    this.title,
    this.length = 6,
    this.isRequired = false,
    this.autofocus = true,
    this.obscureText = false,
    this.initialValue,
    this.onChanged,
    this.onCompleted,
    this.customValidator,
  });

  final TextEditingController? controller;
  final String? fieldName;
  final String? title;
  final int length;
  final bool isRequired;
  final bool autofocus;
  final bool obscureText;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;
  final String? Function(String?)? customValidator;

  @override
  PasscodeWidgetState createState() => PasscodeWidgetState();
}

class PasscodeWidgetState extends State<PasscodeWidget> {
  final focusNode = FocusNode();
  late final TextEditingController _internalController;

  TextEditingController get _controller =>
      widget.controller ?? _internalController;

  @override
  void initState() {
    super.initState();
    _internalController = TextEditingController(text: widget.initialValue);
    if (widget.controller != null && widget.initialValue != null) {
      widget.controller!.text = widget.initialValue!;
    }
  }

  @override
  void dispose() {
    focusNode.dispose();
    _internalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 45.sp,
      height: 45.sp,
      textStyle: GoogleFonts.poppins(
        fontSize: 23,
        color: const Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.border),
      ),
    );

    Widget buildPinput({
      String? errorText,
      ValueChanged<String>? onFieldChanged,
    }) {
      final hasError = errorText != null;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null && widget.title!.isNotEmpty) ...[
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: lang(widget.title!),
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
                ],
              ),
            ),
            10.verticalSpace,
          ],
          SizedBox(
            width: double.infinity,
            height: 50.sp,
            child: Pinput(
              length: widget.length,
              controller: _controller,
              focusNode: focusNode,
              defaultPinTheme: defaultPinTheme,
              autofocus: widget.autofocus,
              obscureText: widget.obscureText,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              onChanged: (value) {
                onFieldChanged?.call(value);
                widget.onChanged?.call(value);
              },
              onCompleted: (pin) {
                widget.onCompleted?.call(pin);
              },
              focusedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  border: Border.all(color: AppColors.primary),
                ),
              ),
              errorPinTheme: defaultPinTheme.copyWith(
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.red),
                ),
              ),
              forceErrorState: hasError,
            ),
          ),
          if (hasError) ...[
            6.verticalSpace,
            Text(
              errorText,
              style: TextStyle(color: Colors.red, fontSize: 12.sp),
            ),
          ],
        ],
      );
    }

    if (widget.fieldName == null) {
      return buildPinput();
    }

    return FormBuilderField<String>(
      name: widget.fieldName!,
      initialValue: widget.initialValue ?? _controller.text,
      validator: FormBuilderValidators.compose([
        if (widget.isRequired)
          FormBuilderValidators.required(
            errorText: lang('This field is required'),
          ),
        FormBuilderValidators.minLength(
          widget.length,
          errorText: lang('Must be ${widget.length} digits'),
        ),
        if (widget.customValidator != null) widget.customValidator!,
      ]),
      builder: (FormFieldState<String?> field) {
        if ((field.value ?? '') != _controller.text) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _controller.text = field.value ?? '';
          });
        }
        return buildPinput(
          errorText: field.errorText,
          onFieldChanged: (value) {
            field.didChange(value);
          },
        );
      },
    );
  }
}
