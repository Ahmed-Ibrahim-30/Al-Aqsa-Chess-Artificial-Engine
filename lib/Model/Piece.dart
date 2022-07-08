
import 'dart:ui';

class Piece{
  late String name;
  late String image;
  late Color color;
  late bool isMove;
  Piece(this.color,{this.name="",this.image="",this.isMove=false});

  set name1(String n)=>name=n;
  set image1(String n)=>image=n;
  set color1(Color n)=>color=n;
  set ismove(bool move)=>isMove=move;

  String get names{return name;}
  String get images{return image;}
  Color get colors{return color;}
  bool get move{return isMove;}
}