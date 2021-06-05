import 'package:flutter/material.dart';

class FullImage extends StatefulWidget {
  final String image;
  final int id;
  FullImage({this.image, this.id});

  @override
  _FullImageState createState() => _FullImageState();
}

class _FullImageState extends State<FullImage> {
  bool _favourite = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            child: Image(
              image: widget.id == 1 ? NetworkImage(widget.image): AssetImage(widget.image),
              // fit: BoxFit.cover,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_ios_rounded,
                      size: 25,
                    )),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _favourite = !_favourite;
                    });
                  },
                  child: Icon(
                    _favourite
                        ? Icons.favorite_outlined
                        : Icons.favorite_border,
                    size: 25,
                    color: _favourite ? Colors.red : Colors.black,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
