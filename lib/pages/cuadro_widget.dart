import 'package:flutter/material.dart';

class CuadroWidget extends StatelessWidget {
  const CuadroWidget({Key key, this.size}) : super(key: key);

  final int size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      //height: 200,
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(5),
      ),
      padding: EdgeInsets.fromLTRB(5, 7, 5, 7),
      //child: ClipRect(
      //El error no se sale de la columna
      clipBehavior: Clip.hardEdge,
      child: Column(
        //crossAxisAlignment: CrossAxisAlignment.stretch,
        //mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('$size', overflow: TextOverflow.clip),
          Text('DOS', overflow: TextOverflow.clip),
          Expanded(child: Container(width: 0, height: 0)),
          Text('TRES', overflow: TextOverflow.clip),
        ],
      ),
      //),
    );
  }
}
