import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:figma_styles_exporter/generators/base.dart';
import 'package:figma_styles_exporter/themes/theme.dart';

class FlutterGenerator extends Generator {
  @override
  String build(Theme theme) {
    var library = Library((b) => b
      ..body.add(Code("typedef ImageProvider ImageLocator(String reference, BoxFit fit);"))
      ..body.addAll(classes));

    var emitter = DartEmitter();
    var source = '${library.accept(emitter)}';
    return DartFormatter().format(source);
  }
}