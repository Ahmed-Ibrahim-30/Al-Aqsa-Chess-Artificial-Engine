
import 'package:chess_ai/Model/Alpha_beta.dart';
import 'package:chess_ai/Model/Board.dart';
import 'package:chess_ai/Model/Move.dart';
import 'package:flutter/material.dart';



class BoardUI extends StatefulWidget{
  const BoardUI({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() =>BoardUIState();
}
class BoardUIState extends State<BoardUI>
{
  Board1 board=Board1(true);
  int selectedPiece=0;
  late final double width=MediaQuery.of(context).size.width/8.0;
  late final double height=MediaQuery.of(context).size.height/15.0;
  var list ;
  Move move=Move(-1,-1,"",[],[],[]);

  Widget pieceUI(int index){
    return Expanded(
      child: Container(
        height: height,
        color: board.boardCells.elementAt(index).color,
        child: InkWell(
          onDoubleTap: ()=> setState((){board.resetAllPieces();}),
          onTap: ()=>setState((){
             String colorPiece=board.boardCells.elementAt(index).name;
             bool isMate=colorPiece.contains("B")?board.blackCheckMate:board.whiteCheckMate;//king state

            if((board.whitePlayer && colorPiece.contains("W"))|| (!board.whitePlayer && colorPiece.contains("B"))){
              list = board.copyBoard();
              int kingIndex=board.getKingIndex(board.whitePlayer);
              String imageCopy=board.boardCells.elementAt(index).image;
              board.clearPiece(index);
              bool checkAfter=board.checkMate(kingIndex,true,color: colorPiece.contains("B")?"B":"W");
              board.boardCells.elementAt(index).image=imageCopy;
              board.boardCells.elementAt(index).name=colorPiece;
               if(isMate)checkAfter=false;

              if(colorPiece.contains("Pawn") ) {
                board.resetAllPieces();
                if(!checkAfter){
                  board.busyPieces.addAll(board.pawnLaw(colorPiece,index,false,isMate));
                }
                else if(checkAfter){
                  List<int>test=[];
                  test.addAll(board.pawnLaw(colorPiece,index,true,isMate));
                  if(test.contains(board.checkMatePath.first)){
                    board.boardCells.elementAt(board.checkMatePath.first).color=Colors.redAccent;
                    board.busyPieces.add(board.checkMatePath.first);
                  }
                }
              }
              if((colorPiece.contains("Rook") || colorPiece.contains("Queen"))) {
                board.resetAllPieces();
                if(!checkAfter) {board.busyPieces.addAll(board.rookLaw(colorPiece,index,false,isMate));}
                else{
                  List<int>test=[];
                  test.addAll(board.rookLaw(colorPiece,index,true,isMate));
                  if(test.contains(board.checkMatePath.first)){
                    board.boardCells.elementAt(board.checkMatePath.first).color=Colors.redAccent;
                    board.busyPieces.add(board.checkMatePath.first);
                  }
                }
              }
              if((colorPiece.contains("bishop") || colorPiece.contains("Queen"))) {
                if(!colorPiece.contains("Queen")) {board.resetAllPieces();}
                if(!checkAfter){board.busyPieces.addAll(board.bishopLaw(colorPiece,index,false,isMate));}
                else{
                  List<int>test=[];
                  test.addAll(board.bishopLaw(colorPiece,index,true,isMate));
                  if(test.contains(board.checkMatePath.first)){
                    board.boardCells.elementAt(board.checkMatePath.first).color=Colors.redAccent;
                    board.busyPieces.add(board.checkMatePath.first);
                  }
                }
              }
              if(colorPiece.contains("Knight")) {
                board.resetAllPieces();
                if(!checkAfter){board.busyPieces.addAll(board.knightLaw(colorPiece,index,false,isMate));}
                else{

                  List<int>test=[];
                  test.addAll(board.knightLaw(colorPiece,index,true,isMate));
                  if(test.contains(board.checkMatePath.first)){
                    board.boardCells.elementAt(board.checkMatePath.first).color=Colors.redAccent;
                    board.busyPieces.add(board.checkMatePath.first);
                  }
                }
              }
              if(colorPiece.contains("King")) {
                board.resetAllPieces();
                board.busyPieces.addAll(board.kingLaw(colorPiece, index,false,isMate));
              }
              selectedPiece=index;
            }
            else if(board.boardCells.elementAt(index).image=="Images/circle5.png" || board.boardCells.elementAt(index).color==Colors.redAccent)
            {
              board.resetAllPieces();
              colorPiece=board.boardCells.elementAt(selectedPiece).name;

              move=Move(selectedPiece,index,colorPiece.substring(2),list,List.of(board.whitePlayerIndex),List.of(board.blackPlayerIndex));
              board.makeMove(move);

              int oppKingIndex=board.getKingIndex(!board.whitePlayer);
              int sameKingIndex=board.getKingIndex(board.whitePlayer);
              board.whitePlayer=!board.whitePlayer;
              bool oppCheck=board.checkMate(oppKingIndex,true);
              bool sameCheck=board.checkMate(sameKingIndex,true);
              if(oppCheck){
                board.boardCells.elementAt(oppKingIndex).color=Colors.blueAccent;
                board.whiteCheckMate=board.boardCells.elementAt(index).name.contains("B")?true:false;
                board.blackCheckMate=board.boardCells.elementAt(index).name.contains("W")?true:false;
                //print(board.getPossibleMoves(board.whitePlayer?board.whitePlayerIndex:board.blackPlayerIndex,true));
                if(board.getPossibleMoves(board.whitePlayer?board.whitePlayerIndex:board.blackPlayerIndex).isEmpty) {
                  if(!board.whitePlayer)print("Player 1 Won");
                  else print("Player 2 Won");
                }
              }
              if(!sameCheck){
                 if(colorPiece.contains("King")) { board.returnFromCheckMate(selectedPiece); }
                 else { board.returnFromCheckMate(sameKingIndex); }
                 board.checkMatePath.clear();
                 board.whiteCheckMate=board.boardCells.elementAt(index).name.contains("W")?false:board.whiteCheckMate;
                 board.blackCheckMate=board.boardCells.elementAt(index).name.contains("B")?false:board.blackCheckMate;
              }

            }
          }
          ),
          child: board.boardCells.elementAt(index).image!=""?Image.asset(board.boardCells.elementAt(index).image):null,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {

    if(board.whitePlayer==false){
      Move blackMove=alphaBeta2(false,board,move, 3,true);
      if(blackMove.pieceIndex!=-1) {
        board.makeMove(blackMove);


        int oppKingIndex=board.getKingIndex(true);
        int sameKingIndex=board.getKingIndex(false);
        board.whitePlayer=true;
        bool oppCheck=board.checkMate(oppKingIndex,true);
        bool sameCheck=board.checkMate(sameKingIndex,true);
        if(oppCheck){
          board.boardCells.elementAt(oppKingIndex).color=Colors.blueAccent;
          board.whiteCheckMate=true;
          if(board.getPossibleMoves(board.whitePlayer?board.whitePlayerIndex:board.blackPlayerIndex).isEmpty) {
            if(!board.whitePlayer)print("Player 1 Won");
            else print("Player 2 Won");
          }
        }
        if(!sameCheck){
          if(board.boardCells[blackMove.targetIndex].name.contains("King")) { board.returnFromCheckMate(blackMove.pieceIndex); }
          else { board.returnFromCheckMate(sameKingIndex); }
          board.checkMatePath.clear();
          board.blackCheckMate==false;
        }
      }
    }


    return SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    pieceUI(0),  const SizedBox(width: 0.6,),
                    pieceUI(1),const SizedBox(width: 0.6),
                    pieceUI(2),const SizedBox(width: 0.6),
                    pieceUI(3),const SizedBox(width: 0.6),
                    pieceUI(4),const SizedBox(width: 0.6),
                    pieceUI(5),const SizedBox(width: 0.6),
                    pieceUI(6),const SizedBox(width: 0.6),
                    pieceUI(7),
                  ]
                ),
                const SizedBox(height: 1,),
                Row(
                  children: [
                    pieceUI(8),
                    pieceUI(9),
                    pieceUI(10),
                    pieceUI(11),
                    pieceUI(12),
                    pieceUI(13),
                    pieceUI(14),
                    pieceUI(15),
                  ],
                ),
                const SizedBox(height: 1,),
                Row(
                  children: [
                    pieceUI(16),
                    pieceUI(17),
                    pieceUI(18),
                    pieceUI(19),
                    pieceUI(20),
                    pieceUI(21),
                    pieceUI(22),
                    pieceUI(23),
                  ],
                ),
                const SizedBox(height: 1,),
                Row(
                  children: [
                    pieceUI(24),
                    pieceUI(25),
                    pieceUI(26),
                    pieceUI(27),
                    pieceUI(28),
                    pieceUI(29),
                    pieceUI(30),
                    pieceUI(31),
                  ],
                ),
                const SizedBox(height: 1,),
                Row(
                  children: [
                    pieceUI(32),
                    pieceUI(33),
                    pieceUI(34),
                    pieceUI(35),
                    pieceUI(36),
                    pieceUI(37),
                    pieceUI(38),
                    pieceUI(39),
                  ],
                ),
                const SizedBox(height: 1,),
                Row(
                  children: [
                    pieceUI(40),
                    pieceUI(41),
                    pieceUI(42),
                    pieceUI(43),
                    pieceUI(44),
                    pieceUI(45),
                    pieceUI(46),
                    pieceUI(47),
                  ],
                ),
                const SizedBox(height: 1,),
                Row(
                  children: [
                    pieceUI(48),
                    pieceUI(49),
                    pieceUI(50),
                    pieceUI(51),
                    pieceUI(52),
                    pieceUI(53),
                    pieceUI(54),
                    pieceUI(55),
                  ],
                ),
                const  SizedBox(height: 1,),
                Row(
                  children: [
                    pieceUI(56), const SizedBox(width: 0.6),
                    pieceUI(57), const SizedBox(width: 0.6),
                    pieceUI(58), const SizedBox(width: 0.6),
                    pieceUI(59), const SizedBox(width: 0.6),
                    pieceUI(60), const SizedBox(width: 0.6),
                    pieceUI(61), const SizedBox(width: 0.6),
                    pieceUI(62), const SizedBox(width: 0.6),
                    pieceUI(63),
                  ],
                ),
                const SizedBox(height: 1,),
              ],
            ),
          ],
        )
    );
  }
}