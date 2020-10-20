```dart
main() {
  final h0 = Duration(hours: 8, minutes: 0);
  print(h0);

  // la lista de espacios (en minutos)
  var bloquesBase = [30, 25, 55, 30, 25, 55, 25, 55, 55, 55, 35]; //11
  // lista de cantidad de huecos que agrupamos
  var espaciosAsignados = [1, 2, 3, 1, 2, 1, 1];
  // lista de los huecos en minutos
  var espaciosOcupados = <int>[];

  void calcularBloques() {
    assert(bloquesBase.length == espaciosAsignados.reduce((a, b) => a + b));
    num i = 0; // indice
    num s = 0; // size
    espaciosOcupados.clear();
    espaciosAsignados.forEach((num o) {
      for (var j = i; j < i + o; j++) s += bloquesBase[j];
      i += o;

      espaciosOcupados.add(s);
      s = 0;
    });

    // print(bloquesBase);
    // print(espaciosAsignados);
    // print(espaciosOcupados);

    assert(espaciosOcupados.reduce((a, b) => a + b) ==
        espaciosAsignados.reduce((a, b) => a + b));
  }

  void quitarBloque(int i) {
    var nuevaAsignacion = <int>[];
    for (var j = 0; j < espaciosAsignados.length; j++) {
      if (j == i)
        nuevaAsignacion
            .addAll(List<int>.generate(espaciosAsignados[i], (i) => 1));
      else
        nuevaAsignacion.add(espaciosAsignados[j]);
    }
    espaciosAsignados = nuevaAsignacion;

    assert(espaciosOcupados.reduce((a, b) => a + b) ==
        espaciosAsignados.reduce((a, b) => a + b));
  }

  void asignarBloque(int i, int s) {
    var nuevaAsignacion = <int>[];

    for (var j = 0; j < espaciosAsignados.length; j++) {
      if (j == i) {
        nuevaAsignacion.add(s);
        j += s - 1;
      } else
        nuevaAsignacion.add(espaciosAsignados[j]);
    }
    espaciosAsignados = nuevaAsignacion;

    assert(espaciosOcupados.reduce((a, b) => a + b) ==
        espaciosAsignados.reduce((a, b) => a + b));
  }

  print("======= calcular =======");
  print(bloquesBase);
  print(espaciosAsignados);
  calcularBloques();
  print(espaciosOcupados);

  print("======= quitar =======");
  quitarBloque(2);
  print(espaciosAsignados);
  calcularBloques();
  print(espaciosOcupados);

  print("======= establecer =======");
  asignarBloque(2, 3);
  print(espaciosAsignados);
  calcularBloques();
  print(espaciosOcupados);
}
```

