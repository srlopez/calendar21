import 'package:calendar21/services/api_spreadsheets.dart';

import 'package:test/test.dart';

main() {
  setUp(() {});

  group('Periodos No Lectivos', () {
    test('Obtenemos lo que queremos de fechtLDT', () async {
      // Setup
      final apiProvider = ApiSpreadsheetsProvider();
      // Ejecucuon
      var pnls = await apiProvider.fetchPNLs();
      pnls.forEach((element) {
        //print('${element.tipo} ${element.inicio} ${element.fin}');
      });

      // Verificacion
      expect(pnls.length > 0, true);
    });
  });
}
