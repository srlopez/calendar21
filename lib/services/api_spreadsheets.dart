import 'dart:convert' as convert;
import 'package:calendar21t/model/diario_model.dart';
import 'package:calendar21t/model/linea_de_tiempo_model.dart';
import 'package:calendar21t/model/no_lectivos_model.dart';
import 'package:http/http.dart' as http;

class ApiSpreadsheetsProvider {
  http.Client client = http.Client();

  Future<http.Response> _fetch(url) async {
    var response = await client.get(url);
    if (response.statusCode == 200) return response;
    print('Request failed with status: ${response.statusCode}.');
    return null;
  }

  Future<http.Response> fetchResponseSegmentos() async {
    return _fetch('https://api.apispreadsheets.com/data/3065/');
  }

  Future<LineaDeTiempo> fetchLineaDeTiempo() async {
    var ldt = LineaDeTiempo();
    var response = await fetchResponseSegmentos();
    var data = convert.jsonDecode(response.body)['data'];
    var h = data[0]['H'].split(':');
    ldt.h0 = Duration(hours: int.parse(h[0]), minutes: int.parse(h[1]));
    ldt.segmentos = [];
    data.forEach((element) => ldt.segmentos.add(int.parse(element['DM'])));

    return ldt;
  }

  Future<http.Response> fetchResponsePNLs() async {
    return _fetch('https://api.apispreadsheets.com/data/3063/');
  }

  Future<List<PNL>> fetchPNLs() async {
    var pnls = <PNL>[];
    var response = await fetchResponsePNLs();
    var data = convert.jsonDecode(response.body)['data'];

    data.forEach((element) {
      //print(element['FIN'].toString().length);
      DateTime fin = element['FIN'].toString().length > 0
          ? DateTime.parse('${element['FIN']} 00:00:00.000')
          : null;

      //print(          '${element['INICIO']} 00:00:00.000  -  ${element['FIN']} 00:00:00.000   -$fin');
      try {
        pnls.add(PNL(
          tipo: int.parse(element['TIPO']),
          inicio: DateTime.parse('${element['INICIO']} 00:00:00.000'),
          fin: fin,
        ));
      } catch (e) {
        print('$e');
        print('Error en ${element['DESCRIPCION']} ${element['INICIO']}');
      }
    });
    // pnls.forEach((element) {
    //   print('${element.tipo}  ${element.inicio} ${element.fin}');
    // });
    return pnls;
  }

  Future<http.Response> fetchResponseApuntesDiarios() async {
    return _fetch('https://api.apispreadsheets.com/data/3064/');
  }

  Future<List<ApunteDiario>> fetchApuntesDiarios() async {
    var apuntes = <ApunteDiario>[];
    var response = await fetchResponseApuntesDiarios();
    var data = convert.jsonDecode(response.body)['data'];

    data.forEach((element) => apuntes.add(ApunteDiario(
          fecha: DateTime.parse('${element['FECHA']} 00:00:00.000'),
          nombre: element['NOMBRE'],
          notas: element['NOTAS'],
        )));

    return apuntes;
  }
}
