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

    format(Duration d) {
      var h = d.toString().split(':');
      return '${h[0]}:${h[1]}';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          SizedBox(
            //hueco ar dias
            height: barraHeight,
            child: Placeholder(),
          ),
          // ),//Gesture
          Container(
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top -
                kToolbarHeight -
                barraHeight,
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
                          Text(format(data.h0)),
                          SizedBox(height: 5),
                          for (var i = 1,
                                  t = data.h0 +
                                      Duration(minutes: data.huecos[0]);
                              i < data.huecos.length;
                              t += Duration(minutes: data.huecos[i++]),) ...[
                            Expanded(
                                flex: data.huecos[i],
                                child: Container(
                                    margin: EdgeInsets.fromLTRB(0, 0, 0, 4),
                                    clipBehavior: Clip.none,
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    alignment: Alignment.topRight,
                                    //color: Colors.indigoAccent,
                                    child: Text(format(t))) //Text(format(t)),
                                ),
                          ],
                          Text(format(data.hFinal())),
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
                  var detalle = Detalle(
                      data: context.read<HorarioData>(),
                      iDia: iDia,
                      iActividad: iAct);
                  Actividad response = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetallePage(detalle: detalle),
                    ),
                  );
                  if (response != null) {
                    //Actuamos
                    var data = context.read<HorarioData>();
                    data.quitarActividad(iDia, iAct);
                    //data.reasignaActividad(iDia, iAct, response.nhuecos);
                    if (response.asignada)
                      data.nuevaActividad(iDia, iAct, response);
                  }
                },
                child: ActividadWidget(actividad: dia[iAct]),
              ),
            ),
            //Divider(height: 2)
          ],
          SizedBox(height: 40, child: Placeholder()),
        ],
      ),
    );
  }
}
