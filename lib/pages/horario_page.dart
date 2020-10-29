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
          /*
          GestureDetector(
            onTap: () async {
              var detalle = Detalle();
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (_) => DetallePage(detalle: detalle)))
                  .then(
                (response) {
                  print(response?.titulo);
                },
              );
              // Detalle response = await Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => DetallePage(),
              //   ),
              // );
              // if (response != null) {
              //   /// Validas si la pantalla se cierra sin mandar datos

              // }
            },
            
            child: */
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
                          Text(format(data.h0)),
                          SizedBox(height: 30)
                        ],
                      ),
                    ),
                  ],
                ),
                for (var i = 0; i < 5; i++) ...[
                  ColumnaDiaria(iDia: i, dia: data.horario[i]),
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
// vemos donde estamos
                  print('dia: $iDia');
                  print('act: $iAct');

                  var detalle = Detalle(
                    data: context.read<HorarioData>(),
                    iDia: iDia,
                    iActividad: iAct,
                  );
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                          builder: (_) => DetallePage(detalle: detalle)))
                      .then(
                    (response) {
                      print(response?.titulo);
                    },
                  );
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
