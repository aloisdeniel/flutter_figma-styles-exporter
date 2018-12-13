import 'package:figma_styles_exporter/figma/file.dart';
import 'package:figma_styles_exporter/themes/styles/effect.dart';
import 'package:figma_styles_exporter/themes/styles/fill.dart';
import 'package:figma_styles_exporter/themes/styles/text.dart';

class Theme {
  final List<FillStyle> fills;
  final List<EffectStyle> effects;
  final List<TextStyle> texts;

  bool get hasImage => this.fills.any((s) => s.paints.any((p) => p is ImagePaint));

  Theme(this.fills, this.effects, this.texts);

  Theme.fromFigma(FigmaFile file) : 
    this.fills = file.styles.where((s) => s.type == "FILL").map((f) => FillStyle.fromFigma(f)).toList(),
    this.effects = file.styles.where((s) => s.type == "EFFECT").map((f) => EffectStyle.fromFigma(f)).toList(),
    this.texts = file.styles.where((s) => s.type == "TEXT").map((f) => TextStyle.fromFigma(f)).toList();
}