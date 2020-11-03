import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import '../models/actividad_model.dart';
import '../pages/actividad_widget.dart';
import '../pages/semanario_widget.dart';
import '../models/detalle_model.dart';
import '../providers/data.dart';
import 'detalle_page.dart';

final gapTop = 10.0;
final gapBottom = 20.0;

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
    final alturaSemanario = 60.0; //80.0;
    final anchoHoras = 60.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          // Semanario
          Container(
            height: alturaSemanario,
            //child: SemanarioWidget(margin: anchoHoras),
            child: Consumer<HorarioData>(
              builder: (context, data, child) {
                return SemanarioWidget(margin: anchoHoras);
              },
            ),
          ),
          // Parrilla Horaria Columnas verticales
          Container(
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top -
                kToolbarHeight -
                alturaSemanario,
            color: Colors.grey[100],
            child: Row(
              children: [
                // Columna de HORAS
                Container(
                  width: anchoHoras,
                  padding: EdgeInsets.only(right: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(data.horaFormat(data.h0)),
                      SizedBox(height: gapTop / 2),
                      for (var i = 1,
                              t = data.h0 +
                                  Duration(minutes: data.segmentos[0]);
                          i < data.segmentos.length;
                          t += Duration(minutes: data.segmentos[i++]),) ...[
                        Expanded(
                            flex: data.segmentos[i],
                            child: Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 4),
                                clipBehavior: Clip.none,
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                alignment: Alignment.topRight,
                                //color: Colors.indigoAccent,
                                child:
                                    Text(data.horaFormat(t))) //Text(format(t)),
                            ),
                      ],
                      Text(data.horaFormat(data.horaFinal())),
                      SizedBox(height: gapBottom - 10)
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

    var tipo = data.excepciones.fold(0, (int previousValue, fechas) {
      //print(
      //'$previousValue ...${fecha.day}/${fecha.month}: ${fechas.from.day}/${fechas.from.month}-${fechas.to.day}/${fechas.to.month}');

      if (fecha.isAfter(fechas.from) & fecha.isBefore(fechas.to)) {
        return max(previousValue, fechas.tipo);
      }
      return previousValue;
    });
    print('$tipo ${fecha.day}/${fecha.month}');

    return Expanded(
      flex: 1,
      child: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                  height: gapTop,
                  child: Container(
                      color: [
                    Colors.grey[100],
                    Colors.green,
                    Colors.amber
                  ][tipo])), //Gap para ajustar la hora
              //for (var actividad in dia) ...[
              for (var iAct = 0; iAct < actividades.length; iAct++) ...[
                Expanded(
                  flex: actividades[iAct].minutos,
                  // Recubro de un detector de Gestos
                  // al Widget de Actividad
                  child: GestureDetector(
                    onTap: () async {
                      // Página de detalle
                      //var data = context.read<HorarioData>();
                      var detalle = Detalle(
                          data: data,
                          iDia: iDia,
                          iActividad: iAct,
                          hora:
                              data.horaFormat(data.horaActividad(iDia, iAct)));
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
                    child: ActividadWidget(actividad: actividades[iAct]),
                  ),
                ),
                //Divider(height: 2)
              ],
              SizedBox(height: gapBottom, child: Container()), //Placeholder()),
            ],
          ),
          // tipo == 1
          //     ? SizedBox(
          //         height: double.infinity,
          //         width: double.infinity,
          //         child: Container(color: Color.fromRGBO(255, 255, 255, 0.5)),
          //       )
          //     : tipo == 2
          //         ? SizedBox(
          //             height: double.infinity,
          //             width: double.infinity,
          //             child:
          //                 Container(color: Color.fromRGBO(200, 200, 200, 0.5)),
          //           )
          //         : Container(),
        ],
      ),
    );
  }
}
