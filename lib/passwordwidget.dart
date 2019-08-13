library passwordwidget;

import 'package:flutter/material.dart';

/// Widget that manages the specific layout for password input. It also shows rules that passwords need to respect with specific color. The action button is only called if every rules are correct.
class PasswordWidget extends StatefulWidget {
  const PasswordWidget({
    @required this.passwordRules,
    @required this.passwordRegexpRule,
    @required this.onValidate,
    @required this.passwordHintText,
    @required this.passwordConfirmHintText,
    @required this.validateButtonText,
  });

  /// Password rules displayes between two input where user has to fill password entry
  final List<String> passwordRules;

  /// Password rules in regexp mode
  final List<String> passwordRegexpRule;

  /// Function neeeded to call when user tap on the validate button
  final Function onValidate;

  /// Hint text on the password text
  final String passwordHintText;

  /// Hint text for the confirm password
  final String passwordConfirmHintText;

  ///  Text displayed for the button
  final String validateButtonText;

  @override
  State<StatefulWidget> createState() => PasswordState();
}

class PasswordState extends State<PasswordWidget> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _checkPasswordController =
      TextEditingController();
  List<Text> ruleText = <Text>[];

  @override
  void initState() {
    _passwordController.addListener(_onChange);
    _checkPasswordController.addListener(_onChange);
    for (String currentRule in widget.passwordRules) {
      ruleText.add(Text(
        currentRule,
      ));
    }
    ruleText.add(const Text(
      '+ Passwords must be the same',
    ));
    super.initState();
  }

  void _onChange() {
    _updateRulesColor();
  }

  @override
  Widget build(BuildContext context) {
    const double _radius = 12;

    return Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Positioned(
              bottom: 0,
              top: 0,
              right: 0,
              left: 0,
              child: Material(
                color: Colors.white,
                elevation: 6,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(_radius)),
                ),
              ),
            ),
            TextField(
              obscureText: true,
              controller: _passwordController,
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(_radius),
                    borderSide: BorderSide(color: _getBorderColor()),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(_radius),
                    borderSide: BorderSide(color: _getBorderColor()),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(_radius),
                    borderSide: const BorderSide(color: Colors.transparent),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 26.0, vertical: 14),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(_radius),
                    borderSide:
                        const BorderSide(color: Colors.black, width: 1.0),
                  ),
                  hintText: widget.passwordHintText,
                  fillColor: Colors.white),
            ),
          ],
        ),
        const SizedBox(
          height: 25,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: ruleText,
        ),
        const SizedBox(
          height: 25,
        ),
        Stack(
          children: <Widget>[
            Positioned(
              bottom: 0,
              top: 0,
              right: 0,
              left: 0,
              child: Material(
                color: Colors.white,
                elevation: 6,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(_radius)),
                ),
              ),
            ),
            TextField(
              obscureText: true,
              controller: _checkPasswordController,
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(_radius),
                    borderSide: BorderSide(color: _getBorderColor()),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(_radius),
                    borderSide: BorderSide(color: _getBorderColor()),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(_radius),
                    borderSide: const BorderSide(color: Colors.transparent),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(_radius),
                    borderSide:
                        const BorderSide(color: Colors.black, width: 1.0),
                  ),
                  hintText: widget.passwordConfirmHintText,
                  fillColor: Colors.white),
            ),
          ],
        ),
        const SizedBox(
          height: 25,
        ),
        RaisedButton(
          child: Text(widget.validateButtonText),
          onPressed: () {
            if (!_hasInvalidRules()) {
              widget.onValidate();
            }
          },
        ),
      ],
    );
  }

  void _updateRulesColor() {
    final List<Text> newRuleList = <Text>[];
    final List<String> localRegexpRules = <String>[];
    localRegexpRules.addAll(widget.passwordRegexpRule);
    localRegexpRules.add('');
    for (int i = 0; i < ruleText.length; i++) {
      final Text newRule = Text(
        ruleText[i].data,
        style: TextStyle(color: _getColorRule(localRegexpRules[i])),
      );
      newRuleList.add(newRule);
    }

    setState(() {
      ruleText.clear();
      ruleText.addAll(newRuleList);
    });
  }

  Color _getColorRule(String rule) {
    final RegExp regExp = RegExp(rule);
    if (rule.isEmpty) {
      // Custom rule that needs to be managed here (the equalty of bth field)
      return _passwordController.text == _checkPasswordController.text
          ? Colors.green
          : Colors.red;
    } else if (regExp.hasMatch(_passwordController.text)) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  Color _getBorderColor() {
    Color borderColor = Colors.transparent;
    for (int i = 0; i < widget.passwordRegexpRule.length; i++) {
      final RegExp regExp = RegExp(widget.passwordRegexpRule[i]);
      if (!regExp.hasMatch(_passwordController.text)) {
        borderColor = Colors.red;
      }
    }
    borderColor = (_passwordController.text == _checkPasswordController.text)
        ? borderColor
        : Colors.red;
    return borderColor;
  }

  bool _hasInvalidRules() {
    bool hasInvalidRule = false;
    for (int i = 0; i < widget.passwordRegexpRule.length; i++) {
      final RegExp regExp = RegExp(widget.passwordRegexpRule[i]);
      if (!regExp.hasMatch(_passwordController.text)) {
        hasInvalidRule = true;
      }
    }
    return hasInvalidRule &&
        (_passwordController.text != _checkPasswordController.text);
  }
}
