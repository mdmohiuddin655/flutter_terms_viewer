abstract class TermsText {
  final String text;

  const TermsText({
    required this.text,
  });

  @override
  String toString() {
    return '$TermsText(text: $text)';
  }
}

class TermsNormalText extends TermsText {
  const TermsNormalText({
    required super.text,
  });
}

class TermsSpannedText extends TermsText {
  final List<String> types;

  const TermsSpannedText({
    required super.text,
    required this.types,
  });

  @override
  String toString() {
    return '$TermsSpannedText(text: $text, types: $types)';
  }
}

class TermsParagraph {
  final String text;
  final List<TermsText> children;

  const TermsParagraph({
    this.text = '',
    required this.children,
  });

  TermsParagraph.parse(String text) : this(children: _parse(text), text: text);

  static List<TermsText> _parse(String paragraph) {
    if (paragraph.isEmpty) return [];
    if (!paragraph.startsWith("<p>")) {
      paragraph = "<p>$paragraph";
    }
    if (!paragraph.endsWith("</p>")) {
      paragraph = "$paragraph</p>";
    }
    List<TermsText> texts = [];

    // Regex to extract everything inside <p> and spans within <p>
    RegExp pTagExp = RegExp(r'<p[^>]*>(.*?)</p>', dotAll: true);
    RegExp spanTagExp = RegExp(r'<(\w+)[^>]*>(.*?)</\1>', dotAll: true);

    // Helper function to recursively extract nested spans
    List<TermsText> parseSpans(String text, List<String> tags) {
      List<TermsText> texts = [];

      Iterable<RegExpMatch> spanMatches = spanTagExp.allMatches(text);

      int lastIndex = 0;

      for (var spanMatch in spanMatches) {
        String spanText = spanMatch.group(2)!;
        String spanType = spanMatch.group(1)!;
        int spanStart = spanMatch.start;
        int spanEnd = spanMatch.end;

        // Add any normal text between last index and span start
        if (spanStart > lastIndex) {
          String normalText = text.substring(lastIndex, spanStart);
          if (normalText.isNotEmpty) {
            texts.add(TermsNormalText(text: normalText));
          }
        }

        // Parse nested spans recursively
        List<String> nestedTags = [...tags, spanType];
        var nestedElements = parseSpans(spanText, nestedTags);
        if (nestedElements.isEmpty) {
          texts.add(TermsSpannedText(text: spanText, types: nestedTags));
        } else {
          texts.addAll(nestedElements);
        }

        lastIndex = spanEnd;
      }

      // Add any remaining normal text after the last span
      if (lastIndex < text.length) {
        String remainingText = text.substring(lastIndex);
        if (remainingText.isNotEmpty) {
          if (tags.isNotEmpty) {
            texts.add(TermsSpannedText(
              text: remainingText,
              types: tags,
            ));
          } else {
            texts.add(TermsNormalText(text: remainingText));
          }
        }
      }

      return texts;
    }

    // Find the content inside <p> tags
    Iterable<RegExpMatch> pMatches = pTagExp.allMatches(paragraph);

    for (var pMatch in pMatches) {
      String pContent = pMatch.group(1)!; // Get the inner content of <p>

      // Parse content, starting with no parent tags
      texts.addAll(parseSpans(pContent, []));
    }

    return texts;
  }

  @override
  String toString() {
    return '$TermsParagraph(text: $text, children: $children)';
  }
}
