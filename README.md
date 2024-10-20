# flutter_terms_viewer

The flutter_terms_viewer package offers a convenient widget for displaying Terms and Conditions,
Privacy Policy, and other legal texts within Flutter apps. It provides a scrollable, user-friendly
interface to view lengthy documents, making it easy to incorporate important legal information into
your app's UI.

## Example

```dart
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_terms_viewer/flutter_terms_viewer.dart';

const _kMappedTerms = {
  "children": [
    {
      "text":
      "Welcome to ExampleApp (\"<b>App</b>\", \"<b>we</b>\", \"<b>our</b>\", or \"<b>us</b>\"). These Terms and Conditions (\"<b>Terms</b>\") govern your access to and use of the services provided by <u><b>RandomoApp</b></u> (the \"Service\"). By accessing or using the App, you agree to comply with and be bound by these Terms. If you do not agree with these Terms, you may not use the Service.",
    },
    {
      "title": "<b>Acceptance of Terms</b>>",
      "order_style": "number",
      "children": [
        {
          "text":
          "By creating an account and using our Service, you agree to abide by these Terms and any applicable laws and regulations. If you do not accept these Terms, you must immediately stop using the Service.",
        },
      ],
    },
    {
      "title": "<b>Eligibility</b>",
      "order_style": "number",
      "children": [
        {
          "text":
          "You must be at least 16 years old to use this Service. By using the Service, you warrant that you meet this age requirement and that the information you provide is accurate, current, and complete.",
        }
      ],
    },
    {
      "title": "User Account and <u><i>Information</i></u>",
      "order_style": "number",
      "children": [
        {
          "title": "Registration: ",
          "order_style": "●",
          "text":
          "To access certain features of the Service, you may need to register an account. You are responsible for maintaining the confidentiality of your account information, including your password.",
          "children": [
            {
              "order_style": "○",
              "text":
              "To access certain features of the Service, you may need to register an account. You are responsible for maintaining the confidentiality of your account information, including your password.",
              "children": [
                {
                  "title": "Registration: ",
                  "order_style": "lower_alphabet",
                  "text":
                  "To access certain features of the Service, you may need to register an account. You are responsible for maintaining the confidentiality of your account information, including your password.",
                  "children": [
                    {
                      "order_style": "○",
                      "text":
                      "To access certain features of the Service, you may need to register an account. You are responsible for maintaining the confidentiality of your account information, including your password.",
                    },
                    {
                      "order_style": "○",
                      "text":
                      "To access certain features of the Service, you may need to register an account. You are responsible for maintaining the confidentiality of your account information, including your password.",
                    },
                  ]
                },
                {
                  "title": "Registration: ",
                  "order_style": "lower_alphabet",
                  "text":
                  "To access certain features of the Service, you may need to register an account. You are responsible for maintaining the confidentiality of your account information, including your password.",
                  "children": [
                    {
                      "order_style": "○",
                      "text":
                      "To access certain features of the Service, you may need to register an account. You are responsible for maintaining the confidentiality of your account information, including your password.",
                    },
                    {
                      "order_style": "○",
                      "text":
                      "To access certain features of the Service, you may need to register an account. You are responsible for maintaining the confidentiality of your account information, including your password.",
                    },
                  ]
                },
              ],
            },
          ]
        },
        {
          "title": "User Data",
          "order_style": "●",
          "text":
          "You agree that all information you provide to the App, including profile and contact details, is accurate and lawful. You are solely responsible for the legality and accuracy of the information you submit.",
        }
      ]
    },
    {
      "title": "<b>Collection of Data</b>",
      "order_style": "number",
      "children": [
        {
          "text":
          "By using this Service, you consent to the collection, storage, and use of your personal and sensitive information as outlined in our Privacy Policy. We are committed to ensuring the security and confidentiality of the information you provide.",
        },
      ],
    },
    {
      "title": "<b>Public Information Access</b>",
      "order_style": "number",
      "children": [
        {
          "title": "Consent-Based Public Access: ",
          "order_style": "●",
          "text":
          "Certain information you provide may be made publicly accessible to other users if you give explicit permission. You have full control over what information is shared and can revoke public access at any time.",
        },
        {
          "title": "Responsibility for Shared Data: ",
          "order_style": "●",
          "text":
          "You are responsible for the content and accuracy of the data you choose to share publicly. We are not liable for any misuse of data that you publicly disclose.",
        }
      ],
    },
    {
      "title": "<b>Prohibited Activities</b>",
      "order_style": "number",
      "children": [
        {
          "text":
          "While using the App, you agree not to engage in any of the following:",
          "children": [
            {
              "title": "Misuse of Information: ",
              "order_style": "●",
              "text":
              "You may not use another user’s personal information without their consent.",
            },
            {
              "title": "Illegal Activities: ",
              "order_style": "●",
              "text":
              "You may not use the Service to engage in any unlawful or illegal activities.",
            },
            {
              "title": "False Information: ",
              "order_style": "●",
              "text":
              "You must not submit false or misleading information, especially regarding your identity or status.",
            },
            {
              "title": "Violation of Rights: ",
              "order_style": "●",
              "text":
              "You must not infringe upon or violate the rights of others, including privacy and intellectual property rights.",
            }
          ]
        },
      ],
    },
    {
      "title": "<b>Termination</b>",
      "order_style": "number",
      "children": [
        {
          "text":
          "We reserve the right to suspend or terminate your account at any time, with or without notice, if you breach these Terms or engage in any behavior that is harmful or disruptive to the Service.",
        }
      ],
    },
    {
      "title": "<b>Intellectual Property</b>",
      "order_style": "number",
      "children": [
        {
          "text":
          "All content provided on the App, including text, graphics, logos, and software, is the intellectual property of RandomoApp and is protected by copyright, trademark, and other intellectual property laws. You are not allowed to copy, reproduce, or distribute any part of the App without our prior written consent.",
        }
      ],
    },
    {
      "title": "<b>Liability Disclaimer</b>",
      "order_style": "number",
      "children": [
        {
          "text":
          "We provide the Service \"as is\" and do not guarantee its accuracy, reliability, or fitness for any particular purpose. We are not responsible for:",
          "children": [
            {
              "order_style": "○",
              "text": "Errors or omissions in the information provided.",
            },
            {
              "order_style": "○",
              "text": "Loss of data or personal information.",
            },
            {
              "order_style": "○",
              "text": "Unauthorized access to your personal information.",
            }
          ]
        },
        {
          "text":
          "By using the Service, you agree that RandomoApp will not be held liable for any damages resulting from your use of the Service.",
        }
      ],
    },
    {
      "title": "<b>Third-Party Links</b>",
      "order_style": "number",
      "children": [
        {
          "text":
          "The App may contain links to third-party websites or services. We are not responsible for the content or policies of these third-party websites. If you access third-party sites, you do so at your own risk.",
        }
      ],
    },
    {
      "title": "<b>Modifications to Terms</b>",
      "order_style": "number",
      "children": [
        {
          "text":
          "We may update or modify these Terms at any time. If we make significant changes, we will notify you via the App or email. Continued use of the Service after such changes constitutes your acceptance of the new Terms.",
        }
      ],
    },
    {
      "title": "<b>Governing Law</b>",
      "order_style": "number",
      "children": [
        {
          "text":
          "These Terms are governed by and construed in accordance with the laws of Fictoria. Any disputes arising out of or related to these Terms shall be resolved in the courts of Nowhere City.",
        }
      ],
    },
    {
      "title": "<h1><b>Contact Information</b></h1>",
      "order_style": "number",
      "children": [
        {
          "text":
          "If you have any questions or concerns regarding these Terms or your use of the Service, please contact us at:",
        },
        {
          "text": "support@randomoapp.fake",
        },
      ],
    }
  ]
};

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Terms Viewer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Terms and conditions",
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
            child: TermsViewer(
              data: Terms.from(_kMappedTerms),
              orderTextBuilder: (data, index) {
                final position = data.position;
                if (position == 1) {
                  return OrderedListSequence.lowerAlpha
                      .sequence(index)
                      .join(".");
                }
                if (position == 2) {
                  return OrderedListSequence.lowerRoman
                      .sequence(index)
                      .join(".");
                }
                return null;
              },
              orderAlignmentBuilder: (position) {
                if (position == 0) {
                  return CrossAxisAlignment.center;
                }
                return null;
              },
              orderBuilder: (context, data, index) {
                if (data.position == 0) {
                  final color = Colors.primaries.elementAt(index);
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: color,
                    ),
                    child: Text(
                      "${index + 1}",
                      style: TextStyle(
                        color: color.isDark ? Colors.white : Colors.black,
                        height: 1,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
                return null;
              },
              orderStyleBuilder: (data, style, index) {
                final position = data.position;
                final isTitle = data.title.isNotEmpty;
                if (position == 1) {
                  return style.copyWith(
                    color: Colors.red,
                  );
                }
                if (position == 2) {
                  return style.copyWith(
                    color: isTitle ? Colors.blue : Colors.black,
                    fontWeight: isTitle ? null : FontWeight.normal,
                  );
                }
                return null;
              },
              titleStyleBuilder: (data, style, index) {
                final position = data.position;
                if (position == 0) {
                  return style.copyWith(
                    color: Colors.primaries.elementAtOrNull(max(index, 0)),
                  );
                }
                if (position == 1) {
                  return style.copyWith(
                    color: Colors.red,
                  );
                }
                if (position == 2) {
                  return style.copyWith(
                    color: Colors.blue,
                  );
                }
                return null;
              },
            ),
          ),
        ),
      ),
    );
  }
}
```

* https://raw.githubusercontent.com/Mohiuddin655-PUB/flutter_terms_viewer/master/example/Screenshot_20241020_230720.png
* https://raw.githubusercontent.com/Mohiuddin655-PUB/flutter_terms_viewer/master/example/Screenshot_20241020_231021.png
* https://raw.githubusercontent.com/Mohiuddin655-PUB/flutter_terms_viewer/master/example/Screenshot_20241020_234705.png
* https://raw.githubusercontent.com/Mohiuddin655-PUB/flutter_terms_viewer/master/example/Screenshot_20241020_234437.png
* https://raw.githubusercontent.com/Mohiuddin655-PUB/flutter_terms_viewer/master/example/Screenshot_20241020_234417.png
* https://raw.githubusercontent.com/Mohiuddin655-PUB/flutter_terms_viewer/master/example/Screenshot_20241020_231045.png
* https://raw.githubusercontent.com/Mohiuddin655-PUB/flutter_terms_viewer/master/example/Screenshot_20241020_232634.png
* https://raw.githubusercontent.com/Mohiuddin655-PUB/flutter_terms_viewer/master/example/Screenshot_20241020_232701.png
* https://raw.githubusercontent.com/Mohiuddin655-PUB/flutter_terms_viewer/master/example/Screenshot_20241020_004744.png
* https://raw.githubusercontent.com/Mohiuddin655-PUB/flutter_terms_viewer/master/example/Screenshot_20241020_004805.png
* https://raw.githubusercontent.com/Mohiuddin655-PUB/flutter_terms_viewer/master/example/Screenshot_20241020_004822.png
* https://raw.githubusercontent.com/Mohiuddin655-PUB/flutter_terms_viewer/master/example/Screenshot_20241020_004849.png



