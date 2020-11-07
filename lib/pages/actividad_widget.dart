import 'package:calendar21t/model/constantes_model.dart';
import 'package:calendar21t/model/actividad_model.dart';
import 'package:calendar21t/widgets/color_picker.dart';

import 'package:flutter/material.dart';

Color lighten(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

  return hslLight.toColor();
}

Color darken(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

  return hslDark.toColor();
}

class ActividadWidget extends StatelessWidget {
  const ActividadWidget({Key key, this.actividad, this.tipoDia})
      : super(key: key);

  final Actividad actividad;
  final int tipoDia;

  @override
  Widget build(BuildContext context) {
    var ctes = MisConstantes.of(context);

    var fondo =
        actividad.asignada ? Color(actividad.color) : ctes.fondoNoActividad;
    var texto = highlightColor(Color(actividad.color));

    if (actividad.asignada) {
      switch (tipoDia) {
        case 1:
          fondo = lighten(fondo, .3);
          texto = lighten(fondo, .1);

          break;
        case 2:
          fondo = darken(ctes.fondoNoActividad, .1);
          texto = lighten(fondo, .1);
          break;
        default:
      }
      // fondo = tipo == 1 ? lighten(fondo, .3) : fondo;
      // fondo = tipo == 2 ? darken(ctes.fondoNoActividad, .1) : fondo;
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: fondo,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: ctes.bordeNoActividad, //.grey[300],
          width: actividad.asignada ? 0 : 1,
        ),
        // boxShadow: [
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
                      fontSize: 15.0,
                      //fontFamily: 'Roboto',
                      color: texto,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  '${actividad.subtitulo}',
                  overflow: TextOverflow.clip,
                  style: new TextStyle(color: texto),
                ),
                //Expanded(child: Container(width: 0, height: 0)),
                Spacer(),
                Text(
                  '${actividad.pie}',
                  overflow: TextOverflow.clip,
                  style: new TextStyle(color: texto),
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
