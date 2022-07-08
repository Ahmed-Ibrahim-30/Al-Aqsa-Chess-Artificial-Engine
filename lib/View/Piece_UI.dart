
import 'package:flutter/material.dart';

class pieceUi extends StatefulWidget {
  var boardCells,index;

  pieceUi( this.boardCells,this.index);
  @override
  pieceUiState createState() => pieceUiState(this.boardCells,this.index);
}

class pieceUiState extends State<pieceUi> {
  var Board_cells,index;

  int a=0;
  Color color2=Colors.red;
  pieceUiState(this.Board_cells,this.index);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
          height: 55,
          color: Board_cells.elementAt(index).color,
          child: InkWell(
            onTap: ()=>setState((){
              Board_cells.elementAt(1).color=Colors.red;
            }),
            child: Board_cells.elementAt(index).image!=""?Image.asset(Board_cells.elementAt(index).image):null,
          ),
      ),
    );
  }
}
