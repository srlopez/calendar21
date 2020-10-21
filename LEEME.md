class Bloc {
  int size; // numero de huecos que ocupa
  int type; // -1 no asigando
  int minutes; // numero de minutos asignados
  int color;
  Bloc(this.size, [this.minutes = 0, this.type = 0, this.color = 0]);

  @override
  String toString() {
    //return '$size; $minutes; $type; $color';
    return '$size/$minutes';
  }

  Bloc.fromString(String s) {
    //Bloc(0);
    var member=s.split('/');
    this.size = int.parse(member[0]);
    this.minutes = int.parse(member[1]);
  }
}

main() {
  final h0 = Duration(hours: 8, minutes: 0);
  print(h0);

  // la lista de espacios (en minutos)
  var minutosHueco = [30, 25, 55, 30, 25, 55, 25, 55, 55, 55, 35];

  // lista de cantidad de huecos que agrupamos
  var huecosBloque = [
    Bloc(1),
    Bloc(2),
    Bloc(3),
    Bloc(1),
    Bloc(2),
    Bloc(1),
    Bloc(3),
  ];
  print('-------------------');
  void minutosToBloc() {
    huecosBloque = [];
    minutosHueco.forEach((m) => huecosBloque.add(Bloc(1, m)));
  }

  /// Calcula los minutos de un grupo
  /// desde el hueco h y de una longitud l
  int bSize(h, l) {
    var s = 0;
    for (var i = h; i < h + l; i++) s += minutosHueco[i];
    return s;
  }

  void recalculaMinutosBloc() {
    huecosBloque.asMap().forEach((i, b) {
      b.minutes = bSize(i, b.size);
    });
  }

  /// Asignamos un Nuevo Bloque a una lista de Bloques
  /// El Bloque debe estar vacio (size=1 y type=-1)
  /// ???Los bloques que se eliminan deben estar vacíos
  void asignarBloque(int b, int s) {
    assert(huecosBloque[b].size == 1);
    assert(huecosBloque[b].type == -1);

    var list = <Bloc>[];
    var size = 0;
    var minutes = 0;
    for (var i = b; i < b + s ; i++) {
      size += huecosBloque[i].size;
      minutes += huecosBloque[i].minutes;
    }
    for (var i = 0; i < huecosBloque.length; i++) {
      var bloc;

      if (i == b) {
        //bloc = Bloc(s, bSize(i, s));//, -1, 0);
        bloc = Bloc(size, minutes); //, -1, 0);
        i += s - 1; //salta los bloques que este agrupa
      } else
        bloc = huecosBloque[i];

      list.add(bloc);
    }
    huecosBloque = list;
  }

  /// Eliminamos un Bloque a una lista de Bloques
  /// El Bloque no está vacio ( type<>-1)
  /// Se crean tantos nuevos bloques como su size
  void quitarBloque(int b) {
    var nuevaAsignacion = <Bloc>[];
    var h = 0;

    for (var i = 0; i < huecosBloque.length; i++) {
      if (i == b) {
        for (var k = 0; k < huecosBloque[i].size; k++) {
          var s = bSize(h, 1);
          nuevaAsignacion.add(Bloc(1, s));
          h += 1;
        }
      } else {
        nuevaAsignacion.add(huecosBloque[i]);
        h += huecosBloque[i].size;
      }
    }
    huecosBloque = nuevaAsignacion;
  }

  //minutosToBloc();
  recalculaMinutosBloc();

  var hv = huecosBloque.toString();
  print(huecosBloque);
  var hv1 = hv.substring(1, hv.length - 1).split(',');
  var hv2 = hv1.map((b) {
    //print(Bloc.fromString(b));
    //var bl = b.split(';');return Bloc(int.parse(bl[0]), int.parse(bl[1]), int.parse(bl[2]), int.parse(bl[3]));
    return Bloc.fromString(b);
  }).toList();

  print(hv2);

  print('--------- test ----------');
  print(bSize(1, 2));
  print(bSize(0, 4));
  print(bSize(minutosHueco.length - 1, 1));

  var n = 2;
  var l = 3;
  print("=-------- asignar $n/$l ---------");
  asignarBloque(n, 3);
  print(huecosBloque);
  n = 4;
  l = 2;
  print("=-------- asignar $n/$l ---------");
  asignarBloque(n, l);
  print(huecosBloque);
  n = 0;
  print("=-------- asignar $n/$l ---------");
  asignarBloque(n, l);
  print(huecosBloque);
  n = 4;
  l = 3;
  print("=-------- asignar $n/$l --------");
  asignarBloque(n, 3);
  print(huecosBloque);

  print('--------- quitar $n ----------');
  quitarBloque(n);
  print(huecosBloque);

  n = 1;
  print('--------- quitar $n ----------');
  quitarBloque(n);
  print(huecosBloque);
  n = 0;
  print('--------- quitar $n ----------');
  quitarBloque(n);
  print(huecosBloque);
  n = 6;
  print('--------- quitar $n ----------');
  quitarBloque(n);
  print(huecosBloque);

  print('=====');
  print('-------------------');
  print('-------------------');
  var espaciosAsignados = [1, 2, 3, 1, 2, 1, 1];
  // lista de los huecos en minutos
  var espaciosOcupados = <int>[];

  void calcularBloques() {
    assert(minutosHueco.length == espaciosAsignados.reduce((a, b) => a + b));
    num i = 0; // indice
    num s = 0; // size
    espaciosOcupados.clear();
    espaciosAsignados.forEach((num o) {
      for (var j = i; j < i + o; j++) s += minutosHueco[j];
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

  void quitarBloqueS(int i) {
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

  void asignarBloqueS(int i, int s) {
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
  print(minutosHueco);
  print(espaciosAsignados);
  calcularBloques();
  print(espaciosOcupados);

  print("======= quitar =======");
  quitarBloqueS(2);
  print(espaciosAsignados);
  calcularBloques();
  print(espaciosOcupados);

  print("======= establecer =======");
  asignarBloqueS(2, 3);
  print(espaciosAsignados);
  calcularBloques();
  print(espaciosOcupados);

  print('=====');
  var s1 = espaciosOcupados.toString();
  print('$s1');
  var l1 = s1.substring(1, s1.length - 1).split(',');
  var l2 = l1.map((i) => int.parse(i)).toList();
  print(l2.runtimeType);
  print(l2.length);

  var ls = [];
  ls.add([1, 2, 3, 4, 5]);
  ls.add([1, 2, 3, 4, 5]);
  ls.add([1, 2, 3, 4, 5]);
  ls.add([1, 2, 3, 4, 5]);
  ls.add([1, 2, 3, 4, 5]);
}
