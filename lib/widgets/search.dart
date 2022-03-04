import 'package:flutter/material.dart';

class Search extends StatelessWidget {
  final String hint;
  final bool hide = true;
  final Function onSubmit;
  final Function pressed;
  final Function onChange;
  final TextEditingController controller;
  Search(
      {this.hint, this.onSubmit, this.onChange, this.pressed, this.controller});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: double.infinity,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: TextField(
        onEditingComplete: () {
          FocusScope.of(context).unfocus();
        },
        controller: controller,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.deepOrange, fontSize: 17),
        // onChanged: onChanged,
        onSubmitted: onSubmit,
        onChanged: onChange,
        decoration: InputDecoration(
          // contentPadding: EdgeInsets.only(bottom: 5),
          border: InputBorder.none,
          hintText: hint,
          suffixIcon: GestureDetector(
            onTap: pressed,
            child: Container(
              height: 40,
              child: Container(
                child: Icon(
                  Icons.search,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.circular(20)),
            ),
          ),
        ),
      ),
    );
  }
}
