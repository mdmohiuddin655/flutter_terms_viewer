import 'dart:math';

import 'package:flutter/material.dart';

import 'terms_reader.dart';

typedef TermsBuilder<T> = Widget Function(
  BuildContext context,
  T data,
  int index,
);

typedef TermsOrderTextBuilder = String Function(
  String style,
  int index,
);

class TermsViewer extends StatelessWidget {
  final Terms data;
  final TermsBuilder<TermsData>? titleBuilder;
  final TermsBuilder<TermsData>? subtitleBuilder;
  final TermsBuilder<String>? orderBuilder;
  final TermsOrderTextBuilder? orderTextBuilder;
  final double orderSpacingWidthFactor;
  final double? orderInnerSpace;

  const TermsViewer({
    super.key,
    required this.data,
    this.titleBuilder,
    this.subtitleBuilder,
    this.orderBuilder,
    this.orderTextBuilder,
    this.orderInnerSpace,
    this.orderSpacingWidthFactor = 1,
  });

  @override
  Widget build(BuildContext context) {
    int index = 0;
    final children = data.contents;
    if (children.isEmpty) return const SizedBox();
    return Column(
      children: List.generate(children.length, (i) {
        final data = children[i];
        if (data.isSequenceOrder) index++;
        return TermsBody(
          index: index,
          data: data,
          orderBuilder: orderBuilder,
          orderInnerSpace: orderInnerSpace,
          orderSpacingWidthFactor: orderSpacingWidthFactor,
          orderTextBuilder: orderTextBuilder,
        );
      }),
    );
  }
}

class TermsBody extends StatelessWidget {
  final int index;
  final TermsData data;
  final TermsBuilder<String>? orderBuilder;
  final TermsOrderTextBuilder? orderTextBuilder;
  final double orderSpacingWidthFactor;
  final double? orderInnerSpace;

  const TermsBody({
    super.key,
    this.index = -1,
    required this.data,
    this.orderBuilder,
    this.orderTextBuilder,
    this.orderSpacingWidthFactor = 1,
    this.orderInnerSpace,
  });

  String get _orderText {
    if (data.orderStyle.isEmpty) return '';
    if (!data.isSequenceOrder) return data.orderStyle;
    return (orderTextBuilder ?? (_, __) => "($index)")(data.orderStyle, index);
  }

  @override
  Widget build(BuildContext context) {
    int innerIndex = 0;
    final position = data.position;
    final title = data.title;
    final text = data.text;
    final children = data.children;

    final orderText = _orderText;

    const mStyle = TextStyle(fontSize: 16);

    final mOrderStyle = mStyle.copyWith(
      color: data.orderColor,
      fontSize: data.orderFontSize,
      fontStyle: data.orderFontStyle,
      fontWeight: data.orderFontWeight,
      decoration: data.orderTextDecoration,
    );

    final mOrderSize = mOrderStyle.fontSize!;

    final mOrderSpace = orderInnerSpace ?? mOrderSize * 0.6;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty || text.isNotEmpty) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (position > 1)
                SizedBox(
                  width: min(position - 1, 5) *
                      (mOrderSize * 1.18) *
                      orderSpacingWidthFactor,
                ),
              if (orderText.isNotEmpty)
                if (orderBuilder != null)
                  orderBuilder!(context, orderText, index)
                else ...[
                  Text(
                    orderText,
                    style: mOrderStyle,
                  ),
                  SizedBox(width: mOrderSpace)
                ],
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      if (title.isNotEmpty)
                        TextSpan(
                          children: List.generate(title.length, (i) {
                            final e = title[i];
                            return TextSpan(
                              text: e.text,
                              style: mStyle.copyWith(
                                color: e.color,
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
                            return TextSpan(
                              text: e.text,
                              style: mStyle.copyWith(
                                color: e.color,
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
                  style: mStyle,
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
            return TermsBody(
              index: innerIndex,
              data: data,
              orderTextBuilder: orderTextBuilder,
              orderSpacingWidthFactor: orderSpacingWidthFactor,
              orderInnerSpace: orderInnerSpace,
              orderBuilder: orderBuilder,
            );
          }),
      ],
    );
  }
}
