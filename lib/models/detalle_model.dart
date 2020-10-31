import 'package:calendar21/providers/data.dart';
import 'package:flutter/material.dart';

class Detalle {
  HorarioData data;
  int iDia;
  int iActividad;
  String hora;

  Detalle({
    @required this.data,
    @required this.iDia,
    @required this.iActividad,
    @required this.hora,
  });
}
