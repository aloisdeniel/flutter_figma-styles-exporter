import 'package:figma_styles_exporter/themes/theme.dart';

abstract class Generator {
  String build(Theme theme);
}