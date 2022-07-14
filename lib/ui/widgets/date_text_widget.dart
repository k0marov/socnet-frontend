import 'package:flutter/cupertino.dart';

class DateTextWidget extends StatelessWidget {
  final DateTime date;
  const DateTextWidget({Key? key, required this.date}) : super(key: key);

  static const _months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "June",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

  @override
  Widget build(BuildContext context) {
    return Text("${_months[date.month]}, ${date.day}");
  }
}
