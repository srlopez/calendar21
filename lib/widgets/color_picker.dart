import 'package:flutter/material.dart';
import 'dart:math';

const double baseHeight = 24.0;
const double baseSpacing = 15.0;
const double baseMargin = 15.0;

class ColorPicker extends StatefulWidget {
  ColorPicker(
      {this.onSelected,
      this.boxesHeight,
      this.spacing,
      this.margin,
      this.currentColor});

  final Function onSelected;
  final double boxesHeight;
  final double spacing;
  final double margin;
  final Color currentColor;

  @override
  ColorPickerState createState() => ColorPickerState();
}

class ColorPickerState extends State<ColorPicker> {
  Color _mainColorSelected;
  Color _subColorSelected;
  @override
  void initState() {
    super.initState();

    if (widget.currentColor != null) {
      _selectColor(null, widget.currentColor, false);
    }

    if (_subColorSelected == null) {
      _selectColor(null, Colors.black, false);
    }

    mainColors = [];
    subColorList.asMap().forEach(
      (i, value) {
        if (i % 8 == 4) mainColors.add(value);
      },
    );
  }

  void _selectColor(BuildContext context, Color color, bool finalColor) {
    iColor = max(subColorList.indexOf(color), 0);
    iMainColor = iColor ~/ 8;

    _mainColorSelected = subColorList[iMainColor * 8 + 4];

    setState(() {
      _subColorSelected = subColorList[iColor];
    });

    if (widget.onSelected != null) widget.onSelected(color);
  }

  @override
  Widget build(BuildContext context) {
    // He necesitado poner esta función cuando desde el dropdown se selecciona un color
    _selectColor(context, widget.currentColor, true);

    var column =
        // main colors
        Column(children: <Widget>[
      for (var line = 1; line <= 2; line++)
        SizedBox(
          height: widget.boxesHeight ?? baseHeight * 2,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _subColors(context, line),
          ),
        ),
      SizedBox(height: widget.spacing ?? baseSpacing),
      SizedBox(
        height: widget.boxesHeight ?? baseHeight,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _mainColors(context),
        ),
      ),
    ]);

    // two subcolors lines
    // [1, 2].forEach((line) {
    //   column.children.add(SizedBox(
    //     height: widget.boxesHeight ?? baseHeight * 2,
    //     child: Row(
    //       crossAxisAlignment: CrossAxisAlignment.stretch,
    //       children: _subColors(context, line),
    //     ),
    //   ));
    // });

    return Container(
      padding: EdgeInsets.all(widget.margin ?? baseMargin),
      child: column,
    );
  }

  List<Widget> _mainColors(BuildContext context) {
    var children = <Widget>[];

    for (Color color in mainColors) {
      children.add(Expanded(
          child: Stack(children: _mainColorsStackChildren(context, color))));
    }
    return children;
  }

  List<Widget> _mainColorsStackChildren(BuildContext context, Color color) {
    var children = <Widget>[];
    //print('*main: $_mainColorSelected sub: $color');

    if (_mainColorSelected == color) {
      children.add(Container(
          decoration: BoxDecoration(
              boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 2.0)])));
    }

    children.add(GestureDetector(
      child: Container(color: color),
      onTapDown: (d) {
        _selectColor(context, color, false);
      },
    ));

    if (_mainColorSelected == color) {
      children.add(Container(
          decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200], width: 3.0),
      )));
    }

    return children;
  }

  List<Widget> _subColors(BuildContext context, int line) {
    var children = <Widget>[];
    int offset = ((line - 1) * 4);
    for (int i = 0; i <= 3; i++) {
      children.add(Expanded(
          child: Stack(
              children: _subColorsStackChildren(
                  context, iMainColor * 8 + offset + i))));
    }
    return children;
  }

  List<Widget> _subColorsStackChildren(BuildContext context, int i) {
    var children = <Widget>[];
    //Color color = subColorList[_mainColorSelected][i];
    Color color = subColorList[i];

    children.add(GestureDetector(
      child: Container(
          //color: color,
          decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      )),
      onTapDown: (d) {
        _selectColor(context, color, true);
      },
    ));

    if (_subColorSelected == color) {
      Color highlightedColor = highlightColor(color);
      children.add(GestureDetector(
          child: Container(
            //height: widget.boxesHeight ?? baseHeight,
            // decoration: BoxDecoration(
            //     shape: BoxShape.circle,
            //     border: Border.all(color: highlightedColor, width: 1.5)),
            child: Center(
                child: Icon(Icons.gamepad, //Icons.check,
                    //size: (baseHeight / 2.0),
                    color: highlightedColor)),
            margin: EdgeInsets.all(2.0),
          ),
          onTapDown: (d) {
            _selectColor(context, color, true);
          }));
    }

    return children;
  }
}

Color highlightColor(Color c) {
  if (c.computeLuminance() < 0.5) return Colors.white;
  return Colors.black;
}

int iColor = 0;
int iMainColor = 0;
var mainColors = <Color>[];
/*  ,
  lightBlueAccent,
  lightGreenAccent,
*/
var subColorList = [
  ...List<Color>.generate(8, (int i) => Colors.red[(i + 1) * 100]),
  ...List<Color>.generate(8, (int i) => Colors.pink[(i + 1) * 100]),
  ...List<Color>.generate(8, (int i) => Colors.purple[(i + 1) * 100]),
  ...List<Color>.generate(8, (int i) => Colors.deepPurple[(i + 1) * 100]),
  ...List<Color>.generate(8, (int i) => Colors.indigo[(i + 1) * 100]),
  ...List<Color>.generate(8, (int i) => Colors.blue[(i + 1) * 100]),
  ...List<Color>.generate(8, (int i) => Colors.lightBlue[(i + 1) * 100]),
  ...List<Color>.generate(8, (int i) => Colors.cyan[(i + 1) * 100]),
  ...List<Color>.generate(8, (int i) => Colors.teal[(i + 1) * 100]),
  ...List<Color>.generate(8, (int i) => Colors.green[(i + 1) * 100]),
  ...List<Color>.generate(8, (int i) => Colors.lightGreen[(i + 1) * 100]),
  ...List<Color>.generate(8, (int i) => Colors.lime[(i + 1) * 100]),
  ...List<Color>.generate(8, (int i) => Colors.yellow[(i + 1) * 100]),
  ...List<Color>.generate(8, (int i) => Colors.amber[(i + 1) * 100]),
  ...List<Color>.generate(8, (int i) => Colors.orange[(i + 1) * 100]),
  ...List<Color>.generate(8, (int i) => Colors.deepOrange[(i + 1) * 100]),
  ...List<Color>.generate(8, (int i) => Colors.brown[(i + 1) * 100]),
  ...List<Color>.generate(8, (int i) => Colors.grey[(i + 1) * 100]),
  ...List<Color>.generate(8, (int i) => Colors.blueGrey[(i + 1) * 100]),

  //...List<Color>.generate(8, (int i) => Colors.redAccent[(i + 1) * 100]),
  //...List<Color>.generate(8, (int i) => Colors.purpleAccent[(i + 1) * 100]),
  //...List<Color>.generate(8, (int i) => Colors.deepPurpleAccent[(i + 1) * 100]),
  //...List<Color>.generate(8, (int i) => Colors.cyanAccent[(i + 1) * 100]),
  //...List<Color>.generate(8, (int i) => Colors.indigoAccent[(i + 1) * 100]),
  //...List<Color>.generate(8, (int i) => Colors.yellowAccent[(i + 1) * 100]),
  //...List<Color>.generate(8, (int i) => Colors.limeAccent[(i + 1) * 100]),
  //...List<Color>.generate(8, (int i) => Colors.greenAccent[(i + 1) * 100]),
  //...List<Color>.generate(8, (int i) => Colors.tealAccent[(i + 1) * 100]),
  //...List<Color>.generate(8, (int i) => Colors.amberAccent[(i + 1) * 100]),
  //...List<Color>.generate(8, (int i) => Colors.pinkAccent[(i + 1) * 100]),
  //...List<Color>.generate(8, (int i) => Colors.deepOrangeAccent[(i + 1) * 100]),
  //...List<Color>.generate(8, (int i) => Colors.orangeAccent[(i + 1) * 100]),
];
