import 'dart:convert';
import 'dart:io';

import 'package:calendar21/model/horario_model.dart';
import 'package:calendar21/services/api_spreadsheets.dart';
import 'package:calendar21/services/storage_horario.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

import 'package:test/test.dart';
import 'package:path_provider/path_provider.dart';

main() {
  MockClient mockClient;
  final listMapJson = {
    "data": [
      {"H": "11:00", "DM": "20"},
      {"H": "11:20", "DM": "30"}
    ]
  };
  setUp(() {
    // Create mock object.
    mockClient = MockClient((request) async {
      var response = Response(jsonEncode(listMapJson), 200, request: request);
      return response;
    });
  });

  group('Horario Storage', () {
    test('Verificamos que obtenemos un directorio null', () {
      //Setup
      final storage = HorarioStorage();
      // Ejecucion

      // Verificacion
      expect(storage.directory, null);
    });

    test('Verificamos que obtenemos el directorio indicado', () async {
      //Setup
      final storage = HorarioStorage(
        directory: await getApplicationDocumentsDirectory(),
      );
      // Ejecucion
      var path = await storage.path;
      // Verificacion
      expect(path, '/home/santi/Documents');
    });
    test('Verificamos que crea archivo por defecto', () async {
      //Setup
      final storage = HorarioStorage();
      // Ejecucion
      File file = await storage.fHorario;
      var name = file.path;
      // Verificacion
      expect(name, '/home/santi/Documents/horario.txt');
    });

    test('Escribimos y leemos el horario desde Storage', () async {
      //Setup
      final apiProvider = ApiSpreadsheetsProvider();
      apiProvider.client = mockClient;
      // Ejecucuon
      var ldt = await apiProvider.fetchLineaDeTiempo();

      var data = Horario(ldt: ldt);
      final storage = HorarioStorage();

      // Ejecucion
      await storage.escribirHorario(data.horario);
      var h = await storage.leerHorario();

      // Verificacion
      // Comparamos el String ara no tener que hacer comparables, etc...
      expect(h[0].toString(), data.horario[0].toString());
    });
  });
}
