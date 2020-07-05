import 'package:flutter/material.dart';

Future<void> alertCard(String errMessage, BuildContext ctx,
    [String popTill]) async {
  await showDialog(
    context: ctx,
    builder: (ctx) => AlertDialog(
      title: Icon(Icons.error, size: 60),
      content: Text(
        errMessage,
        style: TextStyle(fontSize: 25),
        textAlign: TextAlign.center,
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () => popTill == null
              ? Navigator.of(ctx).pop()
              : Navigator.of(ctx).popUntil(ModalRoute.withName(popTill)),
          child: Text('Okay'),
        )
      ],
    ),
  );
}
