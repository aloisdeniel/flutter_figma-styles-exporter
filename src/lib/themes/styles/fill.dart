import 'package:figma_styles_exporter/figma/file.dart';
import 'package:figma_styles_exporter/themes/styles/base.dart';

abstract class Paint {
  final double opacity;
  Paint(this.opacity);

  factory Paint.fromFigma(dynamic figma) {
    final type = figma["type"];
    switch(type)
    {
      case 'SOLID':
          return SolidColorPaint.fromFigma(figma);
      case 'GRADIENT_LINEAR':
          return LinearGradientPaint.fromFigma(figma);
      case 'GRADIENT_RADIAL':
          return RadialGradientPaint.fromFigma(figma);
      case 'GRADIENT_ANGULAR':
          return AngularGradientPaint.fromFigma(figma);
      case 'IMAGE':
          return ImagePaint.fromFigma(figma);
    }

    throw UnsupportedError("Unsupported paint $type");
  }
}

class SolidColorPaint extends Paint {
  final Color color;
  SolidColorPaint(double opacity, this.color) : super(opacity);

  factory SolidColorPaint.fromFigma(dynamic figma) {
    var opacity = figma["opacity"];
    var color = Color.fromFigma(figma["color"], opacity);
    return SolidColorPaint(opacity, color);
  }
}

class ImagePaint extends Paint {
  final String imageRef;
  final ScaleMode scaleMode;
  ImagePaint(double opacity, this.scaleMode, this.imageRef) : super(opacity);

  factory ImagePaint.fromFigma(dynamic figma) {
    var opacity = figma["opacity"];
    var scaleMode = scaleModeFromFigmaScaleMode(figma["scaleMode"]);
    var imageRef = figma["imageRef"];
    return ImagePaint(opacity, scaleMode, imageRef);
  }
}

abstract class GradientPaint extends Paint {
  final List<Vector> gradientHandlePositions;
  final List<ColorStop> gradientStops;
  GradientPaint(
    double opacity, 
    this.gradientHandlePositions, 
    this.gradientStops) 
      : super(opacity);
}

class LinearGradientPaint extends GradientPaint {
  LinearGradientPaint(
    double opacity, 
    List<Vector> gradientHandlePositions, 
    List<ColorStop> gradientStops) 
      : super(opacity, gradientHandlePositions, gradientStops);

  factory LinearGradientPaint.fromFigma(dynamic figma) {
    var opacity = figma["opacity"];
    var gradientHandlePositions = figma["gradientHandlePositions"] as Iterable;
    var gradientStops = figma["gradientStops"] as Iterable;
    return LinearGradientPaint(
      opacity,
      gradientHandlePositions.map((n) => Vector.fromFigma(n)).toList(), 
      gradientStops.map((n) => ColorStop.fromFigma(n, opacity)).toList(), 
      );
  }
}

class RadialGradientPaint extends GradientPaint {
  RadialGradientPaint(
    double opacity, 
    List<Vector> gradientHandlePositions, 
    List<ColorStop> gradientStops) 
      : super(opacity, gradientHandlePositions, gradientStops);

  factory RadialGradientPaint.fromFigma(dynamic figma) {
    var opacity = figma["opacity"];
    var gradientHandlePositions = figma["gradientHandlePositions"] as Iterable;
    var gradientStops = figma["gradientStops"] as Iterable;
    return RadialGradientPaint(
      opacity,
      gradientHandlePositions.map((n) => Vector.fromFigma(n)).toList(), 
      gradientStops.map((n) => ColorStop.fromFigma(n, opacity)).toList(), 
    );
  }
}

class AngularGradientPaint extends GradientPaint {
  AngularGradientPaint(
    double opacity, 
    List<Vector> gradientHandlePositions, 
    List<ColorStop> gradientStops) 
      : super(opacity, gradientHandlePositions, gradientStops);

  factory AngularGradientPaint.fromFigma(dynamic figma) {
    var opacity = figma["opacity"];
    var gradientHandlePositions = figma["gradientHandlePositions"] as Iterable;
    var gradientStops = figma["gradientStops"] as Iterable;
    return AngularGradientPaint(
      opacity,
      gradientHandlePositions.map((n) => Vector.fromFigma(n)).toList(), 
      gradientStops.map((n) => ColorStop.fromFigma(n, opacity)).toList(), 
    );
  }
}

class FillStyle extends Style {
  final List<Paint> paints;
  FillStyle.fromFigma(FigmaStyle figma) : 
    this.paints = (figma.node["fills"] as Iterable).map((f) => Paint.fromFigma(f)).toList(),
    super(figma.name);
} 