import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../model/actividad_model.dart';

class HorarioStorage {
  Directory directory;
  File horarioFile;

  HorarioStorage({var this.directory}) {
    //print(directory?.path ?? 'null directory.path');
  }

  get path async => directory.path;
  get fHorario async => await _localHorarioFile;

  Future<String> get _localPath async {
    directory = directory ?? await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localHorarioFile async {
    final path = directory?.path ?? await _localPath;
    return File('$path/horario.txt').create(recursive: true);
  }

  // Future<File> get _localSegmentosFile async {
  //   final path = await _localPath;
  //   return File('$path/Segmentos.txt');
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
