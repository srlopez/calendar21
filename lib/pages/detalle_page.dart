import 'package:flutter/material.dart';
import '../models/detalle_model.dart';
import '../models/actividad_model.dart';

class DetallePage extends StatefulWidget {
  const DetallePage({Key key, this.detalle}) : super(key: key);
  final Detalle detalle;

  @override
  _DetallePageState createState() => _DetallePageState();
}

class _DetallePageState extends State<DetallePage> {
  List<List<Actividad>> horario;
  int d;
  int a;
  Actividad act;

  TextEditingController _nHuecosCtrl;
  TextEditingController _tituloCtrl;
  TextEditingController _subtituloCtrl;
  TextEditingController _pieCtrl;
  TextEditingController _colorCtrl;

  void initState() {
    super.initState();
    horario = widget.detalle.data.horario;
    d = widget.detalle.iDia;
    a = widget.detalle.iActividad;
    act = Actividad.fromString(horario[d][a].toString());

    _nHuecosCtrl = TextEditingController(text: act.nhuecos.toString());
    _tituloCtrl = TextEditingController(text: act.titulo);
    _subtituloCtrl = TextEditingController(text: act.subtitulo);
    _pieCtrl = TextEditingController(text: act.pie);
    _colorCtrl = TextEditingController(text: act.color.toString());
  }

  void dispose() {
    _nHuecosCtrl.dispose();
    _tituloCtrl.dispose();
    _subtituloCtrl.dispose();
    _pieCtrl.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    var _value = 3.0;
    return Scaffold(
      appBar: AppBar(
        title: Text('prueba'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  ' Dia:${widget.detalle.iDia} Actividad: ${widget.detalle.iActividad}'),
              Slider(
                  value: _value.toDouble(),
                  min: 1.0,
                  max: 10.0,
                  divisions: 10,
                  activeColor: Colors.red,
                  inactiveColor: Colors.black,
                  label: 'Set a value',
                  onChanged: (double newValue) {
                    setState(() {
                      _value = newValue;
                    });
                  },
                  semanticFormatterCallback: (double newValue) {
                    return '${newValue.round()} dollars';
                  }),
              TextFormField(controller: _nHuecosCtrl),
              TextFormField(controller: _tituloCtrl),
              TextFormField(controller: _subtituloCtrl),
              TextFormField(controller: _pieCtrl),
              TextFormField(controller: _colorCtrl),
              //TextField(controller: _controller),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  RaisedButton(
                    child: Text('OK'),
                    onPressed: () {
                      act.asignada = true;
                      act.nhuecos = int.parse(_nHuecosCtrl.text);
                      act.titulo = _tituloCtrl.text;
                      act.subtitulo = _subtituloCtrl.text;
                      act.pie = _pieCtrl.text;
                      act.color = int.parse(_colorCtrl.text);

                      Navigator.of(context).pop<Actividad>(act);
                    },
                  ),
                  RaisedButton(
                    child: Text('Quitar'),
                    onPressed: () {
                      act.asignada = false;
                      act.nhuecos = int.parse(_nHuecosCtrl.text);
                      act.titulo = _tituloCtrl.text;
                      act.subtitulo = _subtituloCtrl.text;
                      act.pie = _pieCtrl.text;
                      act.color = int.parse(_colorCtrl.text);

                      Navigator.of(context).pop<Actividad>(act);
                    },
                  ),
                  RaisedButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
