import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '/consts/consts.dart';

class TextboxWidgetDatepicker extends StatefulWidget {
  const TextboxWidgetDatepicker({
    Key? key,
    required this.controller,
    this.hintText = '',
    this.lableText = '',
    this.initialDate,
    this.firstDate,
    this.lastDate,
  }) : super(key: key);

  final TextEditingController controller;
  final String lableText;
  final String hintText;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;

  @override
  State<TextboxWidgetDatepicker> createState() =>
      _TextboxWidgetDatepickerState();
}

class _TextboxWidgetDatepickerState extends State<TextboxWidgetDatepicker> {
  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: widget.controller.text == ''
          ? widget.initialDate ?? DateTime.now()
          : DateFormat("yyyy-MM-dd").parse(widget.controller.text),
      firstDate: widget.firstDate ??
          DateTime.now().add(const Duration(days: -(350 * 100))),
      lastDate: widget.lastDate ?? DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.primary,
              onSurface: AppColors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (selected != null) {
      widget.controller.text = DateFormat('yyyy-MM-dd').format(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          //color: Colors.grey.shade300,
        ),
        child: TextFormField(
          style: TextStyle(
            color: AppColors.black,
            fontSize: 16.sp,
          ),
          cursorColor: AppColors.primary,
          controller: widget.controller,
          keyboardType: TextInputType.datetime,
          readOnly: true,
          onTap: () {
            _selectDate(context);
          },
          decoration: InputDecoration(
            labelText: widget.lableText,
            hintText: widget.hintText,
            labelStyle: TextStyle(
              color: AppColors.black.withOpacity(0.6),
              fontSize: 14.sp,
            ),
            hintStyle: TextStyle(
              color: AppColors.black,
              fontSize: 14.sp,
            ),
            fillColor: Colors.white,
            filled: true,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 10,
            ),
            suffixIcon: Icon(
              Icons.date_range,
              color: AppColors.primary,
              size: 16.sp,
            ),
            suffixIconConstraints: const BoxConstraints(
              maxWidth: 30,
              minWidth: 30,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.border,
                width: 0.8,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.border,
                width: 0.8,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.border,
                width: 0.8,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.border,
                width: 0.8,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            disabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.border,
                width: 0.8,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return widget.hintText;
            }
            return null;
          },
        ),
      ),
    );
  }
}
