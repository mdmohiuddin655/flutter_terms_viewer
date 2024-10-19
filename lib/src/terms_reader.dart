import 'package:flutter/material.dart';

import 'parser.dart';

const _kOrderStyles = [
  TermsOrderStyle.number,
  TermsOrderStyle.lowerAlphabet,
  TermsOrderStyle.upperAlphabet,
  TermsOrderStyle.lowerRoman,
  TermsOrderStyle.upperRoman,
  TermsOrderStyle.lowerGreek,
  TermsOrderStyle.upperGreek,
];
const _kHeadlines = [
  TermsHeadline.h1,
  TermsHeadline.h2,
  TermsHeadline.h3,
  TermsHeadline.h4,
  TermsHeadline.h5,
  TermsHeadline.h6,
];

final class TermsOrderStyle {
  final String style;

  bool get isSequence => _kOrderStyles.contains(this);

  bool get isNormal => style == "normal";

  static const number = TermsOrderStyle("number");

  static const lowerAlphabet = TermsOrderStyle("lower_alphabet");

  static const upperAlphabet = TermsOrderStyle("upper_alphabet");

  static const lowerRoman = TermsOrderStyle("lower_roman");

  static const upperRoman = TermsOrderStyle("upper_roman");

  static const lowerGreek = TermsOrderStyle("lower_greek");

  static const upperGreek = TermsOrderStyle("upper_greek");

  static const normal = TermsOrderStyle("normal");

  const TermsOrderStyle(this.style);

  factory TermsOrderStyle.from(Object? source) {
    if (source == null) return const TermsOrderStyle("normal");
    return _kOrderStyles.firstWhere((e) {
      return e.style == source;
    }, orElse: () => TermsOrderStyle("$source"));
  }
}

final class TermsHeadline {
  final String id;
  final TextStyle value;

  bool get isCustom => id == "custom";

  static const h1 = TermsHeadline("h1");

  static const h2 = TermsHeadline("h2");

  static const h3 = TermsHeadline("h3");

  static const h4 = TermsHeadline("h4");

  static const h5 = TermsHeadline("h5");

  static const h6 = TermsHeadline("h6");

  const TermsHeadline(
    this.id, [
    this.value = const TextStyle(),
  ]);

  factory TermsHeadline.from(Object? source) {
    if (source == null) return h4;
    return _kHeadlines.firstWhere((e) {
      return e.id == source;
    }, orElse: () => const TermsHeadline("custom"));
  }
}

enum TermsSpanType {
  bold("b"),
  italic("i"),
  underline("u"),
  normal("");

  final String id;

  const TermsSpanType(this.id);

  factory TermsSpanType.from(Object? source) {
    return values.firstWhere((e) => e.id == source, orElse: () {
      return TermsSpanType.normal;
    });
  }
}

class TermsSpan {
  final String text;
  final List<TermsSpanType> types;

  bool get isBold => types.contains(TermsSpanType.bold);

  bool get isItalic => types.contains(TermsSpanType.italic);

  bool get isUnderline => types.contains(TermsSpanType.underline);

  const TermsSpan({
    this.text = '',
    this.types = const [],
  });

  TermsSpan copyWith({
    String? text,
    List<TermsSpanType>? types,
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
      types: types is Iterable ? types.map(TermsSpanType.from).toList() : [],
    );
  }

  Map<String, dynamic> get json {
    return {
      if (text.isNotEmpty) "text": text,
      if (types.isNotEmpty) "types": types.map((e) => e.id).toList(),
    };
  }
}

class TermsData {
  final int position;
  final TermsHeadline headline;
  final TermsOrderStyle orderStyle;
  final List<TermsSpan> title;
  final List<TermsSpan> text;
  final List<TermsData> children;

  const TermsData({
    this.position = 0,
    this.headline = TermsHeadline.h4,
    this.orderStyle = TermsOrderStyle.normal,
    this.title = const [],
    this.text = const [],
    this.children = const [],
  });

  TermsData copyWith({
    int? position,
    TermsHeadline? headline,
    TermsOrderStyle? orderStyle,
    List<TermsSpan>? title,
    List<TermsSpan>? text,
    List<TermsData>? children,
  }) {
    return TermsData(
      position: position ?? this.position,
      title: title ?? this.title,
      headline: headline ?? this.headline,
      orderStyle: orderStyle ?? this.orderStyle,
      children: children ?? this.children,
      text: text ?? this.text,
    );
  }

  factory TermsData.from(Object? source) {
    if (source is! Map) return const TermsData();
    final title = source["title"];
    final text = source["text"];
    final headline = source["headline"];
    final orderStyle = source["order_style"];
    final children = source["children"];

    final mTitle = TermsParagraph.parse(title is String ? title : '');
    final mText = TermsParagraph.parse(text is String ? text : '');

    return TermsData(
      headline: TermsHeadline.from(headline),
      orderStyle: TermsOrderStyle.from(orderStyle),
      title: mTitle.children.map((e) {
        if (e is TermsSpannedText) {
          return TermsSpan(
            text: e.text,
            types: e.types.map(TermsSpanType.from).toList(),
          );
        }
        return TermsSpan(text: e.text);
      }).toList(),
      text: mText.children.map((e) {
        if (e is TermsSpannedText) {
          return TermsSpan(
            text: e.text,
            types: e.types.map(TermsSpanType.from).toList(),
          );
        }
        return TermsSpan(text: e.text);
      }).toList(),
      children:
          children is Iterable ? children.map(TermsData.from).toList() : [],
    );
  }

  Map<String, dynamic> get json {
    return {
      if (!headline.isCustom) "headline": headline.id,
      if (!orderStyle.isNormal) "order_style": orderStyle.style,
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
