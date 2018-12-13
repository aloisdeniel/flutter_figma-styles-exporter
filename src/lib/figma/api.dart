
import 'dart:async';
import 'dart:convert';
import 'package:figma_styles_exporter/figma/file.dart';
import 'package:http/http.dart';

class FigmaApi {
  final String authToken;
  final BaseClient http;

  FigmaApi(this.http, this.authToken);

  Future<FigmaFile> getFile(String fileKey, {bool withGeometry = false}) async {
    var response = await http.get(
        "https://api.figma.com/v1/files/$fileKey" + (withGeometry ? "?geometry=paths" : ""),
        headers: {
          "X-FIGMA-TOKEN": this.authToken,
        });
    return FigmaFile(json.decode(response.body));
  }
}