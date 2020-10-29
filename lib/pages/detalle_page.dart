import 'package:flutter/material.dart';
import '../providers/data.dart';
import '../models/detalle_model.dart';

class DetallePage extends StatefulWidget {
  const DetallePage({Key key, this.detalle}) : super(key: key);
  final Detalle detalle;

  @override
  _DetallePageState createState() => _DetallePageState();
}

class _DetallePageState extends State<DetallePage> {
  TextEditingController _controller;

  void initState() {
    super.initState();
    _controller = TextEditingController(text: 'sdfs');
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    var data = widget.detalle.data;
    return Scaffold(
      appBar: AppBar(
        title: Text('prueba'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('${widget.detalle.iDia}'),
            Text('${widget.detalle.iActividad}'),
            TextField(
              controller: _controller,
            ),
            RaisedButton(
              child: Text('dale'),
              onPressed: () {
                var detalle = "sdfvsd";
                //Detalle(titulo: _controller.text);
                Navigator.of(context).pop<Detalle>(detalle);
              },
            )
          ],
        ),
      ),
    );
  }
}
