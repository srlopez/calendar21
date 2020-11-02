import 'package:flutter/material.dart';

class SemanarioWidget extends StatelessWidget {
  final semanasLimite = 54;
  final PageController pageController = PageController(initialPage: 54);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: PageView.builder(
      controller: pageController,
      itemBuilder: (context, _index) {
        final semana = _index - semanasLimite;
        var lunes = lunesDeLaSemana(semana);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('#${semanaAnual(lunes)} ${lunes.toString().substring(5, 7)}'),
            Row(children: [
              for (var d = 0; d < 5; d++)
                Column(children: [
                  Text(
                      lunes.add(Duration(days: d)).toString().substring(8, 11)),
                  Text(["L", "M", "X", "J", "V"][d]),
                  Text(esHoy(lunes.add(Duration(days: d))) ? 'Hoy' : ''),
                ])
            ]),
          ],
        );
      },
    ));
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
