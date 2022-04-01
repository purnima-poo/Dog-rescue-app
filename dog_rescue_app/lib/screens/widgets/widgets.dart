import 'package:flutter/material.dart';

Widget greenButton(BuildContext context, String label) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 18),
    decoration: BoxDecoration(
        color: Colors.teal, borderRadius: BorderRadius.circular(30)),
    alignment: Alignment.center,
    width: MediaQuery.of(context).size.width - 48,
    child: Text(
      label,
      style: TextStyle(color: Colors.white, fontSize: 15.5),
    ),
  );
}
