import 'package:code_builder/code_builder.dart';
import 'package:figma_styles_exporter/themes/styles/base.dart';

const int fixedPrecision = 5;

Code buildColor(Color color) {
  var hex = color.value.toRadixString(16).padLeft(8, '0');
  return Code('Color(0x${hex})');
}

String buildAlignment(Vector v) => "Alignment(" + v.x.toStringAsFixed(fixedPrecision) + "," + v.y.toStringAsFixed(fixedPrecision) + ")";

String buildOffset(Vector v) => "Offset(" + v.x.toStringAsFixed(fixedPrecision) + "," + v.y.toStringAsFixed(fixedPrecision) + ")";