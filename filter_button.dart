// ignore_for_file: must_be_immutable, no_logic_in_create_state

import 'package:flutter/material.dart';

class FilterButton extends StatefulWidget {
  FilterButton(this.text, {super.key});
  String text;
  @override
  State<StatefulWidget> createState() => _FilterButtonState(text);
}

class _FilterButtonState extends State<FilterButton> {
  bool pressed = false;
  String text;
  _FilterButtonState(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
      child: TextButton(
          onPressed: (() {
            setState(() {
              pressed = !pressed;
            });
          }),
          style: ButtonStyle(
              backgroundColor: pressed
                  ? MaterialStateProperty.all(
                      const Color.fromRGBO(255, 180, 0, 1))
                  : MaterialStateProperty.all(Colors.white),
              side: pressed
                  ? MaterialStateProperty.all(const BorderSide(
                      color: Color.fromRGBO(255, 180, 0, 1),
                      width: 0.0,
                    ))
                  : MaterialStateProperty.all(const BorderSide(
                      color: Colors.black,
                      width: 2.0,
                      style: BorderStyle.solid)),
              padding: MaterialStateProperty.all<EdgeInsets>(
                  const EdgeInsets.all(10)),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)))),
          child: Text(text,
              style: pressed
                  ? const TextStyle(fontSize: 15, color: Colors.white)
                  : const TextStyle(fontSize: 15, color: Colors.black))),
    );
  }
}
