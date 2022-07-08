import 'package:flutter/cupertino.dart';

abstract class Player{
  void setName(String c);
  void setFavColor(Color c);
  void setRate(int c);
  String getName();
  Color getFavColor();
  int getRate();
}