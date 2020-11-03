import 'package:calendar21/widgets/color_picker.dart';

import '../models/actividad_model.dart';
import 'package:flutter/material.dart';

class ActividadWidget extends StatelessWidget {
  const ActividadWidget({Key key, this.actividad}) : super(key: key);

  final Actividad actividad;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      //height: 200,
      decoration: BoxDecoration(
        color:
            actividad.asignada ? Color(actividad.color) : Colors.blueGrey[50],
        borderRadius: BorderRadius.circular(5),
        // border: Border.all(
        //   color: Colors.grey[300],
        //   width: 1,
        // ),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey[300].withOpacity(0.4),
        //     spreadRadius: 1,
        //     blurRadius: 1,
        //     offset: Offset(2, 2), // changes position of shadow
        //   ),
        // ],
      ),
      padding: EdgeInsets.fromLTRB(5, 7, 5, 7),
      margin: EdgeInsets.only(bottom: 2),
      //child: ClipRect(
      //El error no se sale de la columna
      clipBehavior: Clip.hardEdge,
      child: actividad.asignada
          ? Column(
              // TODO: Mejorar la presentación ListView/Column?¿?¿?
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              //mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '${actividad.titulo}',
                  overflow: TextOverflow.clip,
                  style: new TextStyle(
                      fontSize: 13.0,
                      //fontFamily: 'Roboto',
                      color: highlightColor(Color(actividad.color)),
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  '${actividad.subtitulo}',
                  overflow: TextOverflow.clip,
                  style: new TextStyle(
                      color: highlightColor(Color(actividad.color))),
                ),
                //Expanded(child: Container(width: 0, height: 0)),
                Spacer(),
                Text(
                  '${actividad.pie}',
                  overflow: TextOverflow.clip,
                  style: new TextStyle(
                      color: highlightColor(Color(actividad.color))),
                ),
              ],
            )
          : Container(
              width: double.infinity,
              height: double.infinity,
            ),
      //),
    );
  }
}
