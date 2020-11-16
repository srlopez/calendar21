import 'package:calendar21/model/actividad_model.dart';
import 'package:calendar21/model/detalle_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tuple/tuple.dart';

import '../widgets/color_picker.dart';

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

  // Patrones de valores: Color+Titulo+Subtitulo+Pie
  var patrones = <Tuple4<int, String, String, String>>[];

  //TextEditingController _nHuecosCtrl;
  TextEditingController _tituloCtrl;
  TextEditingController _subtituloCtrl;
  TextEditingController _pieCtrl;

  int _nHuecos = 0;
  int _vColor = 0;

  void initState() {
    super.initState();
    horario = widget.detalle.data.horario;
    d = widget.detalle.iDia;
    a = widget.detalle.iActividad;
    act = Actividad.fromString(horario[d][a].toString());

    // Asignamos un color inicial si es nueva
    if (!act.asignada) act.color = subColorList[subColorList.length - 1].value;
    _vColor = act.color;
    _nHuecos = act.segmentos;

    // Lista de horas

    // Lista de patrones tuplas =======
    var spatrones = <Tuple4<int, String, String, String>>{};

    patrones = [];
    for (var i = 0; i < horario.length; i++)
      for (var j = 0; j < horario[i].length; j++) {
        if ((horario[i][j].asignada) & (horario[i][j].titulo != ''))
          spatrones.add(Tuple4(
            horario[i][j].color,
            horario[i][j].titulo,
            horario[i][j].subtitulo,
            horario[i][j].pie,
          ));
      }
    //patrones = [ ...{...patrones} ];
    //spatrones = patrones.toSet();
    patrones = spatrones.toList();
    // =========================

    //_nHuecosCtrl = TextEditingController(text: act.segmentos.toString());
    _tituloCtrl = TextEditingController(text: act.titulo);
    _subtituloCtrl = TextEditingController(text: act.subtitulo);
    _pieCtrl = TextEditingController(text: act.pie);
  }

  void dispose() {
    //_nHuecosCtrl.dispose();
    _tituloCtrl.dispose();
    _subtituloCtrl.dispose();
    _pieCtrl.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(act.asignada ? 'Modificar Actividad' : 'Indicar Actividad'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  ' ${[
                    "Lunes",
                    "Martes",
                    "Miercoles",
                    "Jueves",
                    "Viernes"
                  ][widget.detalle.iDia]}  ${widget.detalle.hora}',
                  style: new TextStyle(
                      fontSize: 16.0,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold),
                ),

                // DropDwon Buttom para los huecos y colores
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('N.Huecos'),
                      DropdownButton(
                        itemHeight: 50,
                        value: _nHuecos,
                        items: <DropdownMenuItem>[
                          for (var i = 0; i < 3; i++)
                            DropdownMenuItem(
                                child: Container(
                                  width: 60,
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    '${i + 1}',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                value: i + 1)
                        ],
                        onChanged: (value) {
                          setState(() {
                            _nHuecos = value;
                          });
                        },
                      ),
                      Text('Color'),
                      DropdownButton(
                        itemHeight: 50,
                        //value: _vColor, //Si es nueva no tiene asignado
                        items: <DropdownMenuItem>[
                          //DropdownMenuItem(child: Text('n/a'), value: 0),
                          for (var i = 0; i < patrones.length; i++)
                            DropdownMenuItem(
                              child: Container(
                                //height: 40,
                                width: 100,
                                padding: EdgeInsets.all(8),
                                color: Color(patrones[i].item1),
                                child: Text(
                                  patrones[i].item2,
                                  style: TextStyle(
                                    color: highlightColor(
                                        Color(patrones[i].item1)),
                                  ),
                                ),
                              ),
                              value: patrones[i].item1,
                            )
                        ],
                        onChanged: (value) {
                          setState(() {
                            _vColor = value;
                            act.color = value;
                            for (var i = 0; i < patrones.length; i++)
                              if (patrones[i].item1 == value) {
                                _tituloCtrl.text = patrones[i].item2;
                                _subtituloCtrl.text = patrones[i].item3;
                                _pieCtrl.text = patrones[i].item4;
                              }

                            //int.parse(patronesl[value].split('¬')[1]);
                          });
                        },
                      ),
                    ]),

                // TextFormField(
                //   controller: _nHuecosCtrl,
                //   autofocus: true,
                //   textInputAction: TextInputAction.next,
                //   textCapitalization: TextCapitalization.words,
                //   decoration: InputDecoration(
                //     labelText: 'Número de huecos',
                //     icon: Icon(Icons.donut_small_rounded), //donut_large),
                //   ),
                //   inputFormatters: <TextInputFormatter>[
                //     FilteringTextInputFormatter.digitsOnly
                //   ],
                //   onChanged: (value) {
                //     //print('onChanged $value');
                //   },
                //   onSaved: (value) {
                //     //print('onSaved $value');
                //   },
                //   validator: (value) {
                //     int val = int.parse('0' + value);
                //     //if (value.isEmpty) return 'Valor entre 1 y 2';
                //     if ((val < 1) | (val > 4)) return 'Valor entre 1 y 4';
                //     return null;
                //   },
                // ),
                TextFormField(
                  controller: _tituloCtrl,
                  autofocus: true,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: 'Módulo',
                    icon: Icon(Icons.edit), //book),
                  ),
                ),
                TextFormField(
                  controller: _subtituloCtrl,
                  autofocus: true,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: 'Grupo',
                    icon: Icon(Icons.group),
                  ),
                ),
                TextFormField(
                  controller: _pieCtrl,
                  autofocus: true,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: 'Ubicación',
                    icon: Icon(Icons.room),
                  ),
                ),
                Text(''),
                Divider(),
                Text('Selector de Color'),
                ColorPicker(
                  currentColor: Color(_vColor), //Color(act.color),
                  onSelected: (color) {
                    _vColor = color.value;
                    act.color = color.value;
                  },
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    RaisedButton(
                      child: Text('OK'),
                      onPressed: () {
                        act.asignada = true;
                        //act.segmentos = int.parse(_nHuecosCtrl.text);
                        act.segmentos = _nHuecos;

                        act.titulo = _tituloCtrl.text;
                        act.subtitulo = _subtituloCtrl.text;
                        act.pie = _pieCtrl.text;

                        Navigator.of(context).pop<Actividad>(act);
                      },
                    ),
                    act.asignada //Si la actividad no existe no la quitamos
                        ? RaisedButton(
                            child: Text('Quitar'),
                            onPressed: () {
                              act = Actividad.fromString(
                                  horario[d][a].toString());
                              act.asignada = false;

                              Navigator.of(context).pop<Actividad>(act);
                            },
                          )
                        : Container(),
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
      ),
    );
  }
}
