import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StackCon extends StatelessWidget {
  final String text;
  StackCon({this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      width: double.infinity,
      child: Stack(alignment: AlignmentDirectional.center, children: [
        ClipRRect(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20)),
          child: Image(
            image: AssetImage('assets/static/avekenedy.jpg'),
            fit: BoxFit.cover,
            height: 300,
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20)),
          child: Container(
            width: double.infinity,
            height: 220,
            color: Colors.black26,
          ),
        ),
        Center(
          child: Text('BiZi',
              style: GoogleFonts.cookie(
                  fontSize: 70,
                  fontWeight: FontWeight.w600,
                  color: Colors.white)),
        ),
        SizedBox(height: 10),
        
      ]),
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.4),
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20))),
    );
  }
}
