import 'dart:ui';
import 'package:flutter/widgets.dart';

typedef ImageProvider ImageLocator(String reference, BoxFit fit);

class FigmaTheme extends InheritedWidget {
  FigmaTheme(
      {ImageLocator this.imageLocator,
      Key key,
      Widget child,
      FigmaThemeData data,
      double sizeFactor: 1.0})
      : this.data =
            data ?? FigmaThemeData(imageLocator, sizeFactor: sizeFactor),
        super(key: key, child: child);

  final FigmaThemeData data;

  final ImageLocator imageLocator;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
  static FigmaThemeData of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(FigmaTheme) as FigmaTheme).data;
}

class FigmaThemeData {
  FigmaThemeData(ImageLocator imageLocator,
      {double sizeFactor: 1.0,
      FigmaFills fills,
      FigmaEffects effects,
      FigmaText text})
      : this.fills = fills ?? FigmaFills(imageLocator),
        this.effects = effects ?? FigmaEffects(),
        this.text = text ?? FigmaText(sizeFactor: sizeFactor);

  final FigmaFills fills;

  final FigmaEffects effects;

  final FigmaText text;
}

class FigmaFills {
  FigmaFills(ImageLocator imageLocator,
      {Color accent,
      Color mixed0,
      LinearGradient mixed1,
      LinearGradient gradient,
      RadialGradient radial,
      SweepGradient sweep,
      ImageProvider image})
      : this.accent = accent ?? Color(0xff519ce2),
        this.mixed0 = mixed0 ?? Color(0xff519ce2),
        this.mixed1 = mixed1 ??
            LinearGradient(
                begin: Alignment(0.00000, -1.00000),
                end: Alignment(0.00000, 1.00000),
                colors: [Color(0x33ffffff), Color(0x00ffffff)],
                stops: [0.00000, 1.00000]),
        this.gradient = gradient ??
            LinearGradient(
                begin: Alignment(-1.00000, -1.22642),
                end: Alignment(1.00000, 1.00000),
                colors: [Color(0xff2fa774), Color(0xff519ce2)],
                stops: [0.00000, 1.00000]),
        this.radial = radial ??
            RadialGradient(
                center: Alignment(-0.01887, -0.90566),
                radius: 1.01887,
                colors: [Color(0xff2fa774), Color(0xff519ce2)],
                stops: [0.00000, 1.00000]),
        this.sweep = sweep ??
            SweepGradient(
                center: Alignment(-0.45113, 0.01887),
                startAngle: -1.00354,
                endAngle: 5.27965,
                colors: [Color(0xff2fa774), Color(0xff519ce2)],
                stops: [0.00000, 1.00000]),
        this.image = image ??
            imageLocator(
                "ea9571c06b4788e4bca16f57f6225ffa336c8db3", BoxFit.cover);

  final Color accent;

  final Color mixed0;

  final LinearGradient mixed1;

  final LinearGradient gradient;

  final RadialGradient radial;

  final SweepGradient sweep;

  final ImageProvider image;
}

class FigmaEffects {
  FigmaEffects(
      {BoxShadow glow,
      BoxShadow inner,
      ImageFilter layerBlur,
      ImageFilter backgroundBlur})
      : this.glow = glow ??
            BoxShadow(
                color: Color(0xb236b9e3),
                offset: Offset(1.00000, 1.00000),
                blurRadius: 10.00000),
        this.inner = inner ??
            BoxShadow(
                color: Color(0x40000000),
                offset: Offset(0.00000, 4.00000),
                blurRadius: 4.00000),
        this.layerBlur =
            layerBlur ?? ImageFilter.blur(sigmaX: 4.00000, sigmaY: 4.00000),
        this.backgroundBlur = backgroundBlur ??
            ImageFilter.blur(sigmaX: 4.00000, sigmaY: 4.00000);

  final BoxShadow glow;

  final BoxShadow inner;

  final ImageFilter layerBlur;

  final ImageFilter backgroundBlur;
}

class FigmaText {
  FigmaText({double sizeFactor: 1.0, TextStyle stylish})
      : this.stylish = stylish ??
            TextStyle(
                fontWeight: FontWeight.w100,
                fontSize: sizeFactor * 25.0,
                letterSpacing: 25.0 * 0.1,
                fontFamily: 'Roboto');

  final TextStyle stylish;
}
