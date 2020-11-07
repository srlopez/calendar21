import 'package:calendar21t/provider/app_provider.dart';
import 'package:calendar21t/model/constantes_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SemanarioWidget extends StatefulWidget {
  SemanarioWidget({@required this.margin, this.data});
  final double margin;
  final Data data;

  @override
  _SemanarioWidgetState createState() => _SemanarioWidgetState();
}

class _SemanarioWidgetState extends State<SemanarioWidget> {
  final semanasLimite = 54;

  PageController pageController = PageController(initialPage: 54);

  var _prevIndex = -1000;
  var _i = 0;

  @override
  Widget build(BuildContext context) {
    //final data = context.select((Data d) => d);
    //final establecerSemana = context.select((Data d) => d.establecerSemana);

    var ctes = MisConstantes.of(context);
    //gotoHome == true
    if (widget.data.gotoHome) pageController.jumpToPage(semanasLimite);

    return PageView.builder(
      controller: pageController,
      itemBuilder: (context, _index) {
        final semana = _index - semanasLimite;
        var lunes = lunesDeLaSemana(semana);
        if (_prevIndex != _index) {
          _prevIndex = _index;
          //print('semana $_index ${_i++}');
          widget.data.establecerSemana(lunes, semana);
        }

        return Container(
          color: ctes.fondoSemanario,
          child: Row(children: [
            // Icono de la izda
            SizedBox(
              width: widget.margin,
              child: Material(
                color: Colors.grey[100], //colorBack,
                child: InkWell(
                  splashColor: ctes.textoSemanario,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('${lunes.year % 100}',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black12, //ctes.textoSemanario,
                          )),
                      Text(
                          '${ctes.nombreMes[lunes.month - 1].substring(0, 3).toUpperCase()}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black12, //ctes.textoSemanario,
                          )),
                      // SizedBox(
                      //     //width: 50,
                      //     //height: 50,
                      //     child: Icon(
                      //   Icons.today_rounded,
                      //   color: ctes.textoSemanario,
                      // )),
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
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    //Text('${ctes.nombreMes[lunes.month - 1].substring(0, 3)} '),
                    Text('#${semanaAnual(lunes)}  ',
                        style: TextStyle(
                          fontSize: 16,
                          //fontWeight: FontWeight.bold,
                          color: Colors.black12,
                        ))
                  ]),
                  // Text(
                  //     '#${semanaAnual(lunes)} - ${ctes.nombreMes[lunes.month - 1]} - ${lunes.year} ',
                  //     style: TextStyle(
                  //       fontSize: 16,
                  //       //fontWeight: FontWeight.bold,
                  //       color: ctes.textoSemanario,
                  //     )),
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
                                    color: hoy
                                        ? ctes.textoSemanario
                                        : ctes.fondoSemanario,
                                  ),
                                  child: Center(
                                    child: Text(
                                      lunes
                                          .add(Duration(days: d))
                                          .day
                                          .toString(),
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: hoy
                                            ? ctes.fondoSemanario
                                            : ctes.textoSemanario,
                                      ),
                                    ),
                                  )),
                              // Text(["Lun", "Mar", "Mie", "Jue", "Vie"][d],
                              //     style: TextStyle(
                              //         fontSize: 14,
                              //         //fontWeight: FontWeight.bold,
                              //         color: colorDia)),
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
