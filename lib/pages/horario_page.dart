import 'package:calendar21/models/actividad_model.dart';
import 'package:calendar21/pages/actividad_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/detalle_model.dart';
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
    final barraHeight = 40.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          SizedBox(
            //espacio para dias
            height: barraHeight,
            child: Container(), //Placeholder(),
          ),
          // ),//Gesture
          Container(
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top -
                kToolbarHeight -
                barraHeight,
            color: Colors.grey[100],
            child: Row(
              children: [
                Row(
                  children: [
                    Container(
                      //Columna de HORAS
                      width: 60,
                      padding: EdgeInsets.only(right: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(data.horaFormat(data.h0)),
                          SizedBox(height: 5),
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
                                    child: Text(
                                        data.horaFormat(t))) //Text(format(t)),
                                ),
                          ],
                          Text(data.horaFormat(data.horaFinal())),
                          SizedBox(height: 30)
                        ],
                      ),
                    ),
                  ],
                ),
                for (var i = 0; i < 5; i++) ...[
                  Consumer<HorarioData>(
                    builder: (context, data, child) {
                      return ColumnaDiaria(iDia: i, dia: data.horario[i]);
                    },
                  ),
                  SizedBox(width: 2)
                ],
              ],
            ),
          ),
          //SizedBox(height: barraHeight, child: Center(child: Text('pie'))),
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
    @required this.dia,
  }) : super(key: key);

  final List<Actividad> dia;
  final int iDia;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Column(
        children: [
          SizedBox(height: 10), //Gap para ajustar la hora
          //for (var actividad in dia) ...[
          for (var iAct = 0; iAct < dia.length; iAct++) ...[
            Expanded(
              flex: dia[iAct].minutos,
              // Recubro de un detector de Gestos
              // al Widget de Actividad
              child: GestureDetector(
                onTap: () async {
                  // Página de detalle
                  var data = context.read<HorarioData>();
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
                child: ActividadWidget(actividad: dia[iAct]),
              ),
            ),
            //Divider(height: 2)
          ],
          SizedBox(height: 40, child: Container()), //Placeholder()),
        ],
      ),
    );
  }
}
