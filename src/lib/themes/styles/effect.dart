import 'package:figma_styles_exporter/figma/file.dart';
import 'package:figma_styles_exporter/themes/styles/base.dart';

abstract class Effect {
  Effect();
  factory Effect.fromFigma(dynamic figma) {
    final type = figma["type"];
    switch(type)
    {
      case 'DROP_SHADOW':
          return DropShadow.fromFigma(figma);
      case 'INNER_SHADOW':
          return InnerShadow.fromFigma(figma);
      case 'LAYER_BLUR':
          return LayerBlur.fromFigma(figma);
      case 'BACKGROUND_BLUR':
          return BackgroundBlur.fromFigma(figma);
    }

    throw UnsupportedError("Unsupported effect $type");
  }
}

abstract class Shadow extends Effect {
  final Color color;
  final BlendMode blendMode;
  final Vector offset;
  final double radius;
  Shadow(this.color, this.blendMode, this.offset, this.radius);
}

class DropShadow extends Shadow {
  DropShadow(
    Color color, 
    BlendMode blendMode, 
    Vector offset, 
    double radius) : 
      super(color,blendMode,offset,radius);

  factory DropShadow.fromFigma(dynamic figma) {
    var color = Color.fromFigma(figma["color"], figma["opacity"]);
    var blendMode = BlendMode.Normal;
    var offset = Vector.fromFigma(figma["offset"]);
    var radius = figma["radius"].toDouble();
    return DropShadow(color, blendMode, offset, radius);
  }
}

class InnerShadow extends Shadow {
  InnerShadow(
    Color color, 
    BlendMode blendMode, 
    Vector offset, 
    double radius) : 
      super(color,blendMode,offset,radius);

  factory InnerShadow.fromFigma(dynamic figma) {
    var color = Color.fromFigma(figma["color"], figma["opacity"]);
    var blendMode = BlendMode.Normal;
    var offset = Vector.fromFigma(figma["offset"]);
    var radius = figma["radius"].toDouble();
    return InnerShadow(color, blendMode, offset, radius);
  }
}

abstract class Blur  extends Effect {
  final double radius;
  Blur(this.radius);
}

class LayerBlur extends Blur {
  LayerBlur(double radius) : super(radius);

  factory LayerBlur.fromFigma(dynamic figma) {
    var radius = figma["radius"].toDouble();
    return LayerBlur(radius);
  }
}

class BackgroundBlur extends Blur {
  BackgroundBlur(double radius) : super(radius);

  factory BackgroundBlur.fromFigma(dynamic figma) {
    var radius = figma["radius"].toDouble();
    return BackgroundBlur(radius);
  }
}

class EffectStyle extends Style {
  final List<Effect> effects;

  EffectStyle(
    String name,
    this.effects,
  ) : super(name);

  factory EffectStyle.fromFigma(FigmaStyle figma ) {
    List<Effect> effects = (figma.node["effects"] as Iterable).map((f) => Effect.fromFigma(f)).toList();
    return EffectStyle(figma.name, effects);
  } 
} 