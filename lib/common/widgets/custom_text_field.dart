import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode node;
  final FocusNode? nextNode;
  final String hintTextMain;
  final Color backgroundColor;
  final Color borderActiveColor;
  final Color textColor;
  final Color activeTextColor;
  final Color textFieldTextColor;
  final bool isWritable;
  final Function(String val)? onChange;
  final String? hintText;
  final Function()? tapOn;
  final bool isNum;
  final int maxLength;
  final bool isPassword;
  final Iterable<String>? autofillHints;
  final double borderRadius;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.node,
    required this.hintTextMain,
    this.onChange,
    this.hintText,
    this.tapOn,
    this.isNum = false,
    this.maxLength = 50,
    this.isPassword = false,
    this.autofillHints,
    this.nextNode,
    this.backgroundColor = Colors.transparent,
    this.borderActiveColor = Colors.blue,
    this.textColor = Colors.black,
    this.activeTextColor = Colors.blue,
    this.textFieldTextColor = Colors.black,
    this.isWritable = true,
    this.borderRadius = 5.0,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isHide = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.hintText != null)
          Text(
            widget.hintText!,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16.5,
              color: widget.node.hasFocus
                  ? widget.activeTextColor
                  : widget.textColor,
            ),
          ),
        SizedBox(height: 10), // Replaced with a static value
        TextField(
          controller: widget.controller,
          focusNode: widget.node,
          maxLength: widget.maxLength,
          keyboardType:
              widget.isNum ? TextInputType.number : TextInputType.text,
          obscureText: widget.isPassword ? isHide : false,
          autofillHints: widget.autofillHints,
          enabled: widget.isWritable,
          style: TextStyle(color: widget.textFieldTextColor),
          textInputAction: widget.nextNode != null
              ? TextInputAction.next
              : TextInputAction.done,
          onChanged: widget.onChange,
          onSubmitted: (value) {
            if (widget.nextNode != null) {
              widget.node.unfocus();
              FocusScope.of(context).requestFocus(widget.nextNode);
            }
          },
          decoration: InputDecoration(
            hintText: widget.hintTextMain,
            counterText: '',
            filled: true,
            fillColor: widget.backgroundColor,
            hintStyle: TextStyle(color: Colors.grey),
            suffixIcon: widget.isPassword
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        isHide = !isHide;
                      });
                    },
                    icon:
                        Icon(isHide ? Icons.visibility : Icons.visibility_off),
                  )
                : null,
            enabledBorder: _buildBorder(Colors.grey),
            disabledBorder: _buildBorder(Colors.grey),
            focusedBorder: _buildBorder(widget.borderActiveColor),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _buildBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      borderSide: BorderSide(color: color),
    );
  }
}
