
import 'dart:math';
import 'package:chess_ai/Model/Board.dart';
import 'Move.dart';
int materialCount(Board1 board,String pieceColor){
  int material=0;
   List<int>count=board.piecesCount(pieceColor);
  material+=count[0]*100;
  material+=count[1]*300;
  material+=count[2]*300;
  material+=count[3]*500;
  material+=count[4]*900;
  return material;
}
int evaluate(Board1 board){
  int evaluate=0,perspective;
  int white=materialCount(board, "W");
  int black=materialCount(board, "B");
  evaluate=white-black;
  perspective=board.whitePlayer?1:-1;
  









  print("Evaluation = ${evaluate*perspective}");
  return evaluate*perspective;
}

Move alphaBetaSearch(Board1 board,int depth,int alpha,int beta,Move move){
  if(depth==0){
    move.evaluation=evaluate(board);
    return move;
  }

  List<Move>moves=board.getPossibleMoves(board.whitePlayer?board.whitePlayerIndex:board.blackPlayerIndex);
  //print("Moves Length = ${moves.length}");
  if(moves.isEmpty){
    move.evaluation=0;
    return move;
  }
  for (var element in moves) {
     board.makeMove(element);
     int evaluation=alphaBetaSearch(board,depth-1,alpha,beta,element).evaluation;
     element.evaluation=evaluation;
     board.undoMove(element);

    if(evaluation>=beta) {
      element.evaluation=beta;
      return element;
    }
    alpha=max(alpha, evaluation);
  }

  if(depth==3){
    for (var element in moves) {
      if(element.evaluation==alpha){
        print("Enter");
        // bestMove=element;
         print("name = ${element.pieceName}  start = ${element.pieceIndex}  end = ${element.targetIndex}");
        // return moves.indexOf(element);

        return element;
      }
    }
    print(alpha);
  }

  return Move(-1, -1, "", [],[],[]);;
}

void printMove(Move state){
  print("Piece = ${state.pieceName} "
      " start = ${state.pieceIndex}  target = ${state.targetIndex} "
      "alpha = ${state.alpha} beta = ${state.beta}");
}
int i=0;
Move alphaBeta2(bool player,Board1 board, Move state,int depth, bool isMax) {

  if (depth == 0) {
    if(isMax){state.alpha=evaluate(board);}
    else {state.beta=evaluate(board);}
    //printMove(state);
    return state;
  }

  print("white = ${board.whitePlayerIndex}");
  print("black = ${board.blackPlayerIndex}");
  List<Move>moves=board.getPossibleMoves(player?board.whitePlayerIndex:board.blackPlayerIndex);
  if (moves.isEmpty) {
    return Move(-1, -1, "", [], [], []);
  }
  print("Lenght = ${moves.length}  depth = $depth piece = ${board.boardCells[16].name}");

  for(Move possibleMove in moves){
    printMove(possibleMove);
  }
  print("\n");

   for (var element in moves) {
     i++;
     element.alpha = state.alpha;
     element.beta = state.beta;
     board.whitePlayer=player;
     board.makeMove(element);
     alphaBeta2(!player,board,element, depth - 1, !isMax);
     board.undoMove(element);
    if (isMax) {
      if (element.beta > state.alpha) {
        state.alpha = element.beta;
      }
    } else {
      if (element.alpha < state.beta) {
        state.beta = element.alpha;
      }
    }
    if (state.beta <= state.alpha) {
      print("ahmed fahmy = $depth");
      break;
    }
   }
  if (depth == 3) {
    Move best = bestState(moves, state.alpha);
    return best;
  }
  return moves[0];
}

Move bestState(List<Move>moves, int alpha){
  for(var element in moves){
    if(element.beta==alpha)return element;
  }
  return Move(-1, -1, "", [],[],[]);
}
