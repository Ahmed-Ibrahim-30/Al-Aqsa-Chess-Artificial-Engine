import 'package:chess_ai/Model/Piece.dart';

class Move{
  String pieceName;
  int pieceIndex;
  int targetIndex;
  List<Piece> board=[];
  int evaluation=0;
  List<int>whitePlayerIndex=[];
  List<int>blackPlayerIndex=[];
  int alpha=-5000;
  int beta=5000;

  Move(this.pieceIndex,this.targetIndex,this.pieceName,this.board,this.whitePlayerIndex,this.blackPlayerIndex);

  set old(int o)=>pieceIndex=o;
  set new1(int n)=>targetIndex=n;

  int get oldIn{return pieceIndex;}
  int get newIn{return targetIndex;}

}