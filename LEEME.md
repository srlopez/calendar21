```dart
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
}
```