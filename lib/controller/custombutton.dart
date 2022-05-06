import 'package:clinic/style/color.dart';
import 'package:flutter/material.dart';

class EditButton extends StatelessWidget {
  const EditButton({Key? key, required this.onPressed}) : super(key: key);
  final GestureTapCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
            border: Border.all(color: primaryColor, width: 2),
            borderRadius: BorderRadius.circular(100)),
        child: IconButton(
            tooltip: 'ແກ້ໄຂ',
            iconSize: 20,
            padding: const EdgeInsets.all(0),
            onPressed: onPressed,
            icon: const Icon(Icons.edit, color: primaryColor)));
  }
}

class DeleteButton extends StatelessWidget {
  const DeleteButton({Key? key, required this.onPressed}) : super(key: key);
  final GestureTapCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.red, width: 2),
            borderRadius: BorderRadius.circular(100)),
        child: IconButton(
            tooltip: 'ລຶບ',
            iconSize: 20,
            padding: const EdgeInsets.all(0),
            onPressed: onPressed,
            icon: const Icon(Icons.delete, color: Colors.red)));
  }
}
