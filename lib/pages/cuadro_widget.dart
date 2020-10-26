import 'package:calendar21/providers/data.dart';
import 'package:flutter/material.dart';

class CuadroWidget extends StatelessWidget {
  const CuadroWidget({Key key, this.cuadro}) : super(key: key);

  final Cuadro cuadro;

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
      margin: EdgeInsets.only(bottom: 2),
      //child: ClipRect(
      //El error no se sale de la columna
      clipBehavior: Clip.hardEdge,
      child: Column(
        // TODO: Mejorar la presentación ListView?¿?¿?
        //crossAxisAlignment: CrossAxisAlignment.stretch,
        //mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('${cuadro.minutos}', overflow: TextOverflow.clip),
          Text('subtitu', overflow: TextOverflow.clip),
          Expanded(child: Container(width: 0, height: 0)),
          Text('pie', overflow: TextOverflow.clip),
        ],
      ),
      //),
    );
  }
}
