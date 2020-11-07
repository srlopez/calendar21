import 'package:calendar21t/model/actividad_model.dart';
import 'package:calendar21t/model/diario_model.dart';
import 'package:calendar21t/model/linea_de_tiempo_model.dart';
import 'package:calendar21t/model/horario_model.dart';
import 'package:calendar21t/model/no_lectivos_model.dart';
import 'package:calendar21t/services/api_spreadsheets.dart';
import 'package:flutter/foundation.dart';

class Data extends Horario with ChangeNotifier {
  ApiSpreadsheetsProvider apiProvider;
  LineaDeTiempo ldt;
  List<PNL> pnls;
  List<ApunteDiario> apuntes;
  DateTime miLunes; //Lunes mostrado en pantalla
  int miSemana = 54; // Semana inicial: Inidice de Page view 0..90 (-45..0..45)
  bool gotoHome = false;

  // Singleton
  static Data _instance;
  Data._internal() : super() {
    _instance = this;
  }
  factory Data() => _instance ?? Data._internal();
  // Fin Singleton

  static Future initialize({bool forceApi = false}) async {
    // Obtenemos la instancia y/o la creamos
    var me = Data();

    // Establecemos la API
    me.apiProvider = ApiSpreadsheetsProvider();

    // Leemos la Linea de Tiempo y luego leemos el horario
    me.apiProvider.fetchLineaDeTiempo().then((ldt) async {
      print('done: fetch ldt');

      me.ldt = ldt;
      me.horario = await me.storage.leerHorario();
      // recalculamos el horario segun los segmentos recuperados
      for (var d = 0; d < me.horario.length; d++) {
        me.horario[d] =
            me.reestablecerActividades(me.horario[d], me.ldt.segmentos);
      }
      print('done: acabado establecer horario');
      me._counter = 1000;
    });

    // Periodos no lectivos
    me.pnls = await me.apiProvider.fetchPNLs();
    print('done: fetch pnls');

    // Lista de apuntes diarios
    me.apuntes = await me.apiProvider.fetchApuntesDiarios();
    print('done: fetch apuntes');

    // Ejemplos más ordenados
    // await _registerServices();
    // await _loadSettings();
    print('done: fin inicialización');
  }

  // Ejemplos más ordenados (2)

  // static _registerServices() async {
  // print("starting registering services");
  // await Future.delayed(Duration(seconds: 1));
  // print("finished registering services");
  // }

  // static _loadSettings() async {
  // print("starting loading settings");
  // await Future.delayed(Duration(seconds: 1));
  // print("finished loading settings");
  // }

  void reInitialize() async {
    await initialize(forceApi: true);
    notifyListeners();
  }

  void quitarActividadDelHorario(int iDia, int iAct, bool save) {
    horario[iDia] = quitarActividad(horario[iDia], iAct);
    if (save) {
      storage.escribirHorario(horario);
      notifyListeners();
    }
  }

  void nuevaActividadEnDelDia(int iDia, int iAct, Actividad act) {
    horario[iDia] = super.establecerActividad(horario[iDia], iAct, act);
    storage.escribirHorario(horario);
    notifyListeners();
  }

  void establecerSemanActual() {
    gotoHome = true;
    notifyListeners();
  }

  void establecerSemana(DateTime lunes, int semana) {
    gotoHome = false;
    miLunes = lunes;
    miSemana = semana;
    //print('semana #$miSemana    lunes: $miLunes');
    Future.delayed(Duration.zero, () async {
      // Si no retardo un poco, me da un error
      // https://stackoverflow.com/questions/47592301/setstate-or-markneedsbuild-called-during-build
      notifyListeners();
    });
  }

  // Jeje Primero pruevo con el contador
  int _counter = 0;
  int get counter => _counter;
  void incrementDelta(int delta) {
    _counter += delta;
    notifyListeners();
  }
}
