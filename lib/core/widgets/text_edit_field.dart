import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TextEditField extends StatefulWidget {
  final String hint;
  final bool password;
  final TextInputType inputType;
  final RxString? onSaved;
  final String? Function(String?) validator;
  final Function()? showPassword;
  final bool obscure;
  final TextCapitalization capitalization;
  final bool filled;
  final Color fillColor;
  final bool communityField;
  final bool tall;
  final String initial;

  const TextEditField({
    Key? key,
    required this.hint,
    required this.validator,
    this.onSaved,
    this.password = false,
    this.inputType = TextInputType.text,
    this.showPassword,
    this.obscure = false,
    this.capitalization = TextCapitalization.none,
    this.filled = false,
    this.fillColor = Colors.white,
    this.communityField = false,
    this.initial = "",
    this.tall = false,
  }) : super(key: key);

  @override
  State<TextEditField> createState() => _TextEditFieldState();
}

class _TextEditFieldState extends State<TextEditField> {
  final TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: widget.password ? 12.0 : 0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 3.0,
            spreadRadius: 1.0,
          ),
        ],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: TextFormField(
              obscureText: widget.obscure,
              keyboardType: widget.inputType,
              initialValue: widget.initial,
              validator: widget.validator,
              onSaved: (value) {
                widget.onSaved?.value = value!;
              },
              minLines: widget.tall ? 5 : 1,
              maxLines: widget.tall ? 5 : 1,
              textCapitalization: widget.capitalization,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
                hintText: widget.hint,
                border: _fieldBorder(),
                focusedBorder: _fieldBorder(),
                enabledBorder: _fieldBorder(),
                errorBorder: _fieldBorder(),
                disabledBorder: _fieldBorder(),
                filled: widget.filled,
                fillColor: widget.fillColor,
                hintStyle: const TextStyle(
                  color: Color(0xffBDBDBD),
                ),
              ),
            ),
          ),
          widget.password
              ? GestureDetector(
                  onTap: widget.showPassword,
                  child: Icon(
                    widget.obscure ? Icons.visibility : Icons.visibility_off,
                    color: Get.theme.primaryColor,
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  InputBorder _fieldBorder() {
    if (widget.communityField) {
      return OutlineInputBorder(
        borderSide: BorderSide(color: const Color(0xff828282).withOpacity(.3)),
        borderRadius: BorderRadius.circular(10),
      );
    } else {
      return InputBorder.none;
    }
  }
}
