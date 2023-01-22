import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:mobilepacking/global.dart';

class MenuStruct {
  final String name;
  final Color color;
  final IconData icon;
  final menuId targetId;

  MenuStruct(
      {this.name = "",
      this.color = Colors.black,
      this.icon = Icons.ac_unit,
      this.targetId = menuId.packingSO});
}
