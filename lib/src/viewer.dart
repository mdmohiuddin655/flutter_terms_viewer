import 'dart:math';

import 'package:flutter/material.dart';

import 'terms_reader.dart';

typedef TermsBuilder = Widget? Function(
  BuildContext context,
  TermsData data,
  int index,
);

typedef TermsInlineBuilder = InlineSpan? Function(
  TermsSpan data,
  TextStyle style,
  int index,
);

typedef TermsOrderAlignmentBuilder = CrossAxisAlignment? Function(
  int position,
);
typedef TermsOrderTextBuilder = String? Function(
  TermsData data,
  int index,
);
typedef TermsStyleBuilder = TextStyle? Function(
  TermsData data,
  TextStyle style,
  int index,
);

class TermsViewer extends StatelessWidget {
  final Terms data;
  final TermsInlineBuilder? titleBuilder;
  final TermsStyleBuilder? titleStyleBuilder;
  final TermsInlineBuilder? textBuilder;
  final TermsStyleBuilder? textStyleBuilder;
  final TermsBuilder? orderBuilder;
  final TermsOrderAlignmentBuilder? orderAlignmentBuilder;
  final TermsStyleBuilder? orderStyleBuilder;
  final TermsOrderTextBuilder? orderTextBuilder;
  final double orderSpacingWidthFactor;
  final double? orderInnerSpace;

  const TermsViewer({
    super.key,
    required this.data,
    this.titleBuilder,
    this.titleStyleBuilder,
    this.textBuilder,
    this.textStyleBuilder,
    this.orderBuilder,
    this.orderStyleBuilder,
    this.orderTextBuilder,
    this.orderInnerSpace,
    this.orderSpacingWidthFactor = 1,
    this.orderAlignmentBuilder,
  });

  @override
  Widget build(BuildContext context) {
    int index = -1;
    final children = data.contents;
    if (children.isEmpty) return const SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(children.length, (i) {
        final data = children[i];
        if (data.isSequenceOrder) index++;
        return _Child(
          index: index,
          data: data,
          titleBuilder: titleBuilder,
          titleStyleBuilder: titleStyleBuilder,
          textBuilder: textBuilder,
          textStyleBuilder: textStyleBuilder,
          orderAlignmentBuilder: orderAlignmentBuilder,
          orderBuilder: orderBuilder,
          orderStyleBuilder: orderStyleBuilder,
          orderInnerSpace: orderInnerSpace,
          orderSpacingWidthFactor: orderSpacingWidthFactor,
          orderTextBuilder: orderTextBuilder,
        );
      }),
    );
  }
}

class _Child extends StatelessWidget {
  final int index;
  final TermsData data;

  final TermsInlineBuilder? titleBuilder;
  final TermsStyleBuilder? titleStyleBuilder;
  final TermsInlineBuilder? textBuilder;
  final TermsStyleBuilder? textStyleBuilder;
  final TermsBuilder? orderBuilder;
  final TermsOrderAlignmentBuilder? orderAlignmentBuilder;
  final TermsStyleBuilder? orderStyleBuilder;
  final TermsOrderTextBuilder? orderTextBuilder;
  final double orderSpacingWidthFactor;
  final double? orderInnerSpace;

  const _Child({
    required this.index,
    required this.data,
    this.titleBuilder,
    this.titleStyleBuilder,
    this.textBuilder,
    this.textStyleBuilder,
    this.orderBuilder,
    this.orderAlignmentBuilder,
    this.orderStyleBuilder,
    this.orderTextBuilder,
    this.orderSpacingWidthFactor = 1,
    this.orderInnerSpace,
  });

  String get _orderText {
    if (data.orderStyle.isEmpty) return '';
    if (!data.isSequenceOrder) return data.orderStyle;
    return orderTextBuilder?.call(data, index) ?? "${index + 1}.";
  }

  @override
  Widget build(BuildContext context) {
    int innerIndex = -1;
    final position = data.position;
    final title = data.title;
    final text = data.text;
    final children = data.children;

    final orderText = _orderText;

    const style = TextStyle(fontSize: 16);

    final mStyle = textStyleBuilder?.call(data, style, index) ?? style;

    final ts = style.copyWith(
      fontWeight: position <= 2 ? FontWeight.bold : null,
    );

    final mTitleStyle = titleStyleBuilder?.call(data, ts, index) ?? ts;

    final os = mTitleStyle.copyWith(
      fontSize: data.orderFontSize,
      fontStyle: data.orderFontStyle,
      fontWeight: data.orderFontWeight,
      decoration: data.orderTextDecoration,
    );

    final mOrderStyle = orderStyleBuilder?.call(data, os, index) ?? os;

    final mOrderSize = mOrderStyle.fontSize!;

    final mOrderSpace = orderInnerSpace ?? mOrderSize * 0.6;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty || text.isNotEmpty) ...[
          Row(
            crossAxisAlignment: orderAlignmentBuilder?.call(position) ??
                CrossAxisAlignment.start,
            children: [
              if (position > 1)
                SizedBox(
                  width: min(position - 1, 5) *
                      (mOrderSize * 1.18) *
                      orderSpacingWidthFactor,
                ),
              if (orderText.isNotEmpty)
                Builder(
                  builder: (context) {
                    Widget child = Padding(
                      padding: EdgeInsets.only(right: mOrderSpace),
                      child: Text(orderText, style: mOrderStyle),
                    );
                    if (orderBuilder != null) {
                      return orderBuilder!(context, data, index) ?? child;
                    }
                    return child;
                  },
                ),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      if (title.isNotEmpty)
                        TextSpan(
                          children: List.generate(title.length, (i) {
                            final e = title[i];
                            InlineSpan? span;

                            if (titleBuilder != null) {
                              span = titleBuilder!(e, mTitleStyle, i);
                            }

                            if (span != null) return span;

                            String mText = e.text;
                            if (text.isNotEmpty && !mText.endsWith("\n")) {
                              if (mText.endsWith(":")) {
                                mText = "$mText ";
                              }
                              if (!mText.endsWith(": ")) {
                                mText = "$mText: ";
                              }
                            }

                            return TextSpan(
                              text: mText,
                              style: mTitleStyle.copyWith(
                                fontSize: e.fontSize,
                                fontStyle: e.fontStyle,
                                fontWeight: e.fontWeight,
                                decoration: e.textDecoration,
                              ),
                            );
                          }),
                        ),
                      if (text.isNotEmpty)
                        TextSpan(
                          children: List.generate(text.length, (i) {
                            final e = text[i];

                            InlineSpan? span;

                            if (textBuilder != null) {
                              span = textBuilder!(e, mStyle, i);
                            }

                            if (span != null) return span;

                            return TextSpan(
                              text: e.text,
                              style: mStyle.copyWith(
                                fontSize: e.fontSize,
                                fontStyle: e.fontStyle,
                                fontWeight: e.fontWeight,
                                decoration: e.textDecoration,
                              ),
                            );
                          }),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
        if (children.isNotEmpty)
          ...List.generate(children.length, (i) {
            final data = children[i].copyWith(position: position + 1);
            if (data.isSequenceOrder) innerIndex++;
            return _Child(
              index: innerIndex,
              data: data,
              titleBuilder: titleBuilder,
              titleStyleBuilder: titleStyleBuilder,
              textBuilder: textBuilder,
              textStyleBuilder: textStyleBuilder,
              orderBuilder: orderBuilder,
              orderAlignmentBuilder: orderAlignmentBuilder,
              orderStyleBuilder: orderStyleBuilder,
              orderInnerSpace: orderInnerSpace,
              orderSpacingWidthFactor: orderSpacingWidthFactor,
              orderTextBuilder: orderTextBuilder,
            );
          }),
      ],
    );
  }
}
