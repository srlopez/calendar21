import 'package:flutter/widgets.dart';

class CalendarData extends ChangeNotifier {
  // hora inicial
  final h0 = Duration(hours: 8, minutes: 0);

  // la lista de huecos (en minutos)
  var minutosHueco = [15, 40, 55, 25, 30, 55, 25, 55, 55, 55, 35]; //11
  // lista de cantidad e huecos por bloque asignado
  var huecosBloque = [1, 2, 3, 1, 2, 1, 1];
  // lista de tamaño de los bloques en minutos
  var minutosBloque = <int>[];

  CalendarData() {
    // print('Constructor');
    // print(minutosHueco);
    // print(huecosBloque);
    this.calcularMinutosBloque();
    // print(minutosBloque);
  }

  void calcularMinutosBloque() {
    assert(minutosHueco.length == huecosBloque.reduce((a, b) => a + b));
    num i = 0; // indice
    num s = 0; // size
    minutosBloque.clear();
    huecosBloque.forEach((num o) {
      for (var j = i; j < i + o; j++) s += minutosHueco[j];
      i += o;

      minutosBloque.add(s);
      s = 0;
    });

    // print('====');
    // print(minutosHueco);
    // print(huecosBloque);
    // print(minutosBloque);
    // print(minutosBloque.reduce((a, b) => a + b));
    // print(minutosHueco.reduce((a, b) => a + b));

    assert(minutosBloque.reduce((a, b) => a + b) ==
        minutosHueco.reduce((a, b) => a + b));
    notifyListeners();
  }

  void quitarBloque(int i) {
    var nuevosHuecosBloque = <int>[];
    for (var j = 0; j < huecosBloque.length; j++) {
      if (j == i)
        nuevosHuecosBloque
            .addAll(List<int>.generate(huecosBloque[i], (i) => 1));
      else
        nuevosHuecosBloque.add(huecosBloque[j]);
    }
    huecosBloque = nuevosHuecosBloque;
    calcularMinutosBloque();

    notifyListeners();
  }

  void asignarBloque(int i, int s) {
    var nuevosHuecosBloque = <int>[];

    for (var j = 0; j < huecosBloque.length; j++) {
      if (j == i) {
        nuevosHuecosBloque.add(s);
        j += s - 1;
      } else
        nuevosHuecosBloque.add(huecosBloque[j]);
    }
    huecosBloque = nuevosHuecosBloque;
    calcularMinutosBloque();

    notifyListeners();
  }
}
