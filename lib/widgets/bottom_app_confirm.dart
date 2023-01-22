import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buttomAppConfirm(BuildContext context,
    {VoidCallback? oncreate, VoidCallback? onSubmit}) {
  return Container(
    margin: EdgeInsets.all(10),
    child: Column(
      children: [
        Row(
          children: <Widget>[
            // Button send image
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.amber.shade700,
                  textStyle: const TextStyle(fontSize: 18)),
              onPressed: oncreate,
              child: Row(
                // Replace with a Row for horizontal icon + text
                children: <Widget>[Icon(Icons.add), Text("สร้างกล่องใหม่")],
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
                children: <Widget>[Icon(Icons.check), Text("ส่งพิมพ์เอกสาร")],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Row(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.green.shade400,
                  textStyle: const TextStyle(fontSize: 18)),
              onPressed: onSubmit,
              child: Row(
                // Replace with a Row for horizontal icon + text
                children: <Widget>[
                  Icon(Icons.list_alt),
                  Text("รายการ-จัดการกล่อง")
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
