import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import '../models/actividad_model.dart';
import '../pages/actividad_widget.dart';
import '../pages/semanario_widget.dart';
import '../models/detalle_model.dart';
import '../models/constantes_model.dart';

import '../providers/data.dart';
import 'detalle_page.dart';

class HorarioPage extends StatefulWidget {
  HorarioPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HorarioPageState createState() => _HorarioPageState();
}

class _HorarioPageState extends State<HorarioPage> {
  @override
  Widget build(BuildContext context) {
    var data = context.watch<HorarioData>();
    var ctes = MisConstantes.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          // Semanario
          Container(
            height: ctes.alturaSemanario,
            //child: SemanarioWidget(margin: anchoHoras),
            child: Consumer<HorarioData>(
              builder: (context, data, child) {
                return SemanarioWidget(margin: ctes.anchoColumnaHoras);
              },
            ),
          ),
          // Parrilla Horaria Columnas verticales
          Container(
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top -
                kToolbarHeight -
                ctes.alturaSemanario,
            color: ctes.fondoHorario,
            child: Row(
              children: [
                // Columna de HORAS
                Container(
                  width: ctes.anchoColumnaHoras,
                  padding: EdgeInsets.only(right: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                          height:
                              ctes.separacionHorarioSuperior - ctes.ajusteText),
                      for (var i = 0, t = data.h0;
                          i < data.segmentos.length;
                          t += Duration(minutes: data.segmentos[i++]),) ...[
                        Expanded(
                            flex: data.segmentos[i],
                            child: Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 4),
                                clipBehavior: Clip.none,
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                alignment: Alignment.topRight,
                                child: Text(data.horaFormat(t),
                                    style: TextStyle(
                                      fontSize: 15,
                                      //fontWeight: FontWeight.bold,
                                      color: ctes.textoHorario,
                                    ))) //Text(format(t)),
                            ),
                      ],
                      Text(data.horaFormat(data.horaFinal()),
                          style: TextStyle(
                            fontSize: 15,
                            //fontWeight: FontWeight.bold,
                            color: ctes.textoHorario,
                          )),
                      SizedBox(
                          height:
                              ctes.separacionHorarioSInferior - ctes.ajusteText)
                    ],
                  ),
                ),
                // Columnas de HORARIOS
                for (var i = 0, d = lunesDeLaSemana(data.iSemana);
                    i < 5;
                    i++, d = d.add(Duration(days: 1))) ...[
                  Consumer<HorarioData>(
                    builder: (context, data, child) {
                      return ColumnaDiaria(
                          iDia: i, actividades: data.horario[i], fecha: d);
                    },
                  ),
                  SizedBox(width: 2)
                ],
              ],
            ),
          ),
        ],
      ),
    );

    // return Consumer<CalendarData>(builder: (context, data, child) {
    //   return scaffold;
    // });
  }
}

class ColumnaDiaria extends StatelessWidget {
  const ColumnaDiaria({
    Key key,
    @required this.iDia,
    @required this.actividades,
    @required this.fecha,
  }) : super(key: key);

  final List<Actividad> actividades;
  final int iDia;
  final DateTime fecha;

  @override
  Widget build(BuildContext context) {
    //var data = context.read<HorarioData>(); Nos obliga a camabiar a select
    //final data = context.select((HorarioData d) => d);
    final data = context.watch<HorarioData>();
    var ctes = MisConstantes.of(context);

    var tipo = data.pnl.fold(0, (int previousValue, fechas) {
      //print(
      //'$previousValue ...${fecha.day}/${fecha.month}: ${fechas.from.day}/${fechas.from.month}-${fechas.to.day}/${fechas.to.month}');

      if (fecha.isAfter(fechas.inicio) & fecha.isBefore(fechas.fin)) {
        return max(previousValue, fechas.tipo);
      }
      return previousValue;
    });
    //print('$tipo ${fecha.day}/${fecha.month}');

    return Expanded(
      flex: 1,
      child: Column(
        children: [
          // Nombre del Día de la SEMANA
          Container(
              height: ctes.separacionHorarioSuperior,
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(0, 2, 0, 2),
              decoration: BoxDecoration(
                color: [
                  ctes.textDiaNormal,
                  ctes.textDiaFestivo,
                  ctes.textDiaVacacion
                ][tipo],
                borderRadius: BorderRadius.circular(0),
              ),
              //color: ctes.fondoDiaSemana,
              child: Center(
                child: Text(ctes.nombreDias[iDia],
                    //textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: ctes.fondoDiaSemana)),
              )),
          // Aquí las Actividades
          for (var iAct = 0; iAct < actividades.length; iAct++) ...[
            Expanded(
              flex: actividades[iAct].minutos,
              // Recubro de un detector de Gestos
              // al Widget de Actividad
              child: GestureDetector(
                onTap: () async {
                  // Página de detalle
                  //var data = context.read<HorarioData>();
                  if (tipo > 0) return;

                  var detalle = Detalle(
                      data: data,
                      iDia: iDia,
                      iActividad: iAct,
                      hora: data.horaFormat(data.horaActividad(iDia, iAct)));
                  Actividad response = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetallePage(detalle: detalle),
                    ),
                  );
                  if (response != null) {
                    //Actuamos
                    var data = context.read<HorarioData>();
                    data.quitarActividad(iDia, iAct, !response.asignada);
                    if (response.asignada)
                      data.nuevaActividad(iDia, iAct, response);
                  }
                },
                child:
                    ActividadWidget(actividad: actividades[iAct], tipo: tipo),
              ),
            ),
            //Divider(height: 2)
          ],
          SizedBox(
              height: ctes.separacionHorarioSInferior,
              child: Container()), //Placeholder()),
        ],
      ),
    );
  }
}
