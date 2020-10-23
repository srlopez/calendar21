import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

 
// Cuadro a dibujar
class Cuadro {
  int nhuecos; // numero de huecos que ocupa
  int clase; // -1 no asigando
  int minutos; // numero de minutos asignados
  Cuadro(this.nhuecos, [this.minutos = 0, this.clase = -1]);

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

class HorarioData extends ChangeNotifier {
  // hora inicial
  final h0 = Duration(hours: 8, minutes: 0);

  // tamaño de 'huecos' en minutos
  var huecos = [15, 40, 55, 25, 30, 55, 25, 55, 55, 55, 35]; //11

  // almacena los cuadros asignados en el horario de Lunes a Viernes
  var horario = List<List<Cuadro>>(5);

  // lista de cantidad e huecos por bloque asignado
  var huecosBloque = [1, 2, 3, 1, 2, 1, 1];
  //var huecosBloque = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1];
  // lista de tamaño de los bloques en minutos
  var minutosBloque = <int>[];

  // Repositorio File
  HorarioStorage storage;

  HorarioData() {
    print('Constructor');

    storage = HorarioStorage();
    storage.readHorario().then((l) {
      print('==== from storage =====');
      print(l);
    });

    // print(huecos);
    // print(huecosBloque);
    this.ABORRARcalcularMinutosBloque();

    print(minutosBloque);
    printHoras();
  }

  void printHoras() {
    var t = h0;
    for (var i = 0; i < huecos.length; i++) {
      print(t);
      t += Duration(minutes: huecos[i]);
    }
    print(t);
  }

  void ABORRARcalcularMinutosBloque() {
    assert(huecos.length == huecosBloque.reduce((a, b) => a + b));
    num i = 0; // indice
    num s = 0; // size
    minutosBloque.clear();
    huecosBloque.forEach((num o) {
      for (var j = i; j < i + o; j++) s += huecos[j];
      i += o;

      minutosBloque.add(s);

      s = 0;
    });
    // print('====');
    // print(huecos);
    // print(huecosBloque);
    // print(minutosBloque);
    // print(minutosBloque.reduce((a, b) => a + b));
    // print(huecos.reduce((a, b) => a + b));

    assert(minutosBloque.reduce((a, b) => a + b) ==
        huecos.reduce((a, b) => a + b));
    notifyListeners();
    storage.writeHorario(minutosBloque);
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

  Future<List<int>> readHorario() async {
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

  Future<File> writeHorario(List<int> l) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString(l.toString());
  }
}
