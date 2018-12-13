import 'dart:math';

import 'package:code_builder/code_builder.dart';
import 'package:figma_styles_exporter/generators/flutter/base.dart';
import 'package:figma_styles_exporter/themes/styles/base.dart';
import 'package:figma_styles_exporter/themes/styles/fill.dart';

class PaintGenerator {
  Code build(Paint paint) {
    if(paint is SolidColorPaint) {
      return _buildSolidColor(paint);
    }

    if(paint is LinearGradientPaint) {
      return _buildLinearGradient(paint);
    }
    
    if(paint is RadialGradientPaint) {
      return _buildRadialGradient(paint);
    }
    
    if(paint is AngularGradientPaint) {
      return _buildAngularGradient(paint);
    }
    
    if(paint is ImagePaint) {
      return _buildImage(paint);
    }

    return Code("");
  }

  Code _buildBoxFit(ScaleMode scale) {
    switch (scale) {
      case ScaleMode.Fit:
        return Code('BoxFit.contain');
      case ScaleMode.Fill:
        return Code('BoxFit.cover');
      case ScaleMode.Stretch:
        return Code('BoxFit.fill');
      default:
        return Code('BoxFit.none');
    } 
  }

  Code _buildSolidColor(SolidColorPaint paint) => buildColor(paint.color);

  Vector _convertHandle(Vector v) => Vector((v.x - 0.5) * 2.0, (v.y - 0.5) * 2.0);

  Code _buildLinearGradient(LinearGradientPaint paint) {
    var begin = buildAlignment(_convertHandle(paint.gradientHandlePositions[0]));
    var end = buildAlignment(_convertHandle(paint.gradientHandlePositions[1]));
    var colors = "[" + paint.gradientStops.map((stop) => buildColor(stop.color)).join(",") + "]";
    var stops = "[" + paint.gradientStops.map((stop) => stop.position.toStringAsFixed(fixedPrecision)).join(",") + "]";
    return Code('LinearGradient(begin: $begin, end: $end, colors: $colors, stops: $stops)');
  }

  Code _buildImage(ImagePaint paint) {
    var imageRef = paint.imageRef;
    var boxfit = _buildBoxFit(paint.scaleMode);
    return Code('imageLocator("$imageRef", $boxfit)');
  }

  Code _buildRadialGradient(RadialGradientPaint paint) {
    var h1 = _convertHandle(paint.gradientHandlePositions[0]);
    var h2 = _convertHandle(paint.gradientHandlePositions[1]);
    var radius = h1.distanceTo(h2).toStringAsFixed(fixedPrecision);

    var center = buildAlignment(h1);
    var colors = "[" + paint.gradientStops.map((stop) => buildColor(stop.color)).join(",") + "]";
    var stops = "[" + paint.gradientStops.map((stop) => stop.position.toStringAsFixed(fixedPrecision)).join(",") + "]";
    return Code('RadialGradient(center: $center, radius: $radius, colors: $colors, stops: $stops)');
  }

  // FIXME : adjust stops and angles
  Code _buildAngularGradient(AngularGradientPaint paint) {
    var h1 = _convertHandle(paint.gradientHandlePositions[0]);
    var h2 = _convertHandle(paint.gradientHandlePositions[1]);
    var startAngleVector2 = h1.delta(h2);
    var startAngleVector1 = Vector(1.0, 0.0);
    var startAngleValue = startAngleVector1.angleTo(startAngleVector2) - pi / 2;

    var startAngle = startAngleValue.toStringAsFixed(fixedPrecision);
    var endAngle = (startAngleValue + pi * 2).toStringAsFixed(fixedPrecision);

    var center = buildAlignment(h1);
    var colors = "[" + paint.gradientStops.map((stop) => buildColor(stop.color)).join(",") + "]";
    var stops = "[" + paint.gradientStops.map((stop) => stop.position.toStringAsFixed(fixedPrecision)).join(",") + "]";
    return Code('SweepGradient(center: $center, startAngle: $startAngle, endAngle: $endAngle, colors: $colors, stops: $stops)');
  }
}