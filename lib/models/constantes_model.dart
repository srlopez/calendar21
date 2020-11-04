import 'package:flutter/material.dart';

//https://stackoverflow.com/questions/54069239/whats-the-best-practice-to-keep-all-the-constants-in-flutter
class MisConstantes extends InheritedWidget {
  static MisConstantes of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<MisConstantes>();

  const MisConstantes({Widget child, Key key}) : super(key: key, child: child);

  // Horario
  final separacionHorarioSuperior = 20.0;
  final separacionHorarioSInferior = 20.0;
  final ajusteText = 5.0; // Lo necesito pata afinar
  // Columna de horas
  final anchoColumnaHoras = 60.0;
  // Presentación de la semana
  final alturaSemanario = 55.0;

  // Colores
  // final colorDia = Colors.grey[300];
  // final colorBack = Theme.of(context).primaryColor;
  final textoSemanario = Colors.blueGrey[900]; //.of(context).primaryColor;
  final fondoSemanario = Colors.grey[100];

  final fondoHorario = Colors.grey[100];
  final textoHorario = Colors.blueGrey[900]; //.of(context).primaryColor;

  final fondoDiaSemana = Colors.blueGrey[50];
  final textDiaNormal = Colors.blueGrey[700];
  final textDiaFestivo = Colors.red[600];
  final textDiaVacacion = Colors.red[900];

  final fondoNoActividad = Colors.blueGrey[50];
  final bordeNoActividad = Colors.grey[300];

  // Otras
  final nombreDias = const ["Lun", "Mar", "Mie", "Jue", "Vie"];
  final nombreMes = const [
    "Enero",
    "Febrero",
    "Marzo",
    "Abril",
    "Mayo",
    "Junio",
    "Julio",
    "Agosto",
    "Septiembre",
    "Octubre",
    "Noviembre",
    "Diciembre"
  ];

  @override
  bool updateShouldNotify(MisConstantes oldWidget) => false;
}
