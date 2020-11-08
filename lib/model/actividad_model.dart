// Actividad del horario
class Actividad {
  final separator = '¬';

  int segmentos; // numero de huecos que ocupa
  bool asignada; // 0 no asigando = 1 asiganada
  int minutos; // numero de minutos asignados
  String titulo;
  String subtitulo;
  String pie;
  int color;

  Actividad(
      [this.segmentos = 1,
      this.minutos = 0,
      this.asignada = false,
      this.titulo = '',
      this.subtitulo = '',
      this.pie = '',
      this.color = 0]);

  @override
  String toString() =>
      '$segmentos$separator$minutos$separator${asignada ? 1 : 0}$separator$titulo$separator$subtitulo$separator$pie$separator$color';

  Actividad.fromString(String s) {
    var member = s.split(separator);
    this.segmentos = int.parse(member[0]);
    this.minutos = int.parse(member[1]);
    this.asignada = int.parse(member[2]) == 1;
    this.titulo = member[3];
    this.subtitulo = member[4];
    this.pie = member[5];
    this.color = int.parse(member[6]);
  }
}
