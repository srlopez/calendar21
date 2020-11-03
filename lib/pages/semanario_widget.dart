import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/data.dart';

class SemanarioWidget extends StatefulWidget {
  SemanarioWidget({@required this.margin});
  final double margin;

  @override
  _SemanarioWidgetState createState() => _SemanarioWidgetState();
}

class _SemanarioWidgetState extends State<SemanarioWidget> {
  final semanasLimite = 54;

  final PageController pageController = PageController(initialPage: 54);

  var _prevIndex = -1000;

  @override
  Widget build(BuildContext context) {
    final data = context.select((HorarioData d) => d);

    // final colorDia = Colors.grey[300];
    // final colorBack = Theme.of(context).primaryColor;
    final colorDia = Colors.blueGrey[700]; //.of(context).primaryColor;
    final colorBack = Colors.grey[200];

    return PageView.builder(
      controller: pageController,
      itemBuilder: (context, _index) {
        final semana = _index - semanasLimite;
        var lunes = lunesDeLaSemana(semana);
        //var data = context.read<HorarioData>();
        if (_prevIndex != _index) {
          _prevIndex = _index;
          data.establecerSemana(lunes, semana);
        }

        return Container(
          color: colorBack,
          child: Row(children: [
            // Icono de la izda
            SizedBox(
              width: widget.margin,
              child: Material(
                color: colorBack,
                child: InkWell(
                  splashColor: colorDia, // inkwell color
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('NOV',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: colorDia)),

                      // SizedBox(
                      //     //width: 50,
                      //     //height: 50,
                      //     child: Icon(
                      //   Icons.today_rounded,
                      //   color: colorDia,
                      // )),
                      Text('${lunes.year % 100}/${semanaAnual(lunes)}',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: colorDia)),
                    ],
                  ),
                  onTap: () {
                    // pageController
                    //     .jumpToPage(semanasLimite);
                    pageController.animateToPage(semanasLimite,
                        curve: Curves.decelerate,
                        duration: Duration(milliseconds: 300));
                  },
                ),
              ),
            ),

            // La semana
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Text(
                  //     '${[
                  //       "Enero",
                  //       "Febrero",
                  //       "Marzo",
                  //       "Abril",
                  //       "Mayo",
                  //       "Junio",
                  //       "Julio",
                  //       "Agosto",
                  //       "Septiembre",
                  //       "Octubre",
                  //       "Noviembre",
                  //       "Diciembre"
                  //     ][lunes.month - 1]} ${lunes.year} ',
                  //     style: TextStyle(
                  //         fontSize: 16,
                  //         //fontWeight: FontWeight.bold,
                  //         color: colorDia)),
                  //SizedBox(height: 8),
                  Row(children: [
                    for (var d = 0, hoy = esHoy(lunes);
                        d < 5;
                        d++, hoy = esHoy(lunes.add(Duration(days: d))))
                      Expanded(
                        flex: 1,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  width: 30.0,
                                  height: 30.0,
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: hoy ? colorDia : colorBack,
                                  ),
                                  child: Center(
                                    child: Text(
                                      lunes
                                          .add(Duration(days: d))
                                          .day
                                          .toString(),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: hoy ? colorBack : colorDia,
                                      ),
                                    ),
                                  )),
                              Text(["Lun", "Mar", "Mie", "Jue", "Vie"][d],
                                  style: TextStyle(
                                      fontSize: 14,
                                      //fontWeight: FontWeight.bold,
                                      color: colorDia)),
                            ]),
                      ),
                  ])
                ],
              ),
            ),
          ]),
        );
      },
    );
  }
}

DateTime esteLunes() {
  var hoy = DateTime.now();
  return hoy.add(Duration(days: 1 - hoy.weekday));
}

DateTime lunesDeLaSemana(int iSemana) {
  var lunes = esteLunes();
  return lunes.add(Duration(days: 7 * iSemana));
}

bool esHoy(DateTime dia) {
  var hoy = DateTime.now();

  if ((dia.day == hoy.day) & (dia.month == hoy.month) & (dia.year == hoy.year))
    return true;
  return false;
}

int semanaAnual(DateTime dia) {
  var dia1 = DateTime.parse(dia.year.toString() + "-01-01");
  return ((dia.difference(dia1).inDays) / 7).ceil() + 1;
}
