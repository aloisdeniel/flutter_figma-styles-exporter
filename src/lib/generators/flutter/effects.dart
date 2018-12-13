import 'package:code_builder/code_builder.dart';
import 'package:figma_styles_exporter/generators/flutter/base.dart';
import 'package:figma_styles_exporter/themes/styles/effect.dart';

class EffectGenerator {
  Code build(Effect effect) {
    if(effect is Shadow) {
      return _buildDropShadow(effect);
    }
    if(effect is Blur) {
      return _buildBlur(effect);
    }

    return Code("?");
  }

  Code _buildDropShadow(Shadow effect) {
    var color = buildColor(effect.color);
    var offset = buildOffset(effect.offset);
    var blurRadius = effect.radius.toStringAsFixed(fixedPrecision);
    return Code('BoxShadow(color: $color, offset: $offset, blurRadius: $blurRadius)');
  }

  Code _buildBlur(Blur effect) {
    var x = effect.radius.toStringAsFixed(fixedPrecision);
    return Code('ImageFilter.blur(sigmaX:$x, sigmaY:$x)');
  }
}