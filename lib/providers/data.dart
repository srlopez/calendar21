import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
// import 'dart:convert';

// Cuadro a dibujar
class Cuadro {
  int nhuecos; // numero de huecos que ocupa
  int clase; // -1 no asigando
  int minutos; // numero de minutos asignados
  String titulo;
  String subtitulo;
  String pie;
  int color;
  Cuadro(this.nhuecos,
      [this.minutos = 0,
      this.clase = -1,
      this.titulo = '',
      this.subtitulo = '',
      this.pie = '',
      this.color = 0]);

  @override
  String toString() =>
      '$nhuecos/$minutos/$clase/$titulo/$subtitulo/$pie/$color';

  Cuadro.fromString(String s) {
    var member = s.split('/');
    this.nhuecos = int.parse(member[0]);
    this.minutos = int.parse(member[1]);
    this.clase = int.parse(member[2]);
    this.titulo = member[3];
    this.subtitulo = member[4];
    this.pie = member[5];
    this.color = int.parse(member[6]);
  }
}

class HorarioData extends ChangeNotifier {
  // ===============  MIEMBROS ==============
  // Repositorio File
  HorarioStorage storage;

  // hora inicial
  final h0 = Duration(hours: 8, minutes: 0);

  // Tamaño de 'huecos' en minutos
  var huecos = [15, 40, 55, 25, 30, 55, 25, 55, 55, 55, 35]; //11

  // Almacena los cuadros asignados en el horario de Lunes a Viernes
  var horario = List<List<Cuadro>>(5);

  // Los patrones de ID TITULO/SUBTITULO/PIE/COLOR
  //var clase = Map<String, int>();

  // ===============  METODOS ================
  /// Calcula los minutos de un cuadro
  /// desde el ihueco y de una longitud nhuecos
  int nMinutos(ihueco, nhuecos) {
    var minutos = 0;
    for (var i = ihueco; i < ihueco + nhuecos; i++) minutos += huecos[i];
    return minutos;
  }

  // Pongo en un día tantos cuadros como huecos tenemos = Reset
  void resetDia(dia) {
    horario[dia] = [];
    huecos.forEach((minutos) => horario[dia].add(Cuadro(1, minutos, -1)));
  }

  // Me recalcula cuadros en minutos del día d
  void recalculaMinutosDia(var dia) {
    var iHueco = 0;
    horario[dia].asMap().forEach((idx, cuadro) {
      cuadro.minutos = nMinutos(iHueco, cuadro.nhuecos);
      iHueco += cuadro.nhuecos;
    });
  }

  /// Reasignamos un Cuadro
  /// El Cuadro debe estar vacio (nhuecos=1 y clase=-1)
  void reasignaCuadro(int dia, int iCuadro, int nHuecos, [int clase = 0]) {
    // print(
    //    '$dia;$iCuadro;$nHuecos - ${horario[dia][iCuadro].nhuecos};${horario[dia][iCuadro].clase}');
    //assert(horario[dia][iCuadro].nhuecos == 1);
    //assert(horario[dia][iCuadro].clase == -1);
    // la longitud asignado <= total cuadros del día
    assert((iCuadro + nHuecos) <= horario[dia].length);

    var list = <Cuadro>[];
    var nuevonhuecos = 0;
    var nuevominutos = 0;
    for (var i = iCuadro; i < iCuadro + nHuecos; i++) {
      nuevonhuecos += horario[dia][i].nhuecos;
      nuevominutos += horario[dia][i].minutos;
    }
    for (var i = 0; i < horario[dia].length; i++) {
      var cuadro;

      if (i == iCuadro) {
        cuadro = Cuadro(nuevonhuecos, nuevominutos, clase); //, -1, 0);
        i += nHuecos - 1; //salta los cuadros que este agrupa
      } else
        cuadro = horario[dia][i];

      list.add(cuadro);
    }
    horario[dia] = list;

    notifyListeners();
    //storage.escribirHorario(horario);
  }

  /// Eliminamos un Cuadro de un día
  /// El Bloque no está vacio (type<>-1)
  /// Se restauran tantos nuevos bloques vacíos como su size
  void quitarCuadro(int dia, int iCuadro) {
    var nuevaLista = <Cuadro>[];
    var iHueco = 0;

    for (var i = 0; i < horario[dia].length; i++) {
      if (i == iCuadro) {
        for (var k = 0; k < horario[dia][i].nhuecos; k++) {
          nuevaLista.add(Cuadro(1, nMinutos(iHueco, 1)));
          iHueco += 1;
        }
      } else {
        nuevaLista.add(horario[dia][i]);
        iHueco += horario[dia][i].nhuecos;
      }
    }
    horario[dia] = nuevaLista;

    notifyListeners();
  }

  void test() {
    var d = 0;
    //print("=-------- DIA $d --------");

    //print(horario[d]);

    var n = 2;
    var l = 3;
    //print("=-------- asignar $d:$n/$l ---------");
    reasignaCuadro(d, n, 3);
    //print(horario[d]);
    n = 3;
    l = 2;
    //print("=-------- asignar$d:$n/$l ---------");
    reasignaCuadro(d, n, l);
    //print(horario[d]);
    n = 0;
    //print("=-------- asignar $d:$n/$l ---------");
    reasignaCuadro(d, n, l);
    //print(horario[d]);

    n = 1;
    l = 2;
    //print("=-------- asignar $d:$n/$l ---------");
    reasignaCuadro(d, n, l);
    //print(horario[d]);

    d = 1;
    //print("=-------- DIA $d --------");

    //print(horario[d]);

    n = 4;
    l = 3;
    //print("=-------- asignar $d:$n/$l --------");
    reasignaCuadro(d, n, l);
    //print(horario[d]);

    //print('--------- quitar $d:$n ----------');
    quitarCuadro(d, n);
    //print(horario[d]);

    n = 3;
    l = 3;
    //print("=-------- asignar $d:$n/$l --------");
    reasignaCuadro(d, n, l);
    //print(horario[d]);

    n = 0;
    l = 3;
    //print("=-------- asignar $d:$n/$l --------");
    reasignaCuadro(d, n, l);
    //print(horario[d]);

    n = 1;
    //print('--------- quitar $d:$n ----------');
    quitarCuadro(d, n);
    //print(horario[d]);
    n = 0;
    //print('--------- quitar $d:$n ----------');
    quitarCuadro(d, n);
    //print(horario[d]);

    n = 3;
    l = 3;
    //print("=-------- asignar $d:$n/$l --------");
    reasignaCuadro(d, n, l, 2);
    //print(horario[d]);

    n = 6;
    //print('--------- quitar $d:$n ----------');
    quitarCuadro(d, n);
    //print(horario[d]);

    reasignaCuadro(d, 6, 3, 1);
  }

  // ===================   CONSTRUCTOR =======================
  HorarioData();
  Future init() async {
    print('Constructor async');
    storage = HorarioStorage();

    for (var i in List<int>.generate(5, (i) => i)) resetDia(i);
    test();
    //print(horario);

    await storage.escribirHorario(horario);
    horario = await storage.leerHorario();

    print('======CONSTRUCTOR =====');
    print(horario);
  }
}

// ========================================

// ========================================
class HorarioStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localHorarioFile async {
    final path = await _localPath;
    return File('$path/Horario.txt');
  }

  // Future<File> get _localClaseFile async {
  //   final path = await _localPath;
  //   return File('$path/Clase.json');
  // }

  Future<List<List<Cuadro>>> leerHorario() async {
    try {
      var h = List<List<Cuadro>>(5);
      var d = -1;
      final file = await _localHorarioFile;
      //  String contents = await file.readAsString();
      //  print(contents);
      List<String> lines = file.readAsLinesSync();
      lines.forEach((line) {
        //print('line: $l');

        h[++d] = [];
        for (var c in line.split(',')) {
          //print('$c');
          h[d].add(Cuadro.fromString(c));
        }
      });
      return h;
      //l.map((i) => int.parse(i)).toList();
    } catch (e) {
      print(e.toString());
      return [[], [], [], [], []];
    }
  }

  // Future<File> escribirHorario(List<List<Cuadro>> l) async {
  //   final file = await _localFile;

  //   // Write the file
  //   return file.writeAsString(l.toString());
  // }

  Future<File> escribirHorario(List<List<Cuadro>> l) async {
    final file = await _localHorarioFile;
    var sb = StringBuffer();

    for (var d = 0; d < l.length; d++) {
      var s = l[d].toString();
      sb.writeln(s.substring(1, s.length - 1));
    }
    print('====escribir======');
    print(sb.toString());
    // Write the file
    return file.writeAsString(sb.toString());
    //return  file.writeAsStringSync(sb.toString());
  }

  // Future<Map<String, int>> leerClases() async {
  //   try {
  //     var d = -1;
  //     final file = await _localClaseFile;
  //     return jsonDecode(await file.readAsString());
  //   } catch (e) {
  //     print(e.toString());
  //     return {};
  //   }
  // }

  // Future<File> escribirClase(Map<String, int> m) async {
  //   final file = await _localHorarioFile;
  //   return file.writeAsString(jsonEncode(m).toString());
  // }
}
