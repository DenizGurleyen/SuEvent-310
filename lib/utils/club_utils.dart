import 'package:flutter/material.dart';

Color getClubColor(String id) {
  switch (id) {
    case 'eik':
      return Colors.blueGrey;
    case 'ies':
      return Colors.indigo;
    case 'sk':
      return Colors.deepOrange;
    case 'airsoft':
      return Colors.brown;
    case 'kai':
      return Colors.deepPurple;
    case 'css':
      return Colors.teal;
    case 'ieee':
      return Colors.blue;
    case 'sudosk':
      return Colors.green;
    case 'musikus':
      return Colors.redAccent;
    default:
      return Colors.grey;
  }
}
