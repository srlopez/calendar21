import 'package:calendar21/services/api_spreadsheets.dart';

import 'package:test/test.dart';

main() {
  setUp(() {});

  group('Apuntes Diarios', () {
    test('Obtenemos lo que queremos de fechtApuntes', () async {
      // Setup
      final apiProvider = ApiSpreadsheetsProvider();
      // Ejecucuon
      var list = await apiProvider.fetchApuntesDiarios();
      list.forEach((element) {
        //print('${element.fecha} ${element.nombre} ${element.notas}');
      });

      // Verificacion
      expect(list.length > 0, true);
    });
  });
}
