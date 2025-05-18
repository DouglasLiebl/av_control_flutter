import 'package:demo_project/presentation/style/default_colors.dart';
import 'package:flutter/material.dart';

class CustomInputField extends StatefulWidget {
  final String? hintText;
  final String label;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final bool isLoading;
  final bool? isPassword;
  final Icon? prefixIcon;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final VoidCallback? onSubmit;

  const CustomInputField({
    super.key,
    this.hintText,
    required this.label,
    required this.keyboardType,
    required this.controller,
    required this.isLoading,
    this.isPassword = false,
    this.prefixIcon,
    this.focusNode,
    this.textInputAction,
    this.onSubmit
  });

  @override
  State<StatefulWidget> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  bool _showPassword = true; 

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          alignment: Alignment.centerLeft,
          child: Text(
            widget.label,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontFamily: "JetBrains Mono",
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          enabled: widget.isLoading ? false : true,
          keyboardType: widget.keyboardType,
          controller: widget.controller,
          cursorColor: Colors.black,
          obscureText: (widget.isPassword ?? false) ? _showPassword : false,
          focusNode: widget.focusNode,
          textInputAction: widget.textInputAction,
          onFieldSubmitted: widget.onSubmit != null ? (_) => widget.onSubmit!() : null,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontFamily: "JetBrains Mono"
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(
              fontFamily: "JetBrains Mono",
              color: DefaultColors.textGray(),
              fontSize: 14,
            ), 
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: const Color.fromARGB(255, 128, 126, 126),
                width: 3.0,
              )
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: const Color.fromARGB(255, 194, 189, 189)
              )
            ),
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.isPassword == true
            ? IconButton(
                icon: Icon(
                  _showPassword ? Icons.visibility : Icons.visibility_off,
                  color: DefaultColors.subTitleGray(),
                ),
                onPressed: () {
                  setState(() {
                    _showPassword = !_showPassword;
                  });
                },
              )
            : null,
          ),
        )
      ],
    );
  }
}