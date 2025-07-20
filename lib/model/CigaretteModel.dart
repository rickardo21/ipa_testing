import 'package:flutter_project_app/Enums/CigaretteType.dart';

class Cigarettemodel {

    static int _idCounter = 0;

    final int id;
    final DateTime timestamp;
    final String infoAbout;
    final int month;
    final CigaretteType type;
    final int quantity;

   Cigarettemodel({
    required this.month,
    this.infoAbout = "",
    this.type = CigaretteType.REGULAR,
    this.quantity = 1,
  })  : id = _idCounter++,
        timestamp = DateTime.now();

}