import 'package:calendar21t/model/linea_de_tiempo_model.dart';
import 'package:calendar21t/services/storage_horario.dart';

import 'actividad_model.dart';

class Horario {
  // Repositorio File
  HorarioStorage storage;

  // Las segmentación de horas
  LineaDeTiempo ldt;

  // ===================   CONSTRUCTOR
  Horario({var this.ldt}) {
    //
    ldt = ldt ?? LineaDeTiempo();
    // Almacenamiento
    storage = HorarioStorage();
    //Horario
    horario = horarioVacio();
  }
  // ====================  FIN CONSTRUCTOR

  // ================ HORARIO
  // Almacena los actividades asignados en el horario de Lunes a Viernes
  var horario = List<List<Actividad>>(5);

  List<List<Actividad>> horarioVacio() {
    var h = List<List<Actividad>>(5);
    for (var dia = 0; dia < horario.length; dia++) h[dia] = diaVacio();
    return h;
  }

  // Pongo en un día tantos actividads como segmentos tenemos
  List<Actividad> diaVacio() {
    var actividades = <Actividad>[];
    ldt.segmentos
        .forEach((minutos) => actividades.add(Actividad(1, minutos, false)));
    return actividades;
  }

  // Reasignamos una Actividad en un segmento horario
  List<Actividad> establecerActividad(
      List<Actividad> dia, int iActividad, Actividad act) {
    assert(dia[iActividad].segmentos == 1); //Se reescribe una de 1 segmento
    assert(dia[iActividad].asignada == false); // Y que está sin asignar
    //assert((iActividad + act.segmentos) <=        dia.length); // la longitud asignado <= total actividads del día

    if ((iActividad + act.segmentos) > dia.length)
      act.segmentos = dia.length - iActividad; //El máximo

    var segmentosAAsignar = 0;
    var minutosOcupados = 0;

    // Calculo de la cantidad de segmentos basicos (del dia) que usaremos
    for (var i = iActividad; i < iActividad + act.segmentos; i++) {
      segmentosAAsignar += dia[i].segmentos;
      minutosOcupados += dia[i].minutos;
    }

    // Asignamos la Actividad en Nueva lista de Actividades
    var actList = <Actividad>[];
    for (var i = 0; i < dia.length; i++) {
      Actividad actividad;

      if (i == iActividad) {
        actividad = Actividad.fromString(act.toString());
        actividad.segmentos = segmentosAAsignar;
        actividad.minutos = minutosOcupados;
        i += act.segmentos - 1; //salta los actividads que este agrupa
      } else
        actividad = dia[i];

      actList.add(actividad);
    }
    return actList;
  }

  // Quitamos una actividad
  List<Actividad> quitarActividad(List<Actividad> dia, int iActividad) {
    assert(iActividad < dia.length);

    // Evitamos quitar una actividad no asignada
    if (dia[iActividad].asignada == false) return dia;
    assert(dia[iActividad].asignada == true);

    var actList = <Actividad>[];

    for (var i = 0, iSegmento = 0; i < dia.length; i++) {
      if (i == iActividad) {
        for (var k = 0; k < dia[i].segmentos; k++)
          actList.add(Actividad(1, ldt.segmentos[iSegmento++]));
      } else {
        actList.add(dia[i]);
        iSegmento += dia[i].segmentos;
      }
    }
    return actList;
  }

  // Un nuevo segmento horario -> recalculamos todo el dia
  List<Actividad> reestablecerActividades(
      List<Actividad> dia, List<int> segmentos) {
    var actList = <Actividad>[];

    for (var i = 0, a = 0; i < segmentos.length;) {
      if ((dia != null) && (a < dia.length)) {
        var segmentosAAsignar = dia[a].segmentos;
        var minutosOcupados = 0;

        // la ultima actividad sobrepasa los segmentos
        if (i + dia[a].segmentos > segmentos.length)
          segmentosAAsignar = segmentos.length - i;

        // Calculo de la cantidad de segmentos basicos (del dia) que usaremos
        for (var k = i; k < i + segmentosAAsignar; k++)
          minutosOcupados += segmentos[k];

        Actividad actividad = Actividad.fromString(dia[a].toString());
        actividad.segmentos = segmentosAAsignar;
        actividad.minutos = minutosOcupados;
        actList.add(actividad);
        i += segmentosAAsignar;
        a++;
      } else {
        actList.add(Actividad(1, segmentos[i++]));
      }
    }
    return actList;
  }

  // Calcula los minutos de un grupo de segmentos
  // desde el iSegmento y de una longitud nsegmentos
  // int zznMinutos(iSegmento, nSegmentos) {
  //   var minutos = 0;
  //   for (var i = iSegmento; i < iSegmento + nSegmentos; i++)
  //     minutos += ldt.segmentos[i];
  //   return minutos;
  // }

  Duration horaDeLaActividad(int iDia, int iAct) {
    Duration h = ldt.h0;
    for (var i = 0; i < iAct; i++)
      h += Duration(minutes: horario[iDia][i].minutos);
    return h;
  }
}
