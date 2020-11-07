class PNL {
  // Periodos No Lectivos
  int tipo = 0; // 0-Lectivo, 1-Festivo, 2-Vacación

  DateTime inicio;
  DateTime fin;
  PNL({this.tipo, this.inicio, this.fin}) {
    // Si no hay final, es un día inicio==final
    fin = fin == null ? inicio.add(Duration(days: 1)) : fin;
  }
}
