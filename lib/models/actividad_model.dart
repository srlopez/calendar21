// Actividad a dibujar
class Actividad {
  int nsegmentos; // numero de huecos que ocupa
  bool asignada; // 0 no asigando = 1 asiganada
  int minutos; // numero de minutos asignados
  String titulo;
  String subtitulo;
  String pie;
  int color;
  Actividad(this.nsegmentos,
      [this.minutos = 0,
      this.asignada = false,
      this.titulo = '',
      this.subtitulo = '',
      this.pie = '',
      this.color = 0]);

  @override
  String toString() =>
      '$nsegmentos/$minutos/${asignada ? 1 : 0}/$titulo/$subtitulo/$pie/$color';

  Actividad.fromString(String s) {
    var member = s.split('/');
    this.nsegmentos = int.parse(member[0]);
    this.minutos = int.parse(member[1]);
    this.asignada = int.parse(member[2]) == 1;
    this.titulo = member[3];
    this.subtitulo = member[4];
    this.pie = member[5];
    this.color = int.parse(member[6]);
  }
}
