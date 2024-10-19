import 'dart:math';

import 'package:flutter/material.dart';

import 'terms_reader.dart';

typedef TermsBuilder<T> = Widget Function(
  BuildContext context,
  T data,
  int index,
);

class TermsViewer extends StatelessWidget {
  final Terms data;
  final TermsBuilder<TermsData>? titleBuilder;
  final TermsBuilder<TermsData>? subtitleBuilder;

  const TermsViewer({
    super.key,
    required this.data,
    this.titleBuilder,
    this.subtitleBuilder,
  });

  @override
  Widget build(BuildContext context) {
    int index = 0;
    final contents = data.contents;
    if (contents.isEmpty) return const SizedBox();
    return Column(
      children: List.generate(contents.length, (i) {
        final data = contents[i];
        if (data.orderStyle.isSequence) index++;
        return TermsBody(index: index, data: data);
      }),
    );
  }
}

class TermsBody extends StatelessWidget {
  final int index;
  final TextStyle style;
  final TextStyle? titleStyle;
  final TermsData data;
  final TextStyle? orderStyle;
  final TermsBuilder<String>? orderBuilder;
  final String Function(int index, TermsOrderStyle style)? orderTextBuilder;
  final double orderSpacingWidthFactor;
  final double? orderInnerSpace;

  const TermsBody({
    super.key,
    this.index = -1,
    required this.data,
    this.style = const TextStyle(),
    this.titleStyle,
    this.orderStyle,
    this.orderBuilder,
    this.orderTextBuilder,
    this.orderSpacingWidthFactor = 1,
    this.orderInnerSpace,
  });

  String _orderText(TermsOrderStyle style, int index) {
    if (style.isNormal) return '';
    if (!style.isSequence) return style.style;
    return (orderTextBuilder ?? (_, __) => "($index)")(index, style);
  }

  @override
  Widget build(BuildContext context) {
    int innerIndex = 0;
    final position = data.position;
    final title = data.title;
    final text = data.text;
    final children = data.children;
    final orderText = _orderText(data.orderStyle, index);

    final mStyle = style.copyWith(fontSize: style.fontSize ?? 16);

    final mTitleStyle =
        titleStyle ?? mStyle.copyWith(fontWeight: FontWeight.bold);

    final mOrderStyle = orderStyle ?? mTitleStyle;

    final mOrderSpace = orderInnerSpace ?? mOrderStyle.fontSize! * 0.6;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (position > 1)
                SizedBox(
                    width: min(position - 1, 5) *
                        (mOrderStyle.fontSize! * 1.18) *
                        orderSpacingWidthFactor),
              if (orderText.isNotEmpty)
                if (orderBuilder != null)
                  orderBuilder!(context, orderText, index)
                else ...[
                  Text(orderText, style: mOrderStyle),
                  SizedBox(
                    width: orderText.endsWith(".") || orderText.endsWith(")")
                        ? mOrderSpace * 0.5
                        : mOrderSpace,
                  )
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
                                fontStyle: e.isItalic ? FontStyle.italic : null,
                                fontWeight: e.isBold
                                    ? FontWeight.bold
                                    : FontWeight.bold,
                                decoration: e.isUnderline
                                    ? TextDecoration.underline
                                    : null,
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
                                fontStyle: e.isItalic ? FontStyle.italic : null,
                                fontWeight: e.isBold ? FontWeight.bold : null,
                                decoration: e.isUnderline
                                    ? TextDecoration.underline
                                    : null,
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
        ),
        if (children.isNotEmpty)
          ...List.generate(children.length, (i) {
            final data = children[i].copyWith(position: position + 1);
            if (data.orderStyle.isSequence) innerIndex++;
            return TermsBody(index: innerIndex, data: data);
          }),
      ],
    );
  }
}
