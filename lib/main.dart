import 'package:calendar21/pages/horario_page.dart';
import 'package:calendar21/pages/splash_screen.dart';
import 'package:calendar21/provider/app_provider.dart';
import 'package:calendar21/model/constantes_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  //WidgetsFlutterBinding.ensureInitialized();

  //var data = Data();
  //await data.init(); //invocamos la creacion sincrona
  // data.init(notify: true).then((data) {
  //   // asincrona
  //   print('Done');
  // });
  //runApp(MyApp(data: data));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  //MyApp({Key key, this.data}) : super(key: key);
  MyApp({Key key}) : super(key: key);

  //final Data data;
  final Future _initFuture = Data.initialize();
  //final Future _initFuture = Init.initialize();

  @override
  Widget build(BuildContext context) {
    MaterialApp app = MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //home: MyHomePage(title: 'Flutter Demo Home Page'),
      home: FutureBuilder(
        future: _initFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return MisConstantes(
                child: HorarioPage(title: 'Flutter Demo Home Page'));

            //return HorarioPage(title: 'Flutter Demo Home Page');
            //return MyHomePage(title: 'Flutter Demo Home Page');
          } else {
            return SplashScreen();
          }
        },
      ),
    );

    // Lo recubrimos con un Proveedor de Notificaciones
    return ChangeNotifierProvider<Data>(
      create: (context) => Data(),
      child: app,
    );
    // return ChangeNotifierProvider<Data>.value(
    //   value: data, //Si lo hemoss creado antes
    //   child: app,
    // );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    var data = Provider.of<Data>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '${data.counter}',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
//        onPressed: _incrementCounter,
        onPressed: (() => data.incrementDelta(1)),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
