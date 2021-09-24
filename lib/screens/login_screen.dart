import 'package:flutter/material.dart';
import 'package:seaoil/providers/main/login_notifier.dart';
import 'package:seaoil/routing/routes.dart';
import 'package:seaoil/widgets/dialogs.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState>? _formKey;
  TextEditingController? number;
  TextEditingController? password;
  FocusNode? passwordNode;
  FocusNode? emailNode;

  @override
  void initState() {
    // TODO: implement initState
    _formKey = GlobalKey<FormState>();
    number = TextEditingController(text: '09021234567');
    password = TextEditingController(text: '123456');
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    number?.dispose();
    password?.dispose();
    passwordNode?.dispose();
    emailNode?.dispose();
    super.dispose();
  }

  void login() async {
    if (_formKey!.currentState!.validate()) {
      iosLoading(context);

      var res = await context
          .read<LoginNotifier>()
          .loginUser(mobile: number!.text, password: password!.text);
      print(res);
      if (res == true) {
        Navigator.of(context).pop();
        await VxNavigator.of(context).clearAndPush(Uri(path: MapPath));
        passwordNode?.unfocus();
        emailNode?.unfocus();
      } else {
        Navigator.of(context, rootNavigator: true).pop();
        showAlertDialog(context, res);
      }
    }
  }

  Widget title() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Welcome',
          style: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold),
        ),
        Text(
          'Enter your details',
          style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _textFields() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: number,
            focusNode: emailNode,
            style: const TextStyle(color: Colors.black),
            validator: (text) {
              if (text!.isEmpty) {
                return 'Mobile Number is required';
              }
              return null;
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              enabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Theme.of(context).cardColor),
                //  when the TextFormField in unfocused
              ),
              focusedBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Theme.of(context).cardColor),
                //  when the TextFormField in focused
              ),
              errorBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Theme.of(context).cardColor),
                //  when the TextFormField in focused
              ),
              focusedErrorBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Theme.of(context).cardColor),
                //  when the TextFormField in focused
              ),
              hintText: 'Mobile Number',
              labelText: 'Mobile Number',
              labelStyle: const TextStyle(
                color: Colors.black,
              ),
              border: InputBorder.none,
              isDense: false,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            ),
          ),
          const SizedBox(height: 12.0),
          TextFormField(
            obscureText: true,
            controller: password,
            focusNode: passwordNode,
            validator: (text) {
              if (text!.isEmpty) {
                return 'Password is required';
              }
              return null;
            },
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Theme.of(context).cardColor),
                //  when the TextFormField in unfocused
              ),
              focusedBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Theme.of(context).cardColor),
                //  when the TextFormField in focused
              ),
              errorBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Theme.of(context).cardColor),
                //  when the TextFormField in focused
              ),
              focusedErrorBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Theme.of(context).cardColor),
                //  when the TextFormField in focused
              ),
              filled: true,
              fillColor: Colors.white,
              hintText: 'Password',
              labelText: 'Password',
              isDense: false,
              labelStyle: const TextStyle(color: Colors.black),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            ),
          )
        ],
      ),
    );
  }

  Widget _loginButton() {
    return FloatingActionButton.extended(
        onPressed: login,
        backgroundColor: Colors.white,
        icon: const Icon(Icons.arrow_forward_rounded,
            size: 20.0, color: Colors.black),
        isExtended: true,
        label: const Text(
          'Login',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff6c3eb5),
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24.0, 12.0, 24.0, 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            title(),
            const SizedBox(
              height: 12.0,
            ),
            _textFields()
          ],
        ),
      ),
      floatingActionButton: _loginButton(),
    );
  }
}
