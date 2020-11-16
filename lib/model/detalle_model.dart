import 'package:calendar21/provider/app_provider.dart';
import 'package:flutter/material.dart';

class Detalle {
  Data data;
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
