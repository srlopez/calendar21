import 'package:calendar21/model/actividad_model.dart';
import 'package:calendar21/model/detalle_model.dart';
import 'package:calendar21/provider/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import '../pages/actividad_widget.dart';
import '../pages/semanario_widget.dart';
import '../model/constantes_model.dart';

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
    var data = context.watch<Data>();
    var ctes = MisConstantes.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.today),
              onPressed: (() => context.read<Data>().establecerSemanActual())),
          PopupMenuButton<String>(
            onSelected: ((value) {
              if (value == 'Actualizar') context.read<Data>().reInitialize();
            }),
            itemBuilder: (BuildContext context) {
              return {'Actualizar'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Semanario
          Container(
            height: ctes.alturaSemanario,
            //child: SemanarioWidget(margin: anchoHoras),
            child: Consumer<Data>(
              builder: (context, data, child) {
                return SemanarioWidget(
                    margin: ctes.anchoColumnaHoras, data: data);
              },
            ),
          ),
          // Parrilla Horaria Columnas verticales
          Expanded(
            flex: 1,
            child: Container(
              // height: MediaQuery.of(context).size.height -
              //     MediaQuery.of(context).padding.top -
              //     kToolbarHeight -
              //     ctes.alturaSemanario,
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
                            height: ctes.separacionHorarioSuperior -
                                ctes.ajusteText),
                        for (var i = 0, t = data.ldt.horaInicial();
                            i < data.ldt.segmentos.length;
                            t += Duration(
                                minutes: data.ldt.segmentos[i++]),) ...[
                          Expanded(
                              flex: data.ldt.segmentos[i],
                              child: Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 4),
                                  clipBehavior: Clip.none,
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  alignment: Alignment.topRight,
                                  child: Text(data.ldt.horaFormat(t),
                                      style: TextStyle(
                                        fontSize: 15,
                                        //fontWeight: FontWeight.bold,
                                        color: ctes.textoHorario,
                                      ))) //Text(format(t)),
                              ),
                        ],
                        Text(data.ldt.horaFormat(data.ldt.horaFinal()),
                            style: TextStyle(
                              fontSize: 15,
                              //fontWeight: FontWeight.bold,
                              color: ctes.textoHorario,
                            )),
                        SizedBox(
                            height: ctes.separacionHorarioSInferior -
                                ctes.ajusteText)
                      ],
                    ),
                  ),
                  // Columnas de HORARIOS
                  for (var i = 0, d = lunesDeLaSemana(data.miSemana);
                      i < 5;
                      i++, d = d.add(Duration(days: 1))) ...[
                    Consumer<Data>(
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
    final data = context.watch<Data>();
    var ctes = MisConstantes.of(context);

    var tipoDia = data.pnls.fold(0, (int previousValue, pnl) {
      //print(          '$previousValue ...${fecha.day}/${fecha.month}: ${pnl.inicio.day}/${pnl.inicio.month}-${pnl.fin.day}/${pnl.inicio.month}');

      if (fecha.isAfter(pnl.inicio) && fecha.isBefore(pnl.fin)) {
        return max(previousValue, pnl.tipo);
      }
      return previousValue;
    });
    if (tipoDia > 0) print('$tipoDia ${fecha.day}/${fecha.month}');

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
                ][tipoDia],
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
                onTap: tipoDia > 1
                    ? null
                    : () async {
                        // Página de detalle
                        if (tipoDia > 0) return;

                        var detalle = Detalle(
                            data: data,
                            iDia: iDia,
                            iActividad: iAct,
                            hora: data.ldt.horaFormat(
                                (data.horaDeLaActividad(iDia, iAct))));
                        Actividad response = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetallePage(detalle: detalle),
                          ),
                        );
                        if (response != null) {
                          //Actuamos
                          var data = context.read<Data>();
                          data.quitarActividadDelDia(
                              iDia, iAct, !response.asignada);
                          if (response.asignada)
                            data.nuevaActividadEnDelDia(iDia, iAct, response);
                        }
                      },
                child: ActividadWidget(
                    actividad: actividades[iAct], tipoDia: tipoDia),
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
