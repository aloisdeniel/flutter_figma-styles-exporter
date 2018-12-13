import 'dart:math';

abstract class Style {
  final String name;
  Style(this.name);
}

enum Align {
  Start,
  End,
  Center,
  Stretch,
}

Align alignFromFigmaAlign(String figma) {
  switch(figma) {
    case "RIGHT":
    case "BOTTOM":
      return Align.End;
    case "CENTER":
      return Align.Center;
    case "JUSTIFIED":
      return Align.Stretch;
    default:
      return Align.Start;
  }
}

enum BlendMode {
  Normal,
  Multiply,
}

BlendMode blendModeFromFigmaBlendMode(String figma) {
  switch(figma) {
    case "MULTIPLY":
      return BlendMode.Multiply;
    default:
      return BlendMode.Normal;
  }
}

enum ScaleMode {
  Fill,
  Fit,
  Tile,
  Stretch,
}

ScaleMode scaleModeFromFigmaScaleMode(String figma) {
  switch(figma) {
    case "FILL":
      return ScaleMode.Fill;
    case "TILE":
      return ScaleMode.Tile;
    case "STRETCH":
      return ScaleMode.Stretch;
    default:
      return ScaleMode.Fit;
  }
}

class Vector {
  final double x;
  final double y;
  Vector(this.x,this.y);

  double get length => sqrt(length2);

  double get length2 {
    double sum;
    sum = (this.x * this.x);
    sum += (this.y * this.y);
    return sum;
  }

  factory Vector.fromFigma(dynamic node) {
    return Vector(node["x"].toDouble(), node["y"].toDouble());
  }

  double dot(Vector other) {
    double sum;
    sum = this.x * other.x;
    sum += this.y * other.y;
    return sum;
  }

  double angleTo(Vector other) {
    if (this.x == other.x && this.y == other.y) {
      return 0.0;
    }

    final double d = dot(other) / (length * other.length);

    return acos(d.clamp(-1.0, 1.0));
  }

  Vector delta(Vector other) => Vector(other.x - this.x, other.y - this.y);

  double distanceTo(Vector arg) => sqrt(distanceToSquared(arg));

  double distanceToSquared(Vector arg) {
    final double dx = x - arg.x;
    final double dy = y - arg.y;
    return dx * dx + dy * dy;
  }

}

class Color {
  final int value;
  Color(this.value);

  factory Color.fromFigma(dynamic node, double opacity) {
    return Color.fromARGB((node["a"] * (opacity ?? 1.0)).toDouble(), node["r"].toDouble(), node["g"].toDouble(), node["b"].toDouble());
  }

  factory Color.fromARGB(double a, double r, double g, double b) {
    var ba = (a * 255).toInt();
    var br = (r * 255).toInt();
    var bg = (g * 255).toInt();
    var bb = (b * 255).toInt();

    var value = (((ba & 0xff) << 24) |
                ((br & 0xff) << 16) |
                ((bg & 0xff) << 8)  |
                ((bb & 0xff) << 0)) & 0xFFFFFFFF;

    return Color(value);
  }
}

class ColorStop {
  final Color color;
  final double position;
  ColorStop(this.color, this.position);

  factory ColorStop.fromFigma(dynamic node, double opacity) {
    return ColorStop(Color.fromFigma(node["color"], opacity), node["position"].toDouble());
  }
}