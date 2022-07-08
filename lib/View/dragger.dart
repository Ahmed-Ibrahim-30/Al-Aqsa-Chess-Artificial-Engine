import 'package:flutter/cupertino.dart';
bool _isDropped=false;
// Widget _buildTile(String image,String newimage) {
//   return DragTarget<String>(
//     builder: (context, candidateData, rejectedData) {
//       return Draggable<String>(
//         feedback: SizedBox(
//           //الصوره وانتا ماسكها
//           height: 120.0,
//           width: 120.0,
//           child: Center(
//             child: Image.asset(image),
//           ),
//         ),
//         childWhenDragging: Container(),
//         data: 'red',
//         child: SizedBox(
//           height: 120.0,
//           width: 120.0,
//           child: Center(
//             child: Image.asset(_isDropped?newimage:image),
//           ),
//         ),
//       );
//     },
//     onWillAccept: (data) {
//       print("ahmed");
//       return data == 'red';
//     },
//     onAccept: (data) {
//       setState(() {
//         _isDropped = !_isDropped;
//         print("ahmed");
//       });
//     },
//
//   );
// }