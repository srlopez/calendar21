import 'package:flutter/material.dart';

class CuadroWidget extends StatelessWidget {
  const CuadroWidget({Key key, this.size}) : super(key: key);

  final int size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      //height: 200,
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.fromLTRB(5, 7, 5, 7),
      child: Column(
        children: [
          Text(
            '$size',
            overflow: TextOverflow.clip,
            //softWrap: false,
          ),
          Text('DOS'),
          Expanded(
              flex: 1,
              child: Container(
                width: 0,
                height: 0,
              )),
          Text('TRES'),
        ],
      ),
    );
  }
}
