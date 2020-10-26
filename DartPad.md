// =======================================

// Cuadro a dibujar
class Cuadro {
  int nhuecos; // numero de huecos que ocupa
  int clase; // -1 no asigando
  int minutos; // numero de minutos asignados
  Cuadro(this.nhuecos, [this.minutos = 0, this.clase = 0]);

  @override
  String toString() {
    //return '$size; $minutes; $type; $color';
    return '$nhuecos/$minutos';
  }

  Cuadro.fromString(String s) {
    //Bloc(0);
    var member = s.split('/');
    this.nhuecos = int.parse(member[0]);
    this.minutos = int.parse(member[1]);
  }
}

// tamaño de 'huecos' en minutos
var huecos = [30, 25, 55, 30, 25, 55, 25, 55, 55, 55, 35];

/// Calcula los minutos de un cuadro
/// desde el hueco h y de una longitud l
int bSize(h, l) {
  var s = 0;
  for (var i = h; i < h + l; i++) s += huecos[i];
  return s;
}

// almacena los cuadros asignados en el horario de Lunes a Viernes
var horario = List<List<Cuadro>>(5);

// Hora cero.
final h0 = Duration(hours: 8, minutes: 0);

// =====================================
main() {
  print(h0);

  // la lista de espacios (en minutos)

  // lista de cantidad de huecos que agrupamos
  horario[0] = [
    Cuadro(1),
    Cuadro(2),
    Cuadro(3),
    Cuadro(1),
    Cuadro(2),
    Cuadro(1),
    Cuadro(3),
  ];

  print('-------------------');
  // Pongo en un dái tantos cuadros como huecos tenemos
  void huecosACuadrosDia(d) {
    horario[d] = [];
    huecos.forEach((m) => horario[d].add(Cuadro(1, m)));
  }

  // Me recalcula los minutos de los cuadros del día d
  void recalculaMinutosDia(var d) {
    horario[d].asMap().forEach((i, b) {
      b.minutos = bSize(i, b.nhuecos);
    });
  }

  /// Asignamos un nuevo Cuadro a un día
  /// El Cuadro debe estar vacio (nhuecos=1 y clase=-1)
  void asignarCuadro(int d, int c, int s) {
    assert(horario[d][c].nhuecos == 1);
    assert(horario[d][c].clase == -1);
    print('${c+s} ${horario[d].length}');
    assert((c + s) <= horario[d].length);

    var list = <Cuadro>[];
    var size = 0;
    var minutes = 0;
    for (var i = c; i < c + s; i++) {
      size += horario[d][i].nhuecos;
      minutes += horario[d][i].minutos;
    }
    for (var i = 0; i < horario[d].length; i++) {
      var cuadro;

      if (i == c) {
        cuadro = Cuadro(size, minutes); //, -1, 0);
        i += s - 1; //salta los cuadros que este agrupa
      } else
        cuadro = horario[d][i];

      list.add(cuadro);
    }
    horario[d] = list;
  }

  /// Eliminamos un Cuadro de un día
  /// El Bloque no está vacio ( type<>-1)
  /// Se crean tantos nuevos bloques como su size
  void quitarCuadro(int d, int b) {
    var nuevaLista = <Cuadro>[];
    var h = 0;

    for (var i = 0; i < horario[d].length; i++) {
      if (i == b) {
        for (var k = 0; k < horario[d][i].nhuecos; k++) {
          var s = bSize(h, 1);
          nuevaLista.add(Cuadro(1, s));
          h += 1;
        }
      } else {
        nuevaLista.add(horario[d][i]);
        h += horario[d][i].nhuecos;
      }
    }
    horario[d] = nuevaLista;
  }

// ========================================================
  // EMPEZAMOS

  huecosACuadrosDia(1);
  recalculaMinutosDia(0);

  print('--------- prueba de conversion a string ----------');

  var hv = horario[0].toString();
  print(horario[0]);
  var hv1 = hv.substring(1, hv.length - 1).split(',');
  var hv2 = hv1.map((b) {
    //print(Bloc.fromString(b));
    //var bl = b.split(';');return Bloc(int.parse(bl[0]), int.parse(bl[1]), int.parse(bl[2]), int.parse(bl[3]));
    return Cuadro.fromString(b);
  }).toList();

  print(hv2);
  print('--------- fin prueba de conversion a string ----------');

  print('--------- test ----------');
  print(bSize(1, 2));
  print(bSize(0, 4));
  print(bSize(huecos.length - 1, 1));

  var d = 0;
  print("=-------- DIA $d --------");

  print(horario[d]);

  var n = 2;
  var l = 3;
  print("=-------- asignar $d:$n/$l ---------");
  asignarCuadro(d, n, 3);
  print(horario[d]);
  n = 3;
  l = 2;
  print("=-------- asignar$d:$n/$l ---------");
  asignarCuadro(d, n, l);
  print(horario[d]);
  n = 0;
  print("=-------- asignar $d:$n/$l ---------");
  asignarCuadro(d, n, l);
  print(horario[d]);

  n = 1;
  l = 2;
  print("=-------- asignar $d:$n/$l ---------");
  asignarCuadro(d, n, l);
  print(horario[d]);

  d = 1;
  print("=-------- DIA $d --------");

  print(horario[d]);

  n = 4;
  l = 3;
  print("=-------- asignar $d:$n/$l --------");
  asignarCuadro(d, n, l);
  print(horario[d]);

  print('--------- quitar $d:$n ----------');
  quitarCuadro(d, n);
  print(horario[d]);

  n = 3;
  l = 3;
  print("=-------- asignar $d:$n/$l --------");
  asignarCuadro(d, n, l);
  print(horario[d]);

  n = 0;
  l = 3;
  print("=-------- asignar $d:$n/$l --------");
  asignarCuadro(d, n, l);
  print(horario[d]);

  n = 1;
  print('--------- quitar $d:$n ----------');
  quitarCuadro(d, n);
  print(horario[d]);
  n = 0;
  print('--------- quitar $d:$n ----------');
  quitarCuadro(d, n);
  print(horario[d]);

  n = 3;
  l = 3;
  print("=-------- asignar $d:$n/$l --------");
  asignarCuadro(d, n, l);
  print(horario[d]);

  n = 6;
  print('--------- quitar $d:$n ----------');
  quitarCuadro(d, n);
  print(horario[d]);

  print('===== FIN ======');
}
