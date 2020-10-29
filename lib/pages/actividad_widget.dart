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
        color: actividad.asignada ? Colors.amber : Colors.cyan,
        borderRadius: BorderRadius.circular(5),
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
                Text('${actividad.titulo}', overflow: TextOverflow.clip),
                Text('${actividad.subtitulo}', overflow: TextOverflow.clip),
                Expanded(child: Container(width: 0, height: 0)),
                Text('${actividad.pie}', overflow: TextOverflow.clip),
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
