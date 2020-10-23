import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/horario_page.dart';
import 'package:calendar21/providers/data.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    MaterialApp app = MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HorarioPage(title: 'Flutter Demo Home Page'),
    );

    // Lo recubrimos con un Proveedor de Notificaciones
    return ChangeNotifierProvider<HorarioData>(
      create: (context) => HorarioData(),
      child: app,
    );
  }
}
