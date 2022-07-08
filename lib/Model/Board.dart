import 'dart:math';
import 'package:flutter/material.dart';
import 'Move.dart';
import 'Piece.dart';

class Board1{
  bool whitePlayer;
  final _green=Colors.green[400];
  final _white=Colors.white;
  List<int>whitePlayerIndex=[];
  List<int>blackPlayerIndex=[];
  bool whiteCheckMate=false;
  bool blackCheckMate=false;


  List<int>checkMatePath=[];//contain all path from king to any piece threat

  var move=Move(0,0,"",[],[],[]);
  List<Piece> boardCells=[];
  List<int> busyPieces=[];//possible moves  for this piece


  Board1(this.whitePlayer){
    boardCells= [
      Piece(_white,name:whitePlayer?"B_Rook":"W_Rook",image:whitePlayer?"Images/bR.png":"Images/wR.png"),
      Piece(_green!,name:whitePlayer?"B_Knight":"W_Knight",image:whitePlayer?"Images/bN.png":"Images/wN.png"),
      Piece(_white,name:whitePlayer?"B_bishop":"W_bishop",image:whitePlayer?"Images/bB.png":"Images/wB.png"),
      Piece(_green!,name:whitePlayer?"B_Queen":"W_King",image:whitePlayer? "Images/bQ.png":"Images/wK.png"),
      Piece(_white,name:whitePlayer? "B_King":"W_Queen",image:whitePlayer? "Images/bK.png":"Images/wQ.png"),
      Piece(_green!,name:whitePlayer?"B_bishop":"W_bishop",image:whitePlayer?"Images/bB.png":"Images/wB.png"),
      Piece(_white,name:whitePlayer?"B_Knight":"W_Knight",image:whitePlayer?"Images/bN.png":"Images/wN.png"),
      Piece(_green!,name:whitePlayer?"B_Rook":"W_Rook",image:whitePlayer?"Images/bR.png":"Images/wR.png"),

      Piece(_green!,name:whitePlayer?"B_Pawn":"W_Pawn",image:whitePlayer?"Images/bP.png":"Images/wP.png"),
      Piece(_white,name:whitePlayer?"B_Pawn":"W_Pawn",image:whitePlayer?"Images/bP.png":"Images/wP.png"),
      Piece(_green!,name:whitePlayer?"B_Pawn":"W_Pawn",image:whitePlayer?"Images/bP.png":"Images/wP.png"),
      Piece(_white,name:whitePlayer?"B_Pawn":"W_Pawn",image:whitePlayer?"Images/bP.png":"Images/wP.png"),
      Piece(_green!,name:whitePlayer?"B_Pawn":"W_Pawn",image:whitePlayer?"Images/bP.png":"Images/wP.png"),
      Piece(_white,name:whitePlayer?"B_Pawn":"W_Pawn",image:whitePlayer?"Images/bP.png":"Images/wP.png"),
      Piece(_green!,name:whitePlayer?"B_Pawn":"W_Pawn",image:whitePlayer?"Images/bP.png":"Images/wP.png"),
      Piece(_white,name:whitePlayer?"B_Pawn":"W_Pawn",image:whitePlayer?"Images/bP.png":"Images/wP.png"),

      Piece(_white),  Piece(_green!),  Piece(_white),  Piece(_green!),
      Piece(_white),  Piece(_green!),  Piece(_white),  Piece(_green!),

      Piece(_green!),  Piece(_white),  Piece(_green!),  Piece(_white),
      Piece(_green!),  Piece(_white),  Piece(_green!),  Piece(_white),

      Piece(_white),  Piece(_green!),  Piece(_white),  Piece(_green!),
      Piece(_white),  Piece(_green!),  Piece(_white),  Piece(_green!),

      Piece(_green!),  Piece(_white),  Piece(_green!),  Piece(_white),
      Piece(_green!),  Piece(_white),  Piece(_green!),  Piece(_white),

      Piece(_white,name:whitePlayer?"W_Pawn":"B_Pawn",image:whitePlayer?"Images/wP.png":"Images/bP.png"),
      Piece(_green!,name:whitePlayer?"W_Pawn":"B_Pawn",image:whitePlayer?"Images/wP.png":"Images/bP.png"),
      Piece(_white,name:whitePlayer?"W_Pawn":"B_Pawn",image:whitePlayer?"Images/wP.png":"Images/bP.png"),
      Piece(_green!,name:whitePlayer?"W_Pawn":"B_Pawn",image:whitePlayer?"Images/wP.png":"Images/bP.png"),
      Piece(_white,name:whitePlayer?"W_Pawn":"B_Pawn",image:whitePlayer?"Images/wP.png":"Images/bP.png"),
      Piece(_green!,name:whitePlayer?"W_Pawn":"B_Pawn",image:whitePlayer?"Images/wP.png":"Images/bP.png"),
      Piece(_white,name:whitePlayer?"W_Pawn":"B_Pawn",image:whitePlayer?"Images/wP.png":"Images/bP.png"),
      Piece(_green!,name:whitePlayer?"W_Pawn":"B_Pawn",image:whitePlayer?"Images/wP.png":"Images/bP.png"),

      Piece(_green!,name:whitePlayer?"W_Rook":"B_Rook",image:whitePlayer?"Images/wR.png":"Images/bR.png"),
      Piece(_white,name:whitePlayer?"W_Knight":"B_Knight",image:whitePlayer?"Images/wN.png":"Images/bN.png"),
      Piece(_green!,name:whitePlayer?"W_bishop":"B_bishop",image:whitePlayer?"Images/wB.png":"Images/bB.png"),
      Piece(_white,name:whitePlayer?"W_Queen":"B_King",image:whitePlayer?"Images/wQ.png":"Images/bK.png"),
      Piece(_green!,name:whitePlayer?"W_King":"B_Queen",image:whitePlayer?"Images/wK.png":"Images/bQ.png"),
      Piece(_white,name:whitePlayer?"W_bishop":"B_bishop",image:whitePlayer?"Images/wB.png":"Images/bB.png"),
      Piece(_green!,name:whitePlayer?"W_Knight":"B_Knight",image:whitePlayer?"Images/wN.png":"Images/bN.png"),
      Piece(_white,name:whitePlayer?"W_Rook":"B_Rook",image:whitePlayer?"Images/wR.png":"Images/bR.png"),
    ];

    if(whitePlayer){
      whitePlayerIndex=[48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63];
      blackPlayerIndex=[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15];
    }
    else{
      whitePlayerIndex=[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15];
      blackPlayerIndex=[48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63];
      whitePlayer=true;
    }
  }

  List<Move> getPossibleMoves(List<int>allIndex){
    int sameKingIndex=getKingIndex(whitePlayer);
    bool kingState=checkMate(sameKingIndex,true);
    List<Move>allMoves=[];
    for(int i=0;i<allIndex.length;i++){
      String pieceName=boardCells.elementAt(allIndex.elementAt(i)).name;
      if(pieceName.contains("Pawn")){
        List<int>copy=pawnLaw(pieceName,allIndex.elementAt(i) , true, kingState);
        if(copy.isNotEmpty){
          for(var target in copy){
            allMoves.add(Move(allIndex[i],target,boardCells[allIndex[i]].name,copyBoard(),List.of(whitePlayerIndex),List.of(blackPlayerIndex)));
          }
        }
      }
      else if(pieceName.contains("Knight")){
        List<int>copy=knightLaw(pieceName,allIndex.elementAt(i) , true, kingState);
        if(copy.isNotEmpty){
          for(var target in copy){
            allMoves.add(Move(allIndex[i],target,boardCells[allIndex[i]].name,copyBoard(),List.of(whitePlayerIndex),List.of(blackPlayerIndex)));
          }
        }
      }
      else if(pieceName.contains("Rook") ){
        List<int>copy=rookLaw(pieceName,allIndex.elementAt(i) , true, kingState);
        if(copy.isNotEmpty){
          for(var target in copy){
            allMoves.add(Move(allIndex[i],target,boardCells[allIndex[i]].name,copyBoard(),List.of(whitePlayerIndex),List.of(blackPlayerIndex)));
          }
        }
      }
      else if( pieceName.contains("Queen")){
        List<int>copy=bishopLaw(pieceName,allIndex.elementAt(i) , true, kingState);
        copy.addAll(rookLaw(pieceName,allIndex.elementAt(i) , true, kingState));
        if(copy.isNotEmpty){
          for(var target in copy){
            allMoves.add(Move(allIndex[i],target,boardCells[allIndex[i]].name,copyBoard(),List.of(whitePlayerIndex),List.of(blackPlayerIndex)));
          }
        }
      }
      else if(pieceName.contains("bishop")){
        List<int>copy=bishopLaw(pieceName,allIndex.elementAt(i) , true, kingState);
        if(copy.isNotEmpty){
          for(var target in copy){
            allMoves.add(Move(allIndex[i],target,boardCells[allIndex[i]].name,copyBoard(),List.of(whitePlayerIndex),List.of(blackPlayerIndex)));
          }
        }
      }
      else if(pieceName.contains("King")){
        List<int>copy=kingLaw(pieceName,allIndex.elementAt(i) , true, kingState);
        if(copy.isNotEmpty){
          for(var target in copy){
            allMoves.add(Move(allIndex[i],target,boardCells[allIndex[i]].name,copyBoard(),List.of(whitePlayerIndex),List.of(blackPlayerIndex)));
          }
        }
      }
    }
    // for(Move possibleMove in allMoves){
    //   print("Piece = ${possibleMove.pieceName}  start = ${possibleMove.pieceIndex}  target = ${possibleMove.targetIndex}");
    // }
    // print("\n");

    return allMoves;
  }

  void clearPiece(int index){
    boardCells.elementAt(index).name="";
    boardCells.elementAt(index).image="";
  }

  List<int> pawnLaw(String colorPiece,int index,bool hideMoves,bool kingState) {
     List<int>allMoves=[];
    int count=0;
    count=colorPiece=="B_Pawn"?index+8:index-8;
    int moveUpRow=colorPiece=="B_Pawn"?7:0;
    if(boardCells.elementAt(count).image==""){//move one to top
      if(getRow(count)==moveUpRow){//move up to queen
        if((!kingState || (kingState && checkMatePath.contains(count)))) {
          if(!hideMoves)boardCells.elementAt(count).color=Colors.redAccent;
          allMoves.add(count);
        }
      }
      if((!kingState || (kingState && checkMatePath.contains(count)))) {
        if(!hideMoves)boardCells.elementAt(count).image = "Images/circle5.png";
        allMoves.add(count);
      }

      count=colorPiece=="B_Pawn"?count+8:count-8;
      int pawnRow=colorPiece=="B_Pawn"?1:6;
      if(getRow(index)==pawnRow && boardCells.elementAt(count).image=="")
      {//move two to top
        if((!kingState || (kingState && checkMatePath.contains(count)))){
          if(!hideMoves)boardCells.elementAt(count).image = "Images/circle5.png";
          allMoves.add(count);
        }
      }
    }
    count=colorPiece=="B_Pawn"?index+9:index-7;
    if((index+1)%8!=0 && (
        (colorPiece.contains("W") && boardCells.elementAt(count).name.contains("B"))
            || (colorPiece.contains("B") && boardCells.elementAt(count).name.contains("W"))
            ||( getRow(move.targetIndex)==getRow(index)
            && move.pieceName=="Pawn"
            && (move.targetIndex==index+1)
            && (max(move.targetIndex, move.pieceIndex)-min(move.targetIndex, move.pieceIndex)==16))
    ))
    {//move one to top right
      if( (!kingState || (kingState && checkMatePath.contains(count)))) {
        if(!hideMoves)boardCells.elementAt(count).color = Colors.redAccent;
        allMoves.add(count);
      }
    }
    count=colorPiece=="B_Pawn"?index+7:index-9;
    if(index%8!=0 && (
        (colorPiece.contains("W") && boardCells.elementAt(count).name.contains("B"))
            || (colorPiece.contains("B") && boardCells.elementAt(count).name.contains("W"))
            || ( getRow(move.targetIndex)==getRow(index)
            && move.pieceName=="Pawn"
            && (move.targetIndex==index-1 )
            && (max(move.targetIndex, move.pieceIndex)-min(move.targetIndex, move.pieceIndex)==16))))
    {//move one to top left
      if( (!kingState || (kingState && checkMatePath.contains(count)))) {
        if(!hideMoves)boardCells.elementAt(count).color = Colors.redAccent;
        allMoves.add(count);
      }
    }
    return allMoves;
  }
  List<int> rookLaw(String colorPiece,int index,bool hideMoves,bool kingState) {
    List<int>allMoves=[];
    List<int>bishopState=[-8,8,1,-1];
    int count=0,prevCount=index;

    for(int i=0;i<4;i++){
      count=index+bishopState.elementAt(i);
      while(count>-1 &&count<64){
        if(bishopState.elementAt(i)==-8 && getRow(prevCount)!=(getRow(count)+1)) { break; }
        else if(bishopState.elementAt(i)==8 && getRow(prevCount)!=(getRow(count)-1)) { break; }
        else if(bishopState.elementAt(i).abs()==1 && getRow(prevCount)!=(getRow(count))) { break; }

        if(boardCells.elementAt(count).image!="" &&((colorPiece.contains("B") && boardCells.elementAt(count).name.contains("W"))|| (colorPiece.contains("W") && boardCells.elementAt(count).name.contains("B")))){
          if(!kingState || (kingState && checkMatePath.contains(count))) {
            if(!hideMoves)boardCells.elementAt(count).color = Colors.redAccent;
            allMoves.add(count);
          }
          break;
        }
        else if(boardCells.elementAt(count).image=="" ){
          if( (!kingState || (kingState && checkMatePath.contains(count)))) {
            if(!hideMoves)boardCells.elementAt(count).image = "Images/circle5.png";
            allMoves.add(count);
          }
        }
        else {
          break;
        }
        prevCount=count;
        count+=bishopState.elementAt(i);
      }
      prevCount=index;
    }
    return allMoves;
  }
  List<int> bishopLaw(String colorPiece,int index,bool hideMoves,bool kingState) {
    List<int>allMoves=[];
    List<int>bishopState=[-7,7,9,-9];
    int count=0,prevCount=index;
    for(int i=0;i<4;i++){
      count=index+bishopState.elementAt(i);
      while(count>-1 &&count<64){
        if(bishopState.elementAt(i)>0 && getRow(prevCount)!=(getRow(count)-1)) { break; }
        else if(bishopState.elementAt(i)<0 && getRow(prevCount)!=(getRow(count)+1)) { break; }
        if(boardCells.elementAt(count).image!="" &&((colorPiece.contains("B") && boardCells.elementAt(count).name.contains("W"))|| (colorPiece.contains("W") && boardCells.elementAt(count).name.contains("B")))){
          if(!kingState || (kingState && checkMatePath.contains(count))) {
            if(!hideMoves)boardCells.elementAt(count).color = Colors.redAccent;
            allMoves.add(count);
          }
          break;
        }
        else if(boardCells.elementAt(count).image=="" ){
          if( (!kingState || (kingState && checkMatePath.contains(count)))) {
            if(!hideMoves)boardCells.elementAt(count).image = "Images/circle5.png";
            allMoves.add(count);
          }
        }
        else {
          break;
        }
        prevCount=count;
        count+=bishopState.elementAt(i);
      }
      prevCount=index;
    }
    return allMoves;
  }
  List<int> knightLaw(String colorPiece,int index,bool hideMoves,bool kingState) {
    List<int>allMoves=[];
    int count=0;
    int it=0;
    int knightRow=getRow(index);
    while(true){//move to bottom
      if(it==0 || it==2){
        if(it==0) {count=index+6;}   else {count=index+10;}
        it++;
        if(count<0 || count >63 || count<(knightRow+1)*8 || count>((knightRow+2)*8)-1) {
          continue;
        }
      }
      else if(it==1 || it==3){
        if(it==1) { count=index-6;}  else {count=index-10;}
        it++;
        if(count<0 || count >63 || count<(knightRow-1)*8 || count>((knightRow)*8)-1 ) {
          continue;
        }
      }
      else if(it==4 || it ==6){
        if(it==4) {count=index-15; } else { count=index-17; }
        it++;
        if(count<0 || count >63 || count<(knightRow-2)*8 || count>((knightRow-1)*8)-1 ) {
          continue;
        }
      }
      else if(it==5 || it==7){
        if(it==5) { count=index+15; } else { count=index+17; }
        it++;
        if(count<0|| count >63 || count<(knightRow+2)*8 || count>((knightRow+3)*8)-1) {
          continue;
        }
      }
      else {
        it=0;
        break;
      }
      if(boardCells.elementAt(count).image!="" &&((colorPiece.contains("B") && boardCells.elementAt(count).name.contains("W"))|| (colorPiece.contains("W") && boardCells.elementAt(count).name.contains("B")))){
        if(!kingState || (kingState && checkMatePath.contains(count))) {
          if(!hideMoves)boardCells.elementAt(count).color = Colors.redAccent;
          allMoves.add(count);
        }
      }
      else if(boardCells.elementAt(count).image=="") {
        if(!kingState || (kingState && checkMatePath.contains(count))) {
          if(!hideMoves)boardCells.elementAt(count).image = "Images/circle5.png";
          allMoves.add(count);
        }
      }
    }
    return allMoves;
  }
  List<int> kingLaw(String colorPiece,int index,bool hideMoves,bool kingState) {
    String color=colorPiece.contains("B")?"B":"W";
    String kingImage=boardCells.elementAt(index).image;
    clearPiece(index);
    List<int>allMoves=[];
    int count = 0;
    int kingRow=getRow(index);

    count=index+8;
    if(count>-1 && count<64 && count>=(kingRow+1)*8 && count<=((kingRow+2)*8)-1  && !checkMate(count, false,color:color)) {
      if(boardCells.elementAt(count).image=="") {
        if (!hideMoves) boardCells.elementAt(count).image = "Images/circle5.png";
        allMoves.add(count);
      }
      else if( (boardCells.elementAt(count).image!="" &&((colorPiece.contains("B") && boardCells.elementAt(count).name.contains("W"))|| (colorPiece.contains("W") && boardCells.elementAt(count).name.contains("B"))))){
        if(!hideMoves) boardCells.elementAt(count).color=Colors.redAccent;
        allMoves.add(count);
      }
    }
    count=index-8;
    if(count>-1 && count<64 && count>=(kingRow-1)*8 && count<=((kingRow)*8)-1 &&!checkMate(count, false,color:color)) {
      if(boardCells.elementAt(count).image=="") {
        if (!hideMoves) boardCells.elementAt(count).image = "Images/circle5.png";
        allMoves.add(count);
      }
      else if( (boardCells.elementAt(count).image!="" &&((colorPiece.contains("B") && boardCells.elementAt(count).name.contains("W"))|| (colorPiece.contains("W") && boardCells.elementAt(count).name.contains("B"))))){
        if(!hideMoves) boardCells.elementAt(count).color=Colors.redAccent;
        allMoves.add(count);
      }
    }

    count=index+1;
    if(count>-1 && count<64 && count>=(kingRow)*8 && count<=((kingRow+1)*8)-1 &&!checkMate(count, false,color:color)) {
      if(boardCells.elementAt(count).image=="") {
        if(!hideMoves)boardCells.elementAt(count).image = "Images/circle5.png";
        allMoves.add(count);
      }
      else if( (boardCells.elementAt(count).image!="" &&((colorPiece.contains("B") && boardCells.elementAt(count).name.contains("W"))|| (colorPiece.contains("W") && boardCells.elementAt(count).name.contains("B"))))){
        if(!hideMoves) boardCells.elementAt(count).color=Colors.redAccent;
        allMoves.add(count);
      }
    }

    count=index-1;
    if(count>-1 && count<64 && count>=(kingRow)*8 && count<=((kingRow+1)*8)-1 &&!checkMate(count, false,color:color)) {
      if(boardCells.elementAt(count).image=="") {
        if(!hideMoves)boardCells.elementAt(count).image = "Images/circle5.png";
        allMoves.add(count);
      }
      else if( (boardCells.elementAt(count).image!="" &&((colorPiece.contains("B") && boardCells.elementAt(count).name.contains("W"))|| (colorPiece.contains("W") && boardCells.elementAt(count).name.contains("B"))))){
        if(!hideMoves) boardCells.elementAt(count).color=Colors.redAccent;
        allMoves.add(count);
      }
    }
    // count=index-8;// do nt
    // if(count>-1 && count<64 && count>=(kingRow-1)*8 && count<=((kingRow-2)*8)-1 && boardCells.elementAt(count).Image==""&&!checkMate(count, false,color:color)) {
    //   if(!hideMoves && boardCells.elementAt(count).Image=="")boardCells.elementAt(count).Image="Images/circle5.png";
    //   allMoves.add(count);
    // }

    count=colorPiece=="B_King"?index+7:index-7; //move to bottom left
    int num1=colorPiece=="B_King"?1:-1;
    int num2=colorPiece=="B_King"?2:0;
    if(count>-1 && count<64 && count>=(kingRow+num1)*8 && count<=((kingRow+num2)*8)-1&&!checkMate(count, false,color:color)) {
      if( (boardCells.elementAt(count).image!="" &&((colorPiece.contains("B") && boardCells.elementAt(count).name.contains("W"))|| (colorPiece.contains("W") && boardCells.elementAt(count).name.contains("B"))))) {
        if(!hideMoves)boardCells.elementAt(count).color=Colors.redAccent;
        allMoves.add(count);
      } else if( boardCells.elementAt(count).image=="") {
        if(!hideMoves)boardCells.elementAt(count).image="Images/circle5.png";
        allMoves.add(count);
      }
    }

    count=colorPiece=="B_King"?index-7:index+7; //move to bottom left
    num1=colorPiece=="B_King"?-1:1;
    num2=colorPiece=="B_King"?0:2;
    if(count>-1 && count<64 && count>=(kingRow+num1)*8 && count<=((kingRow+num2)*8)-1&&!checkMate(count, false,color:color)) {
      if(boardCells.elementAt(count).image=="") {
        if(!hideMoves)boardCells.elementAt(count).image = "Images/circle5.png";
        allMoves.add(count);
      }
    }

    count=colorPiece=="B_King"?index+9:index-9; //move to top left
    num1=colorPiece=="B_King"?1:-1;
    num2=colorPiece=="B_King"?2:0;
    if(count>-1 && count<64 && count>=(kingRow+num1)*8 && count<=((kingRow+num2)*8)-1&&!checkMate(count, false,color:color)) {
      if( (boardCells.elementAt(count).image!="" &&((colorPiece.contains("B") && boardCells.elementAt(count).name.contains("W"))|| (colorPiece.contains("W") && boardCells.elementAt(count).name.contains("B"))))) {
        if(!hideMoves) {
          boardCells.elementAt(count).color = Colors.redAccent;
        }
        allMoves.add(count);
      } else if( boardCells.elementAt(count).image=="") {
        if(!hideMoves)boardCells.elementAt(count).image="Images/circle5.png";
        allMoves.add(count);
      }
    }

    count=colorPiece=="B_King"?index-9:index+9;//move to top right
    num1=colorPiece=="B_King"?-1:1;
    num2=colorPiece=="B_King"?0:2;
    if(count>-1 && count<64 && count>=(kingRow+num1)*8 && count<=((kingRow+num2)*8)-1&&!checkMate(count, false,color:color)) {
      if(boardCells.elementAt(count).image=="") {
        if(!hideMoves)boardCells.elementAt(count).image = "Images/circle5.png";
        allMoves.add(count);
      }
    }

    if(kingState) {
      boardCells.elementAt(index).image=kingImage;
      boardCells.elementAt(index).name=colorPiece;
      return allMoves;
    }

    count=index+2; //تبيت الملك ناحيه اليمين
    num1=colorPiece=="B_King"?4:60;//King index
    num2=colorPiece=="B_King"?7:63;//Rook index

    bool exit=false;
    for(int i=num1+1;i<num2;i++){
      if((boardCells.elementAt(i).image!="" &&boardCells.elementAt(i).image!="Images/circle5.png") || checkMate(i, false,color: color)){
        exit=true;
        break;
      }
    }
    if(!boardCells.elementAt(num1).isMove && !boardCells.elementAt(num2).isMove && !exit&&!checkMate(count, false,color:color)) {
      if(boardCells.elementAt(count).image=="") {
        if(!hideMoves)boardCells.elementAt(count).image = "Images/circle5.png";
        allMoves.add(count);
      }
    }
    exit =false;
    count=index-2; //تبيت الملك ناحيه اليسار
    num2=colorPiece=="B_King"?0:56;//Rook index
    for(int i=num1-1;i>num2;i--){
      if((boardCells.elementAt(i).image!=""&&boardCells.elementAt(i).image!="Images/circle5.png")|| checkMate(i, false,color: color)){
        exit=true;
        break;
      }
    }
    if(!boardCells.elementAt(num1).isMove && !boardCells.elementAt(num2).isMove && !exit&&!checkMate(count, false,color:color)) {
      if(boardCells.elementAt(count).image=="") {
        if(!hideMoves)boardCells.elementAt(count).image = "Images/circle5.png";
        allMoves.add(count);
      }
    }

    boardCells.elementAt(index).image=kingImage;
    boardCells.elementAt(index).name=colorPiece;
    return allMoves;
  }


  int getKingIndex(bool colorKing){
    for(int i=0;i<64;i++){
      if(boardCells.elementAt(i).name.contains("King") && boardCells.elementAt(i).name.contains(colorKing?"W":"B")) {
        return i;
      }
    }
    return 0;
  }

  //kingColor=W,B
  bool checkMate(int kingIndex,bool kingCheck,{String color=""})
  {
    String kingColor=boardCells.elementAt(kingIndex).name.contains("B")?"B":boardCells.elementAt(kingIndex).name.contains("W")?"W":color;
    if(kingCheck==false) kingColor=color;
    int count=0;
    List<int>allMoves=[];
    int numberCheckMate=0;

    //check another king

    List<int>allKingState=[1,-1,8,-8,7,-7,9,-9];

    for(int i=0;i<allKingState.length;i++){
      count=kingIndex+allKingState.elementAt(i);
      if(count>0 && count<64 &&!boardCells.elementAt(count).name.contains(kingColor) && boardCells.elementAt(count).name.contains("King"))
      {
        if(i<2 && getRow(count)==getRow(kingIndex)){
          return true;
        }
        else if((i==4 || i==6) && getRow(count)==(getRow(kingIndex)+1)){
          return true;
        }
        else if((i==5 || i==7) && getRow(count)==(getRow(kingIndex)-1)){
          return true;
        }
        else {
          return true;
        }
      }
    }



    //check all moves for Pawn

    for(int i=0;i<4;i+=2){
      count=kingColor=="W"?kingIndex-(7+i):kingIndex+(7+i);
      if(count>0 && count<64 && (kingIndex+1)%8!=0 && kingIndex%8!=0&&!boardCells.elementAt(count).name.contains(kingColor) && boardCells.elementAt(count).name.contains("Pawn"))
      {
        if(kingCheck)checkMatePath.add(count);
        numberCheckMate++;
      }
    }
    //check all moves for knight
    allMoves.addAll(knightLaw(kingColor,kingIndex, true,false));
    for(int i in allMoves) {
      if(!boardCells.elementAt(i).name.contains(kingColor) && boardCells.elementAt(i).name.contains("Knight"))
      {
        if(kingCheck)checkMatePath.add(i);
        numberCheckMate++;
      }
    }
    allMoves.clear();
    // //check all moves for bishop
    allMoves.addAll(bishopLaw(kingColor,kingIndex, true,false));
    for(int i in allMoves) {
      if(!boardCells.elementAt(i).name.contains(kingColor) && (boardCells.elementAt(i).name.contains("bishop") || boardCells.elementAt(i).name.contains("Queen")))
      {
        numberCheckMate++;
        int space=kingIndex-i; //positive or negative
        if(space>0 && space.abs()%7==0) {count=-7;}
        else if(space>0 && space.abs()%9==0){count=-9;}
        else if(space<0 && space.abs()%7==0){count=7;}
        else if(space<0 && space.abs()%9==0){count=9;}

        if(kingCheck){
          checkMatePath.add(i);
          for(int g=kingIndex+count;g!=i; g+=count){
            checkMatePath.add(g);
          }
        }
      }
    }
    allMoves.clear();

    // //check all moves for Rook ,Queen
    allMoves.addAll(rookLaw(kingColor,kingIndex, true,false));
    for(int i in allMoves) {
      if(!boardCells.elementAt(i).name.contains(kingColor) && (boardCells.elementAt(i).name.contains("Rook") || boardCells.elementAt(i).name.contains("Queen")))
      {
        numberCheckMate++;
        int space=kingIndex-i; //positive or negative
        if(space>0 && space.abs()<8) {count=-1;}
        else if(space<0 && space.abs()<8){count=1;}
        else if(space>0){count=-8;}
        else if(space<0){count=8;}
        if(kingCheck){
          checkMatePath.add(i);
          for(int g=kingIndex+=count;g!=i; g+=count){
            checkMatePath.add(g);
          }
        }
      }
    }
    allMoves.clear();
    if(numberCheckMate==1) { return true; }
    else if(numberCheckMate>1){
      checkMatePath.clear();
      return true;
    }
    else { return false; }
  }

  int getRow(int index){
    if(index<8 && index>-1) {return 0;}
    else if(index<16 && index>7) {return 1;}
    else if(index<24 && index>15) {return 2;}
    else if(index<32 && index>23) {return 3;}
    else if(index<40 && index>31) {return 4;}
    else if(index<48 && index>39) {return 5;}
    else if(index<56 && index>47) {return 6;}
    else if(index<64 && index>55) {return 7;}
    else {return -1;}
  }
  void resetAllPieces(){
    for(int index in busyPieces){
      if(boardCells.elementAt(index).color!=Colors.redAccent && boardCells.elementAt(index).image=="Images/circle5.png"){
        boardCells.elementAt(index).image="";
      }
      else {
        int row=getRow(index);
        if(row%2==0 && index %2==0) {boardCells.elementAt(index).color=_white;}
        else if(row%2==0 && index %2!=0) {boardCells.elementAt(index).color=_green!;}
        else if(row%2!=0 && index %2==0) {boardCells.elementAt(index).color=_green!;}
        else if(row%2!=0 && index %2!=0) {boardCells.elementAt(index).color=_white;}
      }
    }
    busyPieces.clear();
  }

  void returnFromCheckMate(int kingIndex){
    int row=getRow(kingIndex);
    if(row%2==0 && kingIndex %2==0) {boardCells.elementAt(kingIndex).color=_white;}
    else if(row%2==0 && kingIndex %2!=0) {boardCells.elementAt(kingIndex).color=_green!;}
    else if(row%2!=0 && kingIndex %2==0) {boardCells.elementAt(kingIndex).color=_green!;}
    else if(row%2!=0 && kingIndex %2!=0) {boardCells.elementAt(kingIndex).color=_white;}
  }

  void makeMove(Move move1){
    move=move1;
    int start=move.pieceIndex;
    int end=move.targetIndex;

    //print("start = $start  end = $end");
    String colorPiece=boardCells.elementAt(start).name;
    bool eatToward=boardCells.elementAt(end).color==Colors.redAccent &&boardCells.elementAt(end).image==""?true:false;

    boardCells.elementAt(move.pieceIndex).isMove=true;
    boardCells.elementAt(move.targetIndex).isMove=true;

    //و حركت عسكري خطوتين مره واحده وفيه جمبه عسكري
    if((colorPiece=="W_Pawn" &&getRow(end)==0) || (colorPiece=="B_Pawn" &&getRow(end)==7))
    { //Pawn move up to Queen
      String img=colorPiece.contains("B")?"Images/bQ.png":"Images/wQ.png";
      String nam=colorPiece.contains("B")?"B_Queen":"W_Queen";
      boardCells.elementAt(end).image=img;
      boardCells.elementAt(end).name=nam;
      clearPiece(start);
    }
    else if((colorPiece=="W_King" || colorPiece=="B_King") && max(start, end)-min(start, end)==2)
    {//تبيت الملك
      String choose=colorPiece.contains("B")?"B_Rook":"W_Rook";
      String img=colorPiece.contains("B")?"Images/bR.png":"Images/wR.png";

      boardCells.elementAt(end).image=boardCells.elementAt(start).image;
      boardCells.elementAt(end).name=boardCells.elementAt(start).name;
      clearPiece(start);

      int sign=start>end?1:-1;
      if(boardCells.elementAt(end+1).name==choose ){
        clearPiece(end+1);
        boardCells.elementAt(end+1).isMove=true;
      }
      else if( boardCells.elementAt(end-2).name==choose){
        clearPiece(end-2);
        boardCells.elementAt(end-2).isMove=true;
      }
      boardCells.elementAt(end+sign).image=img;
      boardCells.elementAt(end+sign).name=choose;
      boardCells.elementAt(end+sign).isMove=true;
    }
    else{
      boardCells.elementAt(end).image=boardCells.elementAt(start).image;
      boardCells.elementAt(end).name=boardCells.elementAt(start).name;
      clearPiece(start);
      if(eatToward)clearPiece(colorPiece.contains("B")?end-8:end+8);
    }

    _updateWhiteBlackIndex();

  }
  void _updateWhiteBlackIndex(){
    if(whitePlayer) {
      whitePlayerIndex[whitePlayerIndex.indexOf(move.pieceIndex)]=move.targetIndex;
      if(blackPlayerIndex.contains(move.targetIndex)) blackPlayerIndex.remove(move.targetIndex);
    }
    else  {
      blackPlayerIndex[blackPlayerIndex.indexOf(move.pieceIndex)]=move.targetIndex;
      if(whitePlayerIndex.contains(move.targetIndex)) whitePlayerIndex.remove(move.targetIndex);
    }
  }

  void undoMove(Move move1){
    boardCells=move1.board;
    whitePlayerIndex=List.of(move1.whitePlayerIndex);
    blackPlayerIndex=List.of(move1.blackPlayerIndex);
  }

  List<Piece>copyBoard(){
    List<Piece>newList=[];
    for(int i=0;i<64;i++){
      newList.add(Piece(boardCells.elementAt(i).color,name:boardCells.elementAt(i).name,image:boardCells.elementAt(i).image));
    }
    return newList;
  }
  List<int> piecesCount(String pieceColor){
    List<int> count=[0,0,0,0,0];//0-->pawn ,1-->bishop , 2-->knight , 3-->rook , 4-->queen
    int size=pieceColor.contains("W")?whitePlayerIndex.length:blackPlayerIndex.length;
    for(int i=0;i<size;i++){
      int index=pieceColor.contains("W")?whitePlayerIndex[i]:blackPlayerIndex[i];
      if(boardCells[index].name.contains("Pawn"))      {count[0]++;}
      else if(boardCells[index].name.contains("Knight")){count[1]++;}
      else if(boardCells[index].name.contains("bishop")){count[2]++;}
      else if(boardCells[index].name.contains("Rook"))  {count[3]++;}
      else if(boardCells[index].name.contains("Queen")) {count[4]++;}
    }
    return count;
  }

}