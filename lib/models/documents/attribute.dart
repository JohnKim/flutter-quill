import 'package:quiver_hashcode/hashcode.dart';

enum AttributeScope {
  INLINE, // refer to https://quilljs.com/docs/formats/#inline
  BLOCK, // refer to https://quilljs.com/docs/formats/#block
  EMBEDS, // refer to https://quilljs.com/docs/formats/#embeds
  IGNORE, // atttributes that can be igored
}

class Attribute<T> {
  final String key;
  final AttributeScope scope;
  final T value;

  Attribute(this.key, this.scope, this.value);

  static final Map<String, Attribute> _registry = {
    Attribute.bold.key: Attribute.bold,
    Attribute.italic.key: Attribute.italic,
    Attribute.underline.key: Attribute.underline,
    Attribute.strikeThrough.key: Attribute.strikeThrough,
    Attribute.link.key: Attribute.link,
    Attribute.color.key: Attribute.color,
    Attribute.background.key: Attribute.background,
    Attribute.header.key: Attribute.header,
    Attribute.indent.key: Attribute.indent,
    Attribute.align.key: Attribute.align,
    Attribute.list.key: Attribute.list,
    Attribute.codeBlock.key: Attribute.codeBlock,
    Attribute.blockQuote.key: Attribute.blockQuote,
    Attribute.width.key: Attribute.width,
    Attribute.height.key: Attribute.height,
    Attribute.style.key: Attribute.style,
  };

  static final BoldAttribute bold = BoldAttribute();

  static final ItalicAttribute italic = ItalicAttribute();

  static final UnderlineAttribute underline = UnderlineAttribute();

  static final StrikeThroughAttribute strikeThrough = StrikeThroughAttribute();

  static final LinkAttribute link = LinkAttribute(null);

  static final ColorAttribute color = ColorAttribute(null);

  static final BackgroundAttribute background = BackgroundAttribute(null);

  static final HeaderAttribute header = HeaderAttribute();

  static final IndentAttribute indent = IndentAttribute();

  static final AlignAttribute align = AlignAttribute(null);

  static final ListAttribute list = ListAttribute(null);

  static final CodeBlockAttribute codeBlock = CodeBlockAttribute();

  static final BlockQuoteAttribute blockQuote = BlockQuoteAttribute();

  static final WidthAttribute width = WidthAttribute(null);

  static final HeightAttribute height = HeightAttribute(null);

  static final StyleAttribute style = StyleAttribute(null);

  static final Set<String> inlineKeys = {
    Attribute.bold.key,
    Attribute.italic.key,
    Attribute.underline.key,
    Attribute.strikeThrough.key,
    Attribute.link.key,
    Attribute.color.key,
    Attribute.background.key
  };

  static final Set<String> blockKeys = {
    Attribute.header.key,
    Attribute.indent.key,
    Attribute.align.key,
    Attribute.list.key,
    Attribute.codeBlock.key,
    Attribute.blockQuote.key,
  };

  static final Set<String> blockKeysExceptHeader = {
    Attribute.list.key,
    Attribute.indent.key,
    Attribute.align.key,
    Attribute.codeBlock.key,
    Attribute.blockQuote.key,
  };

  static Attribute<int> get h1 => HeaderAttribute(level: 1);

  static Attribute<int> get h2 => HeaderAttribute(level: 2);

  static Attribute<int> get h3 => HeaderAttribute(level: 3);

  // "attributes":{"align":"left"}
  static Attribute<String> get leftAlignment => AlignAttribute('left');

  // "attributes":{"align":"center"}
  static Attribute<String> get centerAlignment => AlignAttribute('center');

  // "attributes":{"align":"right"}
  static Attribute<String> get rightAlignment => AlignAttribute('right');

  // "attributes":{"align":"justify"}
  static Attribute<String> get justifyAlignment => AlignAttribute('justify');

  // "attributes":{"list":"bullet"}
  static Attribute<String> get ul => ListAttribute('bullet');

  // "attributes":{"list":"ordered"}
  static Attribute<String> get ol => ListAttribute('ordered');

  // "attributes":{"indent":1"}
  static Attribute<int> get indentL1 => IndentAttribute(level: 1);

  // "attributes":{"indent":2"}
  static Attribute<int> get indentL2 => IndentAttribute(level: 2);

  // "attributes":{"indent":3"}
  static Attribute<int> get indentL3 => IndentAttribute(level: 3);

  static Attribute<int> getIndentLevel(int level) {
    if (level == 1) {
      return indentL1;
    }
    if (level == 2) {
      return indentL2;
    }
    return indentL3;
  }

  bool get isInline => scope == AttributeScope.INLINE;

  bool get isBlockExceptHeader => blockKeysExceptHeader.contains(key);

  Map<String, dynamic> toJson() => <String, dynamic>{key: value};

  static Attribute fromKeyValue(String key, dynamic value) {
    if (!_registry.containsKey(key)) {
      throw ArgumentError.value(key, 'key "$key" not found.');
    }
    Attribute origin = _registry[key];
    Attribute attribute = clone(origin, value);
    return attribute;
  }

  static Attribute clone(Attribute origin, dynamic value) {
    return Attribute(origin.key, origin.scope, value);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Attribute<T>) return false;
    Attribute<T> typedOther = other;
    return key == typedOther.key &&
        scope == typedOther.scope &&
        value == typedOther.value;
  }

  @override
  int get hashCode => hash3(key, scope, value);

  @override
  String toString() {
    return 'Attribute{key: $key, scope: $scope, value: $value}';
  }
}

class BoldAttribute extends Attribute<bool> {
  BoldAttribute() : super('bold', AttributeScope.INLINE, true);
}

class ItalicAttribute extends Attribute<bool> {
  ItalicAttribute() : super('italic', AttributeScope.INLINE, true);
}

class UnderlineAttribute extends Attribute<bool> {
  UnderlineAttribute() : super('underline', AttributeScope.INLINE, true);
}

class StrikeThroughAttribute extends Attribute<bool> {
  StrikeThroughAttribute() : super('strike', AttributeScope.INLINE, true);
}

class LinkAttribute extends Attribute<String> {
  LinkAttribute(String val) : super('link', AttributeScope.INLINE, val);
}

class ColorAttribute extends Attribute<String> {
  ColorAttribute(String val) : super('color', AttributeScope.INLINE, val);
}

class BackgroundAttribute extends Attribute<String> {
  BackgroundAttribute(String val)
      : super('background', AttributeScope.INLINE, val);
}

class HeaderAttribute extends Attribute<int> {
  HeaderAttribute({int level}) : super('header', AttributeScope.BLOCK, level);
}

class IndentAttribute extends Attribute<int> {
  IndentAttribute({int level}) : super('indent', AttributeScope.BLOCK, level);
}

class AlignAttribute extends Attribute<String> {
  AlignAttribute(String val) : super('align', AttributeScope.BLOCK, val);
}

class ListAttribute extends Attribute<String> {
  ListAttribute(String val) : super('list', AttributeScope.BLOCK, val);
}

class CodeBlockAttribute extends Attribute<bool> {
  CodeBlockAttribute() : super('code-block', AttributeScope.BLOCK, true);
}

class BlockQuoteAttribute extends Attribute<bool> {
  BlockQuoteAttribute() : super('blockquote', AttributeScope.BLOCK, true);
}

class WidthAttribute extends Attribute<String> {
  WidthAttribute(String val) : super('width', AttributeScope.IGNORE, val);
}

class HeightAttribute extends Attribute<String> {
  HeightAttribute(String val) : super('height', AttributeScope.IGNORE, val);
}

class StyleAttribute extends Attribute<String> {
  StyleAttribute(String val) : super('style', AttributeScope.IGNORE, val);
}
