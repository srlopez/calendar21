import 'package:calendar21/pages/cuadro_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/detalle_model.dart';
import '../providers/data.dart';
import 'detalle_page.dart';

class HorarioPage extends StatefulWidget {
  HorarioPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HorarioPageState createState() => _HorarioPageState();
}

class _HorarioPageState extends State<HorarioPage> {
  @override
  Widget build(BuildContext context) {
    var data = context.watch<HorarioData>();
    final barraHeight = 40.0;
    format(Duration d) {
      var h = d.toString().split(':');
      return '${h[0]}:${h[1]}';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () async {
              var detalle = Detalle();
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (_) => DetallePage(detalle: detalle)))
                  .then(
                (response) {
                  print(response?.titulo);
                },
              );
              // Detalle response = await Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => DetallePage(),
              //   ),
              // );
              // if (response != null) {
              //   /// Validas si la pantalla se cierra sin mandar datos

              // }
            },
            child: SizedBox(
                height: barraHeight,
                child: Center(
                  child: Text('dias'),
                )),
          ),
          Container(
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top -
                kToolbarHeight -
                barraHeight -
                barraHeight,
            child: Row(
              children: [
                Container(
                  width: 60,
                  child: Column(
                    children: [
                      Text('horas'),
                      Text(format(data.h0)),
                    ],
                  ),
                ),
                for (var i = 0; i < 5; i++) ...[
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        for (var size in data.minutosBloque) ...[
                          // [10, 10, 10]) ...[
                          Expanded(
                            flex: size,

                            /* child: Container(
                              width: double.infinity,
                              color: Colors.amber,
                              padding: EdgeInsets.all(5),
                              child: Text('$size'),
                            ), */

                            child: CuadroWidget(size: size),
                          ),
                          Divider(
                            height: 2,
                          )
                        ]
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 2,
                  )
                ],
              ],
            ),
          ),
          SizedBox(
              height: barraHeight,
              child: Center(
                child: Text('pie'),
              )),
        ],
      ),
      /*
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Text('UNO'),
                    Text('DOS'),
                    Expanded(
                        flex: 1,
                        child: Container(
                          width: 0,
                          height: 0,
                        )),
                    Text('TRES'),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ))
          ],
        ),
      ),
      */
    );

    // return Consumer<CalendarData>(builder: (context, data, child) {
    //   return scaffold;
    // });
  }
}
