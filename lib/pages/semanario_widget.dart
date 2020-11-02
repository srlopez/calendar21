import 'package:flutter/material.dart';

class SemanarioWidget extends StatelessWidget {
  SemanarioWidget({@required this.margin});
  final double margin;

  final semanasLimite = 54;
  final PageController pageController = PageController(initialPage: 54);
  final colorDia = Colors.grey[300];

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: pageController,
      itemBuilder: (context, _index) {
        final semana = _index - semanasLimite;
        var lunes = lunesDeLaSemana(semana);

        return Container(
          color: Theme.of(context).primaryColor,
          child: Row(children: [
            // Icono
            SizedBox(
              width: margin,
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipOval(
                    child: Material(
                      color: Theme.of(context).primaryColor,
                      child: InkWell(
                        splashColor: colorDia, // inkwell color
                        child: SizedBox(
                            width: 50,
                            height: 50,
                            child: Icon(
                              Icons.today_rounded,
                              color: colorDia,
                            )),
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
                  //SizedBox(height: 6),
                  Text('#${semanaAnual(lunes)}',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colorDia)),
                ],
              ),
            ),

            // La semana
            Expanded(
              flex: 1,
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      '${[
                        "ENE",
                        "FEB",
                        "MAR",
                        "ABR",
                        "MAY",
                        "JUN",
                        "JUL",
                        "AGO",
                        "SEP",
                        "OCT",
                        "Nov",
                        "DIC"
                      ][lunes.month - 1]} ${lunes.year}',
                      style: TextStyle(
                          fontSize: 18,
                          //fontWeight: FontWeight.bold,
                          color: colorDia)),
                  SizedBox(height: 3),
                  Row(children: [
                    for (var d = 0, hoy = esHoy(lunes);
                        d < 5;
                        d++, hoy = esHoy(lunes.add(Duration(days: d))))
                      Expanded(
                        flex: 1,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(["Lun", "Mar", "Mie", "Jue", "Vie"][d],
                                  style: TextStyle(
                                      fontSize: 18,
                                      //fontWeight: FontWeight.bold,
                                      color: colorDia)),
                              Container(
                                  width: 30.0,
                                  height: 30.0,
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: hoy
                                        ? colorDia
                                        : Theme.of(context).primaryColor,
                                  ),
                                  child: Center(
                                    child: Text(
                                      lunes
                                          .add(Duration(days: d))
                                          .day
                                          .toString(),
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: hoy
                                            ? Theme.of(context).primaryColor
                                            : colorDia,
                                      ),
                                    ),
                                  )),
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
