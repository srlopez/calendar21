// Actividad del horario
class LineaDeTiempo {
  // hora inicial
  Duration h0;
  // Tamaño de 'segmentos' en minutos
  var segmentos = <int>[]; // [55,55,55...55]

  LineaDeTiempo() {
    // Un setup desde las 8:00 a 15:00
    h0 = Duration(hours: 8, minutes: 0);
    segmentos = [420];
  }

  Duration horaInicial() => h0;

  Duration horaFinal() {
    Duration h = h0;
    for (var i = 0; i < segmentos.length; i++)
      h += Duration(minutes: segmentos[i]);
    return h;
  }

  String horaFormat(Duration d) {
    var h = d.toString().split(':');
    return '${h[0]}:${h[1]}';
  }

  List<String> listaHoras() {
    var l = <String>[];
    var h = h0;
    segmentos.asMap().forEach((idx, minutos) {
      l.add(horaFormat(h));
      h += Duration(minutes: minutos);
    });
    l.add(horaFormat(h));
    return l;
  }
}
