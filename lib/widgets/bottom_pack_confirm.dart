import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buttomPackConfirm(BuildContext context, int Status,
    {VoidCallback? oncreate,
    VoidCallback? onSubmit,
    VoidCallback? onList,
    VoidCallback? onCart,
    VoidCallback? onBack}) {
  return Container(
    margin: EdgeInsets.all(10),
    child: Column(
      children: [
        (Status == 0)
            ? Row(
                children: <Widget>[
                  // Button send image
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.blue.shade700,
                        textStyle: const TextStyle(fontSize: 18)),
                    onPressed: onCart,
                    child: Row(
                      // Replace with a Row for horizontal icon + text
                      children: <Widget>[
                        Icon(Icons.add),
                        Text("สร้างกล่องใหม่")
                      ],
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
                      children: <Widget>[
                        Icon(Icons.check),
                        Text("ส่งพิมพ์เอกสาร")
                      ],
                    ),
                  ),
                ],
              )
            : Container(),
        SizedBox(
          height: 5,
        ),
        Row(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.amber.shade700,
                  textStyle: const TextStyle(fontSize: 18)),
              onPressed: onList,
              child: Row(
                // Replace with a Row for horizontal icon + text
                children: <Widget>[
                  Icon(Icons.list_alt),
                  Text("รายการ-จัดการกล่อง")
                ],
              ),
            ),
            SizedBox(
              width: 5,
            ),
            // ElevatedButton(
            //   style: ElevatedButton.styleFrom(
            //       primary: Colors.cyan.shade400,
            //       textStyle: const TextStyle(fontSize: 18)),
            //   onPressed: onCart,
            //   child: Row(
            //     // Replace with a Row for horizontal icon + text
            //     children: <Widget>[
            //       Icon(Icons.add_box_outlined),
            //       Text("นับร่วมกัน")
            //     ],
            //   ),
            // ),
          ],
        ),
      ],
    ),
  );
}
