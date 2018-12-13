import 'package:figma_styles_exporter/generators/base.dart';
import 'package:figma_styles_exporter/generators/flutter/effects.dart';
import 'package:figma_styles_exporter/generators/flutter/paints.dart';
import 'package:figma_styles_exporter/generators/flutter/texts.dart';
import 'package:figma_styles_exporter/themes/styles/effect.dart';
import 'package:figma_styles_exporter/themes/styles/fill.dart';
import 'package:figma_styles_exporter/themes/styles/text.dart';
import 'package:figma_styles_exporter/themes/theme.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:recase/recase.dart';

class FlutterGenerator extends Generator {
  @override
  String build(Theme theme) {
    var classes = [
      _buildTheme(theme),
      _buildThemeData(theme),
      _buildFills(theme),
      _buildEffects(theme),
      _buildTexts(theme),
    ];

    var library = Library((b) => b
      ..body.add(Code("typedef ImageProvider ImageLocator(String reference, BoxFit fit);"))
      ..body.addAll(classes)
      ..directives.addAll([
        Directive.import("dart:ui"),
        Directive.import("package:flutter/widgets.dart"),
      ]));

    var emitter = DartEmitter();
    var source = '${library.accept(emitter)}';
    return DartFormatter().format(source);
  }


  Class _buildTheme(Theme theme) {
     var builder = ClassBuilder()
      ..name = "FigmaTheme"
      ..extend = refer("InheritedWidget");

      builder.fields.add(Field((b) => b
        ..name = "data"
        ..modifier = FieldModifier.final$
        ..type = refer("FigmaThemeData")));


    var constructor = ConstructorBuilder();

    if(theme.hasImage) {
      builder.fields.add(Field((b) => b
        ..name = "imageLocator"
        ..modifier = FieldModifier.final$
        ..type = refer("ImageLocator")));

      constructor.optionalParameters.add(Parameter((p) => p
          ..name = "imageLocator"
          ..named = true
          ..toThis = true
          ..type = refer("ImageLocator")));
    }


    constructor.optionalParameters.add(Parameter((p) => p
        ..name = "key"
        ..named = true
        ..type = refer("Key")));

    constructor.optionalParameters.add(Parameter((p) => p
        ..name = "child"
        ..named = true
        ..type = refer("Widget")));

    constructor.optionalParameters.add(Parameter((p) => p
        ..name = "data"
        ..named = true
        ..type = refer("FigmaThemeData")));

    constructor.optionalParameters.add(Parameter((p) => p
        ..name = "sizeFactor"
        ..named = true
        ..defaultTo = Code("1.0")
        ..type = refer("double")));

    constructor.initializers.add(Code("this.data = data ?? FigmaThemeData(" + (theme.hasImage ? "imageLocator" : "") + ", sizeFactor: sizeFactor )"));
    constructor.initializers.add(Code("super(key: key, child: child)"));

    var updateShouldNotify = Method((b) => b
      ..name = "updateShouldNotify"
      ..annotations.add(CodeExpression(Code("override")))
      ..returns = refer("bool")
      ..requiredParameters.add(Parameter((b) => b
        ..name = "oldWidget"
        ..type = refer("InheritedWidget")))
      ..lambda = true
      ..body = Code("true"));


    var of = Method((b) => b
      ..static = true
      ..name = "of"
      ..returns = refer("FigmaThemeData")
      ..requiredParameters.add(Parameter((b) => b
        ..name = "context"
        ..type = refer("BuildContext")))
      ..lambda = true
      ..body = Code("(context.inheritFromWidgetOfExactType(FigmaTheme) as FigmaTheme).data"));

    builder.constructors.add(constructor.build());
    builder.methods.addAll([updateShouldNotify, of]);
    return builder.build();
  }

  Class _buildThemeData(Theme theme) {
     var builder = ClassBuilder()
      ..name = "FigmaThemeData";

    var constructor = ConstructorBuilder();

    constructor.optionalParameters.add(Parameter((p) => p
        ..name = "sizeFactor"
        ..named = true
        ..defaultTo = Code("1.0")
        ..type = refer("double")));

    if(theme.hasImage) {
      constructor.requiredParameters.add(Parameter((p) => p
          ..name = "imageLocator"
          ..named = true
          ..type = refer("ImageLocator")));
    }

    if(theme.fills.isNotEmpty) {
      constructor.optionalParameters.add(Parameter((p) => p
          ..name = "fills"
          ..named = true
          ..type = refer("FigmaFills")));

      constructor.initializers.add(Code("this.fills = fills ?? FigmaFills(" + (theme.hasImage ? "imageLocator" : "") + ")"));

      builder.fields.add(Field((b) => b
        ..name = "fills"
        ..modifier = FieldModifier.final$
        ..type = refer("FigmaFills")));
    }

    if(theme.effects.isNotEmpty) {
      constructor.optionalParameters.add(Parameter((p) => p
          ..name = "effects"
          ..named = true
          ..type = refer("FigmaEffects")));

      constructor.initializers.add(Code("this.effects = effects ?? FigmaEffects()"));

      builder.fields.add(Field((b) => b
        ..name = "effects"
        ..modifier = FieldModifier.final$
        ..type = refer("FigmaEffects")));
    }

    if(theme.texts.isNotEmpty) {
      constructor.optionalParameters.add(Parameter((p) => p
          ..name = "text"
          ..named = true
          ..type = refer("FigmaText")));

      constructor.initializers.add(Code("this.text = text ?? FigmaText(sizeFactor: sizeFactor)"));

      builder.fields.add(Field((b) => b
        ..name = "text"
        ..modifier = FieldModifier.final$
        ..type = refer("FigmaText")));
    }
    
    builder.constructors.add(constructor.build());

    return builder.build();
  }

  void _buildPaint(String name, Paint paint, ClassBuilder builder, ConstructorBuilder constructor) {

      String type = "Color";

      if(paint is SolidColorPaint) {
        type = "Color";
      }
      else if(paint is LinearGradientPaint) {
        type = "LinearGradient";
      }
      else if(paint is RadialGradientPaint) {
        type = "RadialGradient";
      }
      else if(paint is AngularGradientPaint) {
        type = "SweepGradient";
      }
      else if(paint is ImagePaint) {
        type = "ImageProvider";
      }

      constructor.optionalParameters.add(Parameter((p) => p
        ..name = name
        ..named = true
        ..type = refer(type)));

      constructor.initializers.add(Code("this.$name = $name ?? " + PaintGenerator().build(paint).toString()));

      builder.fields.add(Field((b) => b
        ..name = name
        ..modifier = FieldModifier.final$
        ..type = refer(type)));
  }

  Class _buildFills(Theme theme) {

    var builder = ClassBuilder()
      ..name = "FigmaFills";

    var constructor = ConstructorBuilder();

    if(theme.hasImage) {
      constructor.requiredParameters.add(Parameter((p) => p
          ..name = "imageLocator"
          ..named = true
          ..type = refer("ImageLocator")));
    }
    
    for (var fill in theme.fills) {
      var name = ReCase(fill.name).camelCase;

      if(fill.paints.length > 1) {
        for (var i = 0; i < fill.paints.length; i++) {
          var paint = fill.paints[i];
          var paintName = name + i.toString();
          _buildPaint(paintName, paint, builder, constructor);
        }
      }
      else if(fill.paints.length > 0) {
        _buildPaint(name, fill.paints.first, builder, constructor);
      }
    }

    builder.constructors.add(constructor.build());

    return builder.build();
  }

  void _buildEffect(String name, Effect effect, ClassBuilder builder, ConstructorBuilder constructor) {

      String type = "?";

      if(effect is Shadow) {
        type = "BoxShadow";
      }
      else if(effect is Blur) {
        type = "ImageFilter";
      }

      constructor.optionalParameters.add(Parameter((p) => p
        ..name = name
        ..named = true
        ..type = refer(type)));

      constructor.initializers.add(Code("this.$name = $name ?? " + EffectGenerator().build(effect).toString()));

      builder.fields.add(Field((b) => b
        ..name = name
        ..modifier = FieldModifier.final$
        ..type = refer(type)));
  }

  Class _buildEffects(Theme theme) {

    var builder = ClassBuilder()
      ..name = "FigmaEffects";

    var constructor = ConstructorBuilder();
    
    for (var effect in theme.effects) {
      var name = ReCase(effect.name).camelCase;

      if(effect.effects.length > 1) {
        for (var i = 0; i < effect.effects.length; i++) {
          var e = effect.effects[i];
          var paintName = name + i.toString();
          _buildEffect(paintName, e, builder, constructor);
        }
      }
      else if(effect.effects.length > 0) {
        _buildEffect(name, effect.effects.first, builder, constructor);
      }
    }

    builder.constructors.add(constructor.build());

    return builder.build();
  }

  void _buildText(String name, TextStyle effect, ClassBuilder builder, ConstructorBuilder constructor) {
   
    constructor.optionalParameters.add(Parameter((p) => p
      ..name = name
      ..named = true
      ..type = refer("TextStyle")));

    constructor.initializers.add(Code("this.$name = $name ?? " + TextGenerator().build(effect).toString()));

    builder.fields.add(Field((b) => b
      ..name = name
      ..modifier = FieldModifier.final$
      ..type = refer("TextStyle")));
  }

  Class _buildTexts(Theme theme) {
    var builder = ClassBuilder()
      ..name = "FigmaText";

    var constructor = ConstructorBuilder();

    constructor.optionalParameters.add(Parameter((p) => p
        ..name = "sizeFactor"
        ..named = true
        ..defaultTo = Code("1.0")
        ..type = refer("double")));
    
    for (var text in theme.texts) {
      var name = ReCase(text.name).camelCase;
        _buildText(name, text, builder, constructor);
    }

    builder.constructors.add(constructor.build());

    return builder.build();
  }
}