import 'package:flutter/material.dart';

class ImageButton extends StatefulWidget {
  final String imagePath;
  final double width;
  final double height;
  final double imageWidth;
  final double imageHeight;
  final Function onPress;

  const ImageButton(
      {Key key,
      this.imagePath,
      this.width,
      this.height,
      this.onPress,
      this.imageHeight,
      this.imageWidth})
      : super(key: key);

  @override
  _ImageButtonState createState() => _ImageButtonState();
}

class _ImageButtonState extends State<ImageButton> {
  bool showBackgount = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          showBackgount = true;
        });
      },
      onTapCancel: () {
        setState(() {
          showBackgount = false;
        });
      },
      onTapUp: (_) {
        setState(() {
          showBackgount = false;
        });
      },
      onTap: () {
        widget.onPress();
      },
      child: Container(
        width: widget.width,
        height: widget.height,
        padding: EdgeInsets.all(9),

        decoration: BoxDecoration(
          color: showBackgount? Color(0xFFF0F0F0)
              : Colors.white,
          borderRadius: BorderRadius.circular(50),
        ),


        child: Image.asset(
          '${widget.imagePath}',
          width: widget.width,
          height: widget.height,
        ),

      ),
    );
  }
}
