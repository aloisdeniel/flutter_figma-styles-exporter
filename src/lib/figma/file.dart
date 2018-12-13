class FigmaStyle {
  final String name;
  final String type;
  final dynamic node;
  FigmaStyle(this.name, this.type, this.node);
}

class FigmaFile {
  final dynamic source;
  final List<FigmaStyle> styles;
  FigmaFile(this.source) : this.styles = _createStyles(source).toList();

  static Iterable<FigmaStyle> _createStyles(dynamic source) {
    return (source['styles'] as Map<String,dynamic>).map((k,v) {
        var name = v['name'];
        var type = v['styleType'];
        var node = _searchNodeWithStyle(k, source["document"]);
        return MapEntry(name, FigmaStyle(name, type, node));

    }).values;
  }

  static dynamic _searchNodeWithStyle(String styleId, dynamic node) {
    var nodeStyles = node['styles'];

    if(nodeStyles != null) {
      if(nodeStyles.values.any((v) => v == styleId)) {
        return node;
      }
    }

    var children = node["children"];
    if(children is Iterable) {
      for (var item in children) {
        var result = _searchNodeWithStyle(styleId, item);
        if(result != null) {
          return result;
        }
      }
    }

    return null;
  }
}
