import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InputField extends StatelessWidget {
  final String hint;
  final String prefixText;
  final String helper;
  final String image;
  final bool obscureText;
  final List inputFormatters;
  final TextInputType textInputType;
  final Function validator;
  final IconData prefixIcon;
  final IconData suffixIcon;
  final Widget suffiximage;
  final Function sufixTap;
  final Function onSaved;
  final TextEditingController controller;
  final Function onChange;
  final bool chat;
  final Function onPressed;

  InputField(
      {
      this.suffiximage,
      this.image,
      this.hint,
      this.prefixText,
      this.obscureText = false,
      this.inputFormatters,
      this.textInputType,
      this.validator,
      this.prefixIcon,
      this.suffixIcon,
      this.sufixTap,
      this.onSaved,
      this.controller,
      this.helper,
      this.onChange,
      this.onPressed,
      this.chat = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: chat ? 10 : 30, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: textInputType,
        validator: validator,
        inputFormatters: inputFormatters,
        textAlign: TextAlign.start,
        onChanged: onChange,
        style: GoogleFonts.k2d(
            fontSize: 17, color: Colors.orange, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          prefixText: prefixText,
          prefixStyle: TextStyle(),
          fillColor: chat ? Colors.black26 : Colors.white,
          focusColor: Colors.orange,
          hoverColor: Colors.orange,
          helperText: helper,
          helperStyle:
              GoogleFonts.k2d(color: Colors.red, fontWeight: FontWeight.w600),
          filled: true,
          contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
          prefixIcon:
          chat? Icon(
              prefixIcon,
              color: Colors.white,
              size: chat ? 30 : 15,
            ):
           Container(
            height: 15,
            width: 20,
            padding: EdgeInsets.all(5),
            child: Image(
              image: AssetImage(image),
              height: 15,
              width: 18,
              fit: BoxFit.cover,
            ),

            
          ),
          suffix: GestureDetector(
            onTap: sufixTap,
            child: Container(
              padding: EdgeInsets.only(right: 3),
              child:suffiximage,
            ),
          ),
          helperMaxLines: 1,
          errorStyle: TextStyle(color: Colors.red),
          errorMaxLines: 12,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: BorderSide(color: Colors.orange, width: 0.3),
          ),
          hintText: hint,
          hintStyle:
              TextStyle(color: Colors.black54, fontWeight: FontWeight.w400),
        ),
        onSaved: onSaved,
      ),
    );
  }
}
