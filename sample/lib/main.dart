import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sample/theme.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FigmaTheme(
      imageLocator: (name, fit) => AssetImage(name),
      child: MaterialApp(
        title: 'Figma Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(),
    ));
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key}) : super(key: key);

  final height = 62.0;

  final insets = EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0);

  Widget _createItem({Color fill = null, BoxDecoration decoration = null}) {
    if(fill != null && decoration != null) {
      return Container(
          height: height,
          margin: insets,
          child: Container(color: fill),
          decoration: decoration,
        );
    }

    if(fill != null) {
      return Container(
          height: height,
          margin: insets,
          color: fill,
        );
    }

    return Container(
      height: height,
      margin: insets,
      decoration: decoration,
    );
  }

  Widget _createLayerBlur({Widget child, ImageFilter filter}) {
    return Container(height: height + 2 * 20.0,  child:Stack(
          overflow: Overflow.visible,
          fit: StackFit.expand,
          children: <Widget>[
            Container(child: child, padding: EdgeInsets.only(bottom: 20.0)),
            BackdropFilter(filter : filter, child: Container(
                  decoration: new BoxDecoration(
                    color: Colors.transparent
                  ))),
          ]));
  }

  @override
  Widget build(BuildContext context) {
    var theme = FigmaTheme.of(context);
    return Container(color: Color(0xFFE5E5E5), 
    child: SingleChildScrollView(child: SafeArea(
      child:  Column(
        children: <Widget>[  
        Text("Fill", style: theme.text.stylish.copyWith(color: Colors.black)),  
        _createItem(fill: theme.fills.accent),
        _createItem(decoration: BoxDecoration(gradient: theme.fills.gradient)),
        _createItem(decoration: BoxDecoration(gradient: theme.fills.radial)),
        _createItem(decoration: BoxDecoration(gradient: theme.fills.sweep)),
        Stack(children: <Widget>[
          _createItem(fill: theme.fills.mixed0),
          _createItem(decoration: BoxDecoration(gradient:theme.fills.mixed1)),
        ],),

        Text("Effects", style: theme.text.stylish),
        _createItem(fill: theme.fills.accent, decoration: BoxDecoration(boxShadow: [theme.effects.glow])),
        _createItem(fill: theme.fills.accent, decoration: BoxDecoration(boxShadow: [theme.effects.inner])),
        _createLayerBlur(
          filter: theme.effects.layerBlur, 
          child: _createItem(decoration: BoxDecoration(gradient: theme.fills.gradient))),
        
    ],))));
  }
}
