import 'package:code_builder/code_builder.dart';
import 'package:figma_styles_exporter/themes/styles/text.dart';

class TextGenerator {
  Code build(TextStyle paint) {
    final fontWeight = paint.fontWeight;
    final fontSize = paint.fontSize;
    final fontFamily = paint.fontFamily;
    final letterSpacing = (paint.letterSpacing / 100.0) * paint.fontSize;
    return Code("TextStyle(fontWeight: FontWeight.w$fontWeight, fontSize: sizeFactor * $fontSize, fontFamily: '$fontFamily', letterSpacing: sizeFactor * $letterSpacing )");
  }
}