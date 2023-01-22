import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buttomPackFormConfirm(BuildContext context,
    {VoidCallback? onBack, VoidCallback? onSubmit}) {
  return Container(
    margin: EdgeInsets.all(10),
    child: Column(
      children: [
        Row(
          children: <Widget>[
            // Button send image
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.purple.shade700,
                  textStyle: const TextStyle(fontSize: 18)),
              onPressed: onBack,
              child: Row(
                // Replace with a Row for horizontal icon + text
                children: <Widget>[Icon(Icons.arrow_back_ios), Text("กลับ")],
              ),
            ),
            SizedBox(width: 5),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.green.shade400,
                  textStyle: const TextStyle(fontSize: 18)),
              onPressed: onSubmit,
              child: Row(
                // Replace with a Row for horizontal icon + text
                children: <Widget>[Icon(Icons.save), Text("บันทึก")],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
