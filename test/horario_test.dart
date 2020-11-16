import 'dart:convert';

import 'package:calendar21/model/actividad_model.dart';
import 'package:calendar21/model/horario_model.dart';
import 'package:calendar21/services/api_spreadsheets.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

import 'package:test/test.dart';

main() {
  Horario data;
  final segmentos = {
    "data": [
      {"H": "08:00", "DM": "15"},
      {"H": "08:15", "DM": "40"},
      {"H": "08:55", "DM": "55"},
      {"H": "09:50", "DM": "25"},
      {"H": "10:15", "DM": "30"},
      {"H": "10:45", "DM": "55"},
      {"H": "11:40", "DM": "25"},
      {"H": "12:05", "DM": "55"},
      {"H": "13:00", "DM": "55"},
      {"H": "13:55", "DM": "55"},
      {"H": "14:50", "DM": "35"},
      {"H": "15:25", "DM": "60"},
      {"H": "16:25", "DM": "60"},
      {"H": "17:25", "DM": "60"},
      {"H": "18:25", "DM": "60"},
      {"H": "19:25", "DM": "60"}
    ]
  };
  setUp(() async {
    MockClient mockClient;
    mockClient = MockClient((request) async {
      var response = Response(jsonEncode(segmentos), 200, request: request);
      return response;
    });

    ApiSpreadsheetsProvider apiProvider;
    apiProvider = ApiSpreadsheetsProvider();
    apiProvider.client = mockClient;
    var ldt = await apiProvider.fetchLineaDeTiempo();

    data = Horario(ldt: ldt);
  });

  group('Horario Test', () {
    test('Creamos el horario correctamente segun la ldt', () async {
      //Setup

      // Verificacion
      expect(data.horario.length, 5); //l.m,x,j,v
      expect(data.horario[0].length, segmentos["data"].length);
    });

    test('Añadimos #0 Actividad', () {
      // Setup
      var act0 = Actividad(3, 0, true, 'tit', 'sub', 'pie', 0);
      var dia = 0;

      //print(data.horario[dia]);

      var actDiaria = data.establecerActividad(data.horario[dia], 0, act0);
      data.horario[dia] = actDiaria;

      // print(data.horario[dia]);
      // print(data.horario[dia].length);
      // print(segmentos["data"].length - act0.segmentos + 1);

      expect(data.horario[dia].length,
          segmentos["data"].length - act0.segmentos + 1);
      expect(data.horario[dia][0].asignada, true);
    });

    test('Añadimos #3 Actividad', () {
      // Setup
      var act = [
        Actividad(3, 0, true, '=0=', 'sub', 'pie', 0),
        Actividad(3, 0, true, '=1=', 'sub', 'pie', 0),
      ];
      var dia = 3;

      //print(data.horario[dia]);

      var actDiaria = data.establecerActividad(data.horario[dia], 0, act[0]);
      //print(actDiaria);

      actDiaria = data.establecerActividad(actDiaria, 3, act[1]);
      //print(actDiaria);

      data.horario[dia] = actDiaria;

      // print(data.horario[dia].length);
      // print(act.fold(-act.length,
      //    (previousValue, element) => element.segmentos + previousValue));

      expect(
          data.horario[dia].length,
          segmentos["data"].length -
              act.fold(
                  -act.length,
                  (previousValue, element) =>
                      element.segmentos + previousValue));

      expect(data.horario[dia][3].asignada, true);
    });

    test('Añadimos #2 y #5 Actividad', () {
      // Setup
      var act = [
        Actividad(3, 0, true, '=0=', 'sub', 'pie', 0),
        Actividad(3, 0, true, '=1=', 'sub', 'pie', 0),
        Actividad(20, 0, true, '=2=', 'sub', 'pie', 0),
        Actividad(3, 0, true, '=3=', 'sub', 'pie', 0),
        Actividad(5, 0, true, '=4=', 'sub', 'pie', 0),
      ];
      var dia = 3;

      //print(data.horario[dia]);

      var actDiaria = data.establecerActividad(data.horario[dia], 0, act[0]);
      //print(actDiaria);
      actDiaria = data.establecerActividad(actDiaria, 3, act[1]);
      //print(actDiaria);
      actDiaria = data.establecerActividad(actDiaria, 10, act[2]);
      //print(actDiaria);
      actDiaria = data.establecerActividad(actDiaria, 2, act[3]);
      //print(actDiaria);
      actDiaria = data.establecerActividad(actDiaria, 5, act[4]);
      //print(actDiaria);

      data.horario[dia] = actDiaria;

      // print(data.horario[dia].length);
      // print(segmentos["data"].length -
      // act.fold(-act.length,
      //     (previousValue, element) => element.segmentos + previousValue));

      expect(
          data.horario[dia].length,
          segmentos["data"].length -
              act.fold(
                  -act.length,
                  (previousValue, element) =>
                      element.segmentos + previousValue));

      expect(data.horario[dia].last.asignada, true);
    });

    test('Quitamos Actividad', () {
      // Setup
      var act = [
        Actividad(3, 0, true, '=0=', 'sub', 'pie', 0),
        Actividad(3, 0, true, '=1=', 'sub', 'pie', 0),
        Actividad(20, 0, true, '=2=', 'sub', 'pie', 0),
        Actividad(3, 0, true, '=3=', 'sub', 'pie', 0),
        Actividad(5, 0, true, '=4=', 'sub', 'pie', 0),
      ];
      var dia = 3;

      var actDiaria = data.establecerActividad(data.horario[dia], 0, act[0]);
      actDiaria = data.establecerActividad(actDiaria, 3, act[1]);
      actDiaria = data.establecerActividad(actDiaria, 10, act[2]);
      actDiaria = data.establecerActividad(actDiaria, 2, act[3]);
      actDiaria = data.establecerActividad(actDiaria, 5, act[4]);
      //print(actDiaria);

      actDiaria = data.quitarActividad(actDiaria, 5);
      //print(actDiaria);
      actDiaria = data.quitarActividad(actDiaria, 2);
      //print(actDiaria);
      actDiaria = data.quitarActividad(actDiaria, 0);
      //print(actDiaria);

      expect(
          segmentos['data'].length,
          actDiaria.fold(0,
              (previousValue, element) => element.segmentos + previousValue));

      expect(data.horario[dia].last.asignada, false);
      expect(data.horario[dia].first.asignada, false);
    });

    test(
        'Restablecer Dia de Actividad a un nuevo Segmento horario de la misma longitud',
        () {
      // Setup
      var act = [
        Actividad(3, 0, true, '=0=', 'sub', 'pie', 0),
        Actividad(3, 0, true, '=1=', 'sub', 'pie', 0),
        Actividad(20, 0, true, '=2=', 'sub', 'pie', 0),
        Actividad(3, 0, true, '=3=', 'sub', 'pie', 0),
        Actividad(5, 0, true, '=4=', 'sub', 'pie', 0),
      ];
      var dia = 3;

      var actDiaria = data.establecerActividad(data.horario[dia], 0, act[0]);
      actDiaria = data.establecerActividad(actDiaria, 3, act[1]);
      actDiaria = data.establecerActividad(actDiaria, 10, act[2]);
      actDiaria = data.establecerActividad(actDiaria, 2, act[3]);
      actDiaria = data.establecerActividad(actDiaria, 5, act[4]);
      //print(actDiaria);
      final reset = [
        55,
        55,
        55,
        55,
        30,
        55,
        55,
        55,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10
      ];

      actDiaria = data.reestablecerActividades(actDiaria, reset);
      //print(actDiaria);

      expect(
          reset.length,
          actDiaria.fold(0,
              (previousValue, element) => element.segmentos + previousValue));
      expect(
          reset.fold(0, (previousValue, element) => element + previousValue),
          actDiaria.fold(
              0, (previousValue, element) => element.minutos + previousValue));
    });

    test(
        'Restablecer Dia de Actividad a un nuevo Segmento horario de longitud mayor',
        () {
      // Setup
      var act = [
        Actividad(3, 0, true, '=0=', 'sub', 'pie', 0),
        Actividad(3, 0, true, '=1=', 'sub', 'pie', 0),
        Actividad(20, 0, true, '=2=', 'sub', 'pie', 0),
        Actividad(3, 0, true, '=3=', 'sub', 'pie', 0),
        Actividad(5, 0, true, '=4=', 'sub', 'pie', 0),
      ];
      var dia = 3;

      var actDiaria = data.establecerActividad(data.horario[dia], 0, act[0]);
      actDiaria = data.establecerActividad(actDiaria, 3, act[1]);
      actDiaria = data.establecerActividad(actDiaria, 10, act[2]);
      actDiaria = data.establecerActividad(actDiaria, 2, act[3]);
      actDiaria = data.establecerActividad(actDiaria, 5, act[4]);
      //print(actDiaria);
      final reset = [
        55,
        55,
        55,
        55,
        30,
        55,
        55,
        55,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10,
        10
      ];

      actDiaria = data.reestablecerActividades(actDiaria, reset);
      //print(actDiaria);

      expect(
          reset.length,
          actDiaria.fold(0,
              (previousValue, element) => element.segmentos + previousValue));
      expect(
          reset.fold(0, (previousValue, element) => element + previousValue),
          actDiaria.fold(
              0, (previousValue, element) => element.minutos + previousValue));
    });

    test(
        'Restablecer Dia de Actividad a un nuevo Segmento horario de menor longitud',
        () {
      // Setup
      var act = [
        Actividad(3, 0, true, '=0=', 'sub', 'pie', 0),
        Actividad(3, 0, true, '=1=', 'sub', 'pie', 0),
        Actividad(20, 0, true, '=2=', 'sub', 'pie', 0),
        Actividad(3, 0, true, '=3=', 'sub', 'pie', 0),
        Actividad(5, 0, true, '=4=', 'sub', 'pie', 0),
      ];
      var dia = 3;

      var actDiaria = data.establecerActividad(data.horario[dia], 0, act[0]);
      actDiaria = data.establecerActividad(actDiaria, 3, act[1]);
      actDiaria = data.establecerActividad(actDiaria, 10, act[2]);
      actDiaria = data.establecerActividad(actDiaria, 2, act[3]);
      actDiaria = data.establecerActividad(actDiaria, 5, act[4]);
      //print(actDiaria);
      final reset = [
        55,
        55,
        55,
        55,
        30,
        55,
        55,
        55,
      ];

      actDiaria = data.reestablecerActividades(actDiaria, reset);
      //print(actDiaria);

      expect(
          reset.length,
          actDiaria.fold(0,
              (previousValue, element) => element.segmentos + previousValue));
      expect(
          reset.fold(0, (previousValue, element) => element + previousValue),
          actDiaria.fold(
              0, (previousValue, element) => element.minutos + previousValue));
    });
  });
}
