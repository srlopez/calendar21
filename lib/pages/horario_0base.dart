import '../models/detalle_model.dart';
import 'package:flutter/material.dart';

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
                height: 40,
                child: Center(
                  child: Text('dias'),
                )),
          ),
          Container(
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top -
                kToolbarHeight -
                40 -
                40,
            child: Row(
              children: [
                Container(
                  width: 60,
                  child: Column(
                    children: [
                      Text('horas'),
                      Text('08:00'),
                    ],
                  ),
                ),
                for (var i = 0; i < 5; i++) ...[
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        for (var size in [10, 10, 10]) ...[
                          Expanded(
                            flex: size,
                            child: Container(
                              color: Colors.amber,
                              padding: EdgeInsets.all(5),
                              child: Text('Hueco dse $size'),
                            ),
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
              height: 40,
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
  }
}
