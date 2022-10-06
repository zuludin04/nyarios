import 'package:flutter/material.dart';

class AuthInputField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final String? Function(String?) validator;
  final TextInputType inputType;
  final bool obscure;

  const AuthInputField({
    super.key,
    required this.label,
    required this.validator,
    required this.controller,
    this.hint = "",
    this.inputType = TextInputType.text,
    this.obscure = false,
  });

  @override
  State<AuthInputField> createState() => _AuthInputFieldState();
}

class _AuthInputFieldState extends State<AuthInputField> {
  bool showPassword = false;
  bool obscure = false;

  @override
  void initState() {
    obscure = widget.obscure;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label),
        const SizedBox(height: 8),
        Container(
          padding: EdgeInsets.only(right: widget.obscure ? 12.0 : 0),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 0.5,
                spreadRadius: 0.3,
              ),
            ],
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: TextFormField(
                  controller: widget.controller,
                  obscureText: obscure,
                  keyboardType: widget.inputType,
                  validator: widget.validator,
                  maxLines: 1,
                  decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12.0),
                    hintText: widget.hint,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintStyle: const TextStyle(
                      color: Color(0xffBDBDBD),
                    ),
                  ),
                ),
              ),
              widget.obscure
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          obscure = !obscure;
                          showPassword = !showPassword;
                        });
                      },
                      child: Icon(
                        showPassword ? Icons.visibility : Icons.visibility_off,
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ],
    );
  }
}
