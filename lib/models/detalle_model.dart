import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Detalle {
  String titulo;
  String subtitulo;
  String pie;
  Color color;

  Detalle(
      {this.titulo = 'TITULO',
      this.subtitulo = 'Sutitulo',
      this.pie = 'Final',
      this.color = Colors.amber});
}
