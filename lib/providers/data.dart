import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
// import 'dart:convert';
import '../models/actividad_model.dart';

class HorarioData extends ChangeNotifier {
  // Repositorio File
  HorarioStorage storage;

  // vvv Segmentos horarios  ================
  // hora inicial
  final h0 = Duration(hours: 8, minutes: 0);

  // Tamaño de 'segmentos' en minutos
  var segmentos = [15, 40, 55, 25, 30, 55, 25, 55, 55, 55];

  Duration horaFinal() {
    Duration h = h0;
    for (var i = 0; i < segmentos.length; i++)
      h += Duration(minutes: segmentos[i]);
    return h;
  }

  Duration horaActividad(int iDia, int iAct) {
    Duration h = h0;
    for (var i = 0; i < iAct; i++)
      h += Duration(minutes: horario[iDia][i].minutos);
    return h;
  }

  String horaFormat(Duration d) {
    var h = d.toString().split(':');
    return '${h[0]}:${h[1]}';
  }

  // Calcula los minutos de un grupo de segmentos
  // desde el iSegmento y de una longitud nsegmentos
  int nMinutos(iSegmento, nSegmentos) {
    var minutos = 0;
    for (var i = iSegmento; i < iSegmento + nSegmentos; i++)
      minutos += segmentos[i];
    return minutos;
  }
  // ^^^ Segmentos horarios =================

  // vvv Horario ============================

  // Almacena los actividades asignados en el horario de Lunes a Viernes
  var horario = List<List<Actividad>>(5);

  // Pongo en un día tantos actividads como segmentos tenemos = Reset
  void resetDia(dia) {
    horario[dia] = [];
    segmentos
        .forEach((minutos) => horario[dia].add(Actividad(1, minutos, false)));
  }

  // Me recalcula los minutos de las actividades del día d
  void recalculaMinutosDia(var dia) {
    var iSegmento = 0;
    horario[dia].asMap().forEach((idx, actividad) {
      actividad.minutos = nMinutos(iSegmento, actividad.nsegmentos);
      iSegmento += actividad.nsegmentos;
    });
  }

  /// Reasignamos una Actividad en un segmento horario
  /// La Actividad debe estar vacia (nsegmentos=1 y asignada=false)
  /// antes de ser asignada
  void nuevaActividad(int dia, int iActividad, Actividad act) {
    // print(
    //    '$dia;$iActividad;$nSegmentos - ${horario[dia][iActividad].nsegmentos};${horario[dia][iActividad].clase}');
    assert(horario[dia][iActividad].nsegmentos == 1);
    assert(horario[dia][iActividad].asignada == false);
    // la longitud asignado <= total actividads del día
    assert((iActividad + act.nsegmentos) <= horario[dia].length);

    var list = <Actividad>[];
    var nuevonsegmentos = 0;
    var nuevominutos = 0;
    for (var i = iActividad; i < iActividad + act.nsegmentos; i++) {
      nuevonsegmentos += horario[dia][i].nsegmentos;
      nuevominutos += horario[dia][i].minutos;
    }
    for (var i = 0; i < horario[dia].length; i++) {
      var actividad;

      if (i == iActividad) {
        //actividad = Actividad(nuevonsegmentos, nuevominutos, clase); //, -1, 0);
        actividad = act;
        actividad.nsegmentos = nuevonsegmentos;
        actividad.minutos = nuevominutos;
        i += act.nsegmentos - 1; //salta los actividads que este agrupa
      } else
        actividad = horario[dia][i];

      list.add(actividad);
    }
    horario[dia] = list;

    notifyListeners();
    storage.escribirHorario(horario);
  }

  /// Eliminamos un Actividad de un día
  /// El Bloque no está vacio (asignada==true)
  /// Se restauran tantos nuevos bloques vacíos como su size
  void quitarActividad(int dia, int iActividad, [bool save = false]) {
    assert(horario[dia][iActividad].asignada == true);

    var nuevaLista = <Actividad>[];
    var iSegmento = 0;

    for (var i = 0; i < horario[dia].length; i++) {
      if (i == iActividad) {
        for (var k = 0; k < horario[dia][i].nsegmentos; k++) {
          nuevaLista.add(Actividad(1, nMinutos(iSegmento, 1)));
          iSegmento += 1;
        }
      } else {
        nuevaLista.add(horario[dia][i]);
        iSegmento += horario[dia][i].nsegmentos;
      }
    }
    horario[dia] = nuevaLista;

    // Si despues de 'quitar' hemos de 'guardar' evitamos save y notify
    if (save) {
      notifyListeners();
      storage.escribirHorario(horario);
    }
  }

  void test() {
    void testreasignaActividad(int dia, int iActividad,
        [int nSegmentos = 1, bool clase = false]) {
      // print(
      //    '$dia;$iActividad;$nSegmentos - ${horario[dia][iActividad].nsegmentos};${horario[dia][iActividad].clase}');
      //assert(horario[dia][iActividad].nsegmentos == 1);
      //assert(horario[dia][iActividad].clase == -1);
      // la longitud asignado <= total actividads del día
      nSegmentos = (iActividad + nSegmentos) <= horario[dia].length
          ? nSegmentos
          : horario[dia].length - iActividad;

      assert((iActividad + nSegmentos) <= horario[dia].length);

      var list = <Actividad>[];
      var nuevonsegmentos = 0;
      var nuevominutos = 0;
      for (var i = iActividad; i < iActividad + nSegmentos; i++) {
        nuevonsegmentos += horario[dia][i].nsegmentos;
        nuevominutos += horario[dia][i].minutos;
      }
      for (var i = 0; i < horario[dia].length; i++) {
        var actividad;

        if (i == iActividad) {
          actividad =
              Actividad(nuevonsegmentos, nuevominutos, clase); //, -1, 0);
          i += nSegmentos - 1; //salta los actividads que este agrupa
        } else
          actividad = horario[dia][i];

        list.add(actividad);
      }
      horario[dia] = list;

      notifyListeners();
      storage.escribirHorario(horario);
    }

    var d = 0;
    //print("=-------- DIA $d --------");

    //print(horario[d]);

    var n = 2;
    var l = 3;
    //print("=-------- asignar $d:$n/$l ---------");
    testreasignaActividad(d, n, 3);
    //print(horario[d]);
    n = 3;
    l = 2;
    //print("=-------- asignar$d:$n/$l ---------");
    testreasignaActividad(d, n, l);
    //print(horario[d]);
    n = 0;
    //print("=-------- asignar $d:$n/$l ---------");
    testreasignaActividad(d, n, l);
    //print(horario[d]);

    n = 1;
    l = 2;
    //print("=-------- asignar $d:$n/$l ---------");
    testreasignaActividad(d, n, l);
    //print(horario[d]);

    d = 1;
    //print("=-------- DIA $d --------");

    //print(horario[d]);

    n = 4;
    l = 3;
    //print("=-------- asignar $d:$n/$l --------");
    testreasignaActividad(d, n, l);
    //print(horario[d]);

    //print('--------- quitar $d:$n ----------');
    testreasignaActividad(d, n);
    //print(horario[d]);

    n = 3;
    l = 3;
    //print("=-------- asignar $d:$n/$l --------");
    testreasignaActividad(d, n, l);
    //print(horario[d]);

    n = 0;
    l = 3;
    //print("=-------- asignar $d:$n/$l --------");
    testreasignaActividad(d, n, l);
    //print(horario[d]);

    n = 1;
    //print('--------- quitar $d:$n ----------');
    quitarActividad(d, n);
    //print(horario[d]);
    n = 0;
    //print('--------- quitar $d:$n ----------');
    quitarActividad(d, n);
    //print(horario[d]);

    n = 3;
    l = 3;
    //print("=-------- asignar $d:$n/$l --------");
    testreasignaActividad(d, n, l, true);
    //print(horario[d]);

    n = 6;
    //print('--------- quitar $d:$n ----------');
    quitarActividad(d, n);
    //print(horario[d]);

    testreasignaActividad(d, 6, 3, true);
  }

  // ===================   CONSTRUCTOR =======================
  HorarioData();
  Future init() async {
    print('Constructor async');
    storage = HorarioStorage();

    //for (var i in List<int>.generate(5, (i) => i)) resetDia(i);
    //test();
    //  print(horario);

    //await storage.escribirHorario(horario);
    horario = await storage.leerHorario();
    if (horario[0] == null)
      // En caso de estar vacío el horario lo reseteamos
      for (var i in List<int>.generate(5, (i) => i)) resetDia(i);
    //print('======CONSTRUCTOR =====');
    //print(horario);
  }
}

// ========================================
class HorarioStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localHorarioFile async {
    final path = await _localPath;
    return File('$path/Horario.txt').create(recursive: true);
  }

  // Future<File> get _localClaseFile async {
  //   final path = await _localPath;
  //   return File('$path/Clase.json');
  // }

  Future<List<List<Actividad>>> leerHorario() async {
    try {
      var h = List<List<Actividad>>(5);
      var d = -1;
      final file = await _localHorarioFile;
      //  String contents = await file.readAsString();
      //  print(contents);
      List<String> lines = file.readAsLinesSync();
      lines.forEach((line) {
        h[++d] = [];
        for (var c in line.split(',')) {
          h[d].add(Actividad.fromString(c));
        }
      });
      return h;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Future<File> escribirHorario(List<List<Actividad>> l) async {
  //   final file = await _localFile;

  //   // Write the file
  //   return file.writeAsString(l.toString());
  // }

  Future<File> escribirHorario(List<List<Actividad>> l) async {
    final file = await _localHorarioFile;
    var sb = StringBuffer();

    for (var d = 0; d < l.length; d++) {
      var s = l[d].toString();
      sb.writeln(s.substring(1, s.length - 1));
    }
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
