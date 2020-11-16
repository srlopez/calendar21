import 'dart:convert';

import 'package:calendar21/model/linea_de_tiempo_model.dart';
import 'package:calendar21/services/api_spreadsheets.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:test/test.dart';

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

  group('Linea De Tiempo', () {
    test('Verificamos que fectchSegmentos devuelve una lista de Mapas',
        () async {
      //Setup
      final apiProvider = ApiSpreadsheetsProvider();
      apiProvider.client = mockClient;
      // Ejecucion
      var response = await apiProvider.fetchResponseSegmentos();
      // Verificacion
      expect(response.body, contains('data'));
      expect(jsonDecode(response.body)['data'][1]['H'],
          listMapJson['data'][1]['H']);
    });

    test('Obtenemos lo que queremos de fechtLDT', () async {
      // Setup
      final apiProvider = ApiSpreadsheetsProvider();
      apiProvider.client = mockClient;
      // Ejecucuon
      LineaDeTiempo ldt = await apiProvider.fetchLineaDeTiempo();
      //print(ldt.segmentos);
      // Verificacion
      expect(ldt.h0, Duration(hours: 11, minutes: 0));
      expect(ldt.segmentos[1], 30);
    });
    test('La hora final se calcula correctamente', () async {
      // Setup
      final apiProvider = ApiSpreadsheetsProvider();
      apiProvider.client = mockClient;
      // Ejecucuon
      var ldt = await apiProvider.fetchLineaDeTiempo();
      //print(ldt.segmentos);
      // Verificacion
      expect(ldt.horaFinal(), Duration(hours: 11, minutes: 50));
    });

    test('Lalista de horas es correcta', () async {
      // Setup
      final apiProvider = ApiSpreadsheetsProvider();
      apiProvider.client = mockClient;
      // Ejecucuon
      var ldt = await apiProvider.fetchLineaDeTiempo();
      //print(ldt.segmentos);
      // Verificacion
      var ldh = ldt.listaHoras();
      expect(ldh.length, 3);
      expect(ldh.last, "11:50");
    });
  });
}
