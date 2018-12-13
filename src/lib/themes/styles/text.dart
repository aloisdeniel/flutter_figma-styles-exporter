import 'package:figma_styles_exporter/figma/file.dart';
import 'package:figma_styles_exporter/themes/styles/base.dart';

class TextStyle extends Style {

  final String fontFamily;
  final String fontPostScriptName;
  final int fontWeight;
  final double fontSize;
  final Align textAlignHorizontal;
  final Align textAlignVertical;
  final double letterSpacing;
  final double lineHeightPx;
  final double lineHeightPercent;

  TextStyle(
    String name,
    this.fontFamily, 
    this.fontPostScriptName, 
    this.fontWeight, 
    this.fontSize,
    this.textAlignHorizontal,
    this.textAlignVertical,
    this.letterSpacing,
    this.lineHeightPx,
    this.lineHeightPercent) :
    super(name);

  factory TextStyle.fromFigma(FigmaStyle figma) {
    var source = figma.node["style"];
    assert(source != null);
    return TextStyle(
      figma.name,
      source["fontFamily"],
      source["fontPostScriptName"],
      source["fontWeight"],
      source["fontSize"].toDouble(),
      alignFromFigmaAlign(source["textAlignHorizontal"]),
      alignFromFigmaAlign(source["textAlignVertical"]),
      source["letterSpacing"].toDouble(),
      source["lineHeightPx"].toDouble(),
      source["lineHeightPercent"].toDouble()
    );
  }
}