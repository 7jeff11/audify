import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function onPressed;

  const CustomButton(
      {Key? key,
        required this.icon,
        required this.title,
        required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onPressed();
      },
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Icon(
                  icon,
                  color: Color(0xFF5C3882),
                  size: 40,
                ),
              ),
            ),
            Container(
                decoration: BoxDecoration(
                    color: Color(0xFF5C3882),
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(10))
                ),
                width: double.maxFinite,
                height: 40,
                child: Center(
                  child: Text(
                    title,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ))
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
