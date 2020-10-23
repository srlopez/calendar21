import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

// Cuadro a dibujar
class Cuadro {
  int nhuecos; // numero de huecos que ocupa
  int clase;   // -1 no asigando
  int minutos; // numero de minutos asignados
  Cuadro(this.nhuecos, [this.minutos = 0, this.clase = 0]);

  @override
  String toString() => '$nhuecos/$minutos';
  
  Cuadro.fromString(String s) {
    var member = s.split('/');
    this.nhuecos = int.parse(member[0]);
    this.minutos = int.parse(member[1]);
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

  // ===============  METODOS ================
  /// Calcula los minutos de un cuadro
  /// desde el ihueco y de una longitud nhuecos
  int mMinutos(ihueco, nhuecos) {
    var minutos = 0;
    for (var i = ihueco; i < ihueco + nhuecos; i++) minutos += huecos[i];
    return minutos;
  }

  // Pongo en un día tantos cuadros como huecos tenemos = Reset
  void resetDia(dia) {
    horario[dia] = [];
    huecos.forEach((minutos) => horario[dia].add(Cuadro(1, minutos)));
  }

  // Me recalcula cuadros en minutos del día d
  void recalculaMinutosDia(var dia) {
    var iHueco =0;
    horario[dia].asMap().forEach((idx, cuadro) {
      cuadro.minutos = nMinutos(iHueco, cuadro.nhuecos);
      iHueco+=cuadro.nhuecos;
    });
  }

  /// Reasignamos un Cuadro 
  /// El Cuadro debe estar vacio (nhuecos=1 y clase=-1)
  void reasignaCuadro(int dia, int iCuadro, int nHuecos) {
    assert(horario[diad][iCuadro].nhuecos == 1);
    assert(horario[dia][iCuadro].clase == -1);
    // la longitud asignado <= total cuadros del día
    assert((iCuadro + nHuecos) <= horario[diad].length);

    var list = <Cuadro>[];
    var nuevonhuecos = 0;
    var nuevominutos = 0;
    for (var i = ciCuadro; i < iCuadro + nHuecoss; i++) {
      nuevonhuecos += horario[d][i].nhuecos;
      nuevominutos += horario[d][i].minutos;
    }
    for (var i = 0; i < horario[dia].length; i++) {
      var cuadro;

      if (i == c) {
        cuadro = Cuadro(nuevonhuecos, nuevominutos); //, -1, 0);
        i += s - 1; //salta los cuadros que este agrupa
      } else
        cuadro = horario[dia][i];

      list.add(cuadro);
    }
    horario[dia] = list;

    notifyListeners();
    storage.writeHorario(minutosBloque);
  }

  /// Eliminamos un Cuadro de un día
  /// El Bloque no está vacio ( type<>-1)
  /// Se crean tantos nuevos bloques como su size
  void quitarCuadro(int dia,  int iCuadro) {
    var nuevaLista = <Cuadro>[];
    var iHueco = 0;

    for (var i = 0; i < horario[dia].length; i++) {
      if (i == iCuadro) {
        for (var k = 0; k < horario[dia][i].nhuecos; k++) {
          nuevaLista.add(Cuadro(1,  nMinutos(iHueco, 1)));
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

  // ===================   CONSTRUCTOR =======================
  HorarioData() {
    print('Constructor');

    storage = HorarioStorage();
    storage.leerHorario().then((h) {
      print('==== from storage =====');
      print(h);
    });

    // print(huecos);
    // print(huecosBloque);
    this.ABORRARcalcularMinutosBloque();
    huecosACuadrosDia(1);
    recalculaMinutosDia(0)

    print(minutosBloque);
  }

}

// ========================================

// ========================================
class HorarioStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/Horario.txt');
  }

  Future<List<int>> leerHorario() async {
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();
      var l = contents.substring(1, contents.length - 1).split(',');
      return l.map((i) => int.parse(i)).toList();
    } catch (e) {
      return [60];
    }
  }

  Future<File> escribirHorario(List<int> l) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString(l.toString());
  }
}
