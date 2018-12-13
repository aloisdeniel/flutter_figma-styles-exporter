import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:figma_styles_exporter/generators/base.dart';
import 'package:figma_styles_exporter/generators/flutter/flutter.dart';
import 'package:figma_styles_exporter/figma/api.dart';
import 'package:figma_styles_exporter/themes/theme.dart';
import 'package:http/http.dart';


void main(List<String> args) async {

  var parser = new ArgParser();
  parser.addOption('config', abbr: 'c');

  var results = parser.parse(args);

  //reading config
  var configPath = results["config"] ?? ".figma";
  var configFile = File(configPath);
  if(!configFile.existsSync()) return print("a config file path must be provided");
  var config = json.decode(configFile.readAsStringSync());

  var token = config["token"];
  var fileKey = config["file"];
  var targets = config["targets"];

  if(token == null) return print("a token must be provided");
  if(fileKey == null) return print("a fileKey must be provided");
  if(targets == null) return print("targets must be provided");

  var api = FigmaApi(Client(), token);
  print("Start download ....");
  var file = await api.getFile(fileKey);
  print("File ${file.source["name"]} successfully downloaded");

  for (var item in targets) {
      
    var target = item["target"];
    var output = item["output"];

    if(output == null) return print("an ouput file path must be provided");

    var theme = Theme.fromFigma(file);
    Generator generator;
    switch(target)
    {
      default:
        generator = FlutterGenerator();
        break;
    }
    
    print("Building $target code....");
    var code = generator.build(theme);
    await (new File(output)).writeAsString(code);
    print("Result saved to $output!");
  }
}