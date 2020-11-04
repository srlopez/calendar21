import 'package:calendar21/models/constantes_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/horario_page.dart';
import 'providers/data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var data = HorarioData();
  //await data.init(); //invocamos la creacion sincrona
  data.init(notify: true).then((data) {
    // asincrona
    print('Done');
  });
  runApp(MyApp(data: data));
}

class MyApp extends StatelessWidget {
  MyApp({Key key, this.data}) : super(key: key);

  final HorarioData data;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    MaterialApp app = MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MisConstantes(child: HorarioPage(title: 'Flutter Demo Home Page')),
    );

    // Lo recubrimos con un Proveedor de Notificaciones
    // return ChangeNotifierProvider<HorarioData>(
    //   create: (context) => HorarioData(),
    //   child: app,
    // );
    return ChangeNotifierProvider<HorarioData>.value(
      value: data,
      child: app,
    );
  }
}
