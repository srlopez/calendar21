Algoritmo para calcular el tamaño de los huecos.


```dart
 void main() {
  //var espaciosBase = [10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10];
  var espaciosBase = [30, 25, 55, 30, 25, 55, 25, 55, 55, 55, 35]; //11
  var espaciosOcupados = <int>[];

  var espaciosAsignados = [1, 2, 3, 1, 2, 1, 1];

  assert(espaciosBase.length == espaciosAsignados.reduce((a, b) => a + b));

  num i = 0;
  num s = 0;
  espaciosAsignados.forEach((num o) {
    for (var j = i; j < i + o; j++) s += espaciosBase[j];
    i += o;

    espaciosOcupados.add(s);
    s = 0;
  });

  print(espaciosBase);
  print(espaciosAsignados);
  print(espaciosOcupados);

  assert(espaciosOcupados.reduce((a, b) => a + b) ==
      espaciosAsignados.reduce((a, b) => a + b));

  print('================');
// i=2 h=3/2
// algoritmo par i=2
// [1, 2, (3), 1, 2, 1, 1];
  print(espaciosAsignados);

  i = 2;
  s = 2;
  var nuevaAsignacion1 = <int>[];
  for (var j = 0; j < espaciosAsignados.length; j++) {
    if (j == i)
      nuevaAsignacion1
          .addAll(List<int>.generate(espaciosAsignados[i], (i) => 1));
    else
      nuevaAsignacion1.add(espaciosAsignados[j]);
  }
  print(nuevaAsignacion1);

  var nuevaAsignacion2 = <int>[];

  for (var j = 0; j < nuevaAsignacion1.length; j++) {
    if (j == i) {
      nuevaAsignacion2.add(s);
      j += s - 1;
    } else
      nuevaAsignacion2.add(nuevaAsignacion1[j]);
  }
  print(nuevaAsignacion2);

// Devolver 3 a sus estado 1 1 1
// [1, 2, ((1,1),1), 1, 2, 1, 1];
// Y ajustar de nuevo a la nueva longitud
// [1, 2, 2, 1, 1, 2, 1, 1];
}

```