import 'package:flutter/material.dart';
import 'package:passwordwidget/passwordwidget.dart';

class SamplePasswordPage extends StatefulWidget {
  const SamplePasswordPage();

  @override
  _SamplePasswordState createState() => _SamplePasswordState();
}

class _SamplePasswordState extends State<SamplePasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sample password page'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          child: PasswordWidget(
            passwordRegexpRule: [
              '^.{6,}\$',
              '^.{0,10}\$',
            ],
            passwordRules: [
              'Password should be at least 6 characters',
              'Password should not exceed 10 characters',
            ],
            passwordConfirmHintText: 'Please confirm your password',
            passwordHintText: 'Please fill your password',
            validateButtonText: 'Validate',
            onValidate: () => print('Password has been correctly set'),
          ),
        ),
      ),
    );
  }
}
