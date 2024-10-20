import 'package:flutter/material.dart';

import 'parser.dart';

class TermsSpan {
  final String text;
  final List<String> types;

  bool get isBold => types.contains("b");

  bool get isItalic => types.contains("i");

  bool get isUnderline => types.contains("u");

  double? get fontSize {
    if (types.contains("h1")) return 20;
    if (types.contains("h2")) return 18;
    if (types.contains("h3")) return 16;
    if (types.contains("h4")) return 14;
    if (types.contains("h5")) return 13;
    if (types.contains("h6")) return 12;
    return null;
  }

  FontWeight? get fontWeight {
    if (types.contains("b")) return FontWeight.bold;
    return null;
  }

  FontStyle? get fontStyle {
    if (types.contains("i")) return FontStyle.italic;
    return null;
  }

  TextDecoration? get textDecoration {
    if (types.contains("u")) return TextDecoration.underline;
    return null;
  }

  const TermsSpan({
    this.text = '',
    this.types = const [],
  });

  TermsSpan copyWith({
    String? text,
    List<String>? types,
  }) {
    return TermsSpan(
      text: text ?? this.text,
      types: types ?? this.types,
    );
  }

  factory TermsSpan.from(Object? source) {
    if (source is! Map) return const TermsSpan();
    final text = source["text"];
    final types = source["types"];
    return TermsSpan(
      text: text is String ? text : '',
      types: types is Iterable ? types.map((e) => e.toString()).toList() : [],
    );
  }

  Map<String, dynamic> get json {
    return {
      if (text.isNotEmpty) "text": text,
      if (types.isNotEmpty) "types": types,
    };
  }
}

class TermsData {
  final int position;
  final String orderStyle;
  final List<TermsSpan> title;
  final List<TermsSpan> text;
  final List<TermsData> children;

  bool get isSequenceOrder {
    return isNumberOrder ||
        isLowerAlphabetOrder ||
        isUpperAlphabetOrder ||
        isLowerRomanOrder ||
        isUpperRomanOrder ||
        isLowerGreekOrder ||
        isUpperGreekOrder;
  }

  bool get isNumberOrder => orderStyle == "number";

  bool get isLowerAlphabetOrder => orderStyle == "lower_alphabet";

  bool get isUpperAlphabetOrder => orderStyle == "upper_alphabet";

  bool get isLowerRomanOrder => orderStyle == "lower_roman";

  bool get isUpperRomanOrder => orderStyle == "upper_roman";

  bool get isLowerGreekOrder => orderStyle == "lower_greek";

  bool get isUpperGreekOrder => orderStyle == "upper_greek";

  double? get orderFontSize {
    if (orderStyle.isEmpty) return null;
    final x = (title.isNotEmpty ? title : text).firstOrNull;
    return x?.fontSize;
  }

  FontStyle? get orderFontStyle {
    if (orderStyle.isEmpty) return null;
    final x = (title.isNotEmpty ? title : text).firstOrNull;
    return x?.fontStyle;
  }

  FontWeight? get orderFontWeight {
    if (orderStyle.isEmpty) return null;
    final x = (title.isNotEmpty ? title : text).firstOrNull;
    return x?.fontWeight;
  }

  TextDecoration? get orderTextDecoration {
    if (orderStyle.isEmpty) return null;
    final x = (title.isNotEmpty ? title : text).firstOrNull;
    return x?.textDecoration;
  }

  const TermsData({
    this.position = 0,
    this.orderStyle = '',
    this.title = const [],
    this.text = const [],
    this.children = const [],
  });

  TermsData copyWith({
    int? position,
    String? orderStyle,
    List<TermsSpan>? title,
    List<TermsSpan>? text,
    List<TermsData>? children,
  }) {
    return TermsData(
      position: position ?? this.position,
      title: title ?? this.title,
      orderStyle: orderStyle ?? this.orderStyle,
      children: children ?? this.children,
      text: text ?? this.text,
    );
  }

  factory TermsData.from(Object? source) {
    if (source is! Map) return const TermsData();
    final title = source["title"];
    final text = source["text"];
    final orderStyle = source["order_style"];
    final children = source["children"];

    final mTitle = TermsParagraph.parse(title is String ? title : '');
    final mText = TermsParagraph.parse(text is String ? text : '');

    return TermsData(
      orderStyle: orderStyle is String ? orderStyle : '',
      title: mTitle.children.map((e) {
        if (e is TermsSpannedText) {
          return TermsSpan(text: e.text, types: e.types);
        }
        return TermsSpan(text: e.text);
      }).toList(),
      text: mText.children.map((e) {
        if (e is TermsSpannedText) {
          return TermsSpan(text: e.text, types: e.types);
        }
        return TermsSpan(text: e.text);
      }).toList(),
      children:
          children is Iterable ? children.map(TermsData.from).toList() : [],
    );
  }

  Map<String, dynamic> get json {
    return {
      if (orderStyle.isNotEmpty) "order_style": orderStyle,
      if (title.isNotEmpty) "title": title.map((e) => e.json).toList(),
      if (text.isNotEmpty) "text": text.map((e) => e.json).toList(),
      if (children.isNotEmpty) "children": children.map((e) => e.json).toList(),
    };
  }
}

class Terms {
  final List<TermsData> contents;

  const Terms({
    this.contents = const [],
  });

  Terms copyWith({
    List<TermsData>? contents,
  }) {
    return Terms(
      contents: contents ?? this.contents,
    );
  }

  factory Terms.from(Object? source) {
    if (source is! Map) return const Terms();
    final contents = source["children"];
    return Terms(
      contents:
          contents is Iterable ? contents.map(TermsData.from).toList() : [],
    );
  }

  Map<String, dynamic> get json {
    return {
      if (contents.isNotEmpty) "children": contents.map((e) => e.json).toList(),
    };
  }
}
