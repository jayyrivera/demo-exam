import 'package:flutter/material.dart';

iosLoading(BuildContext context) {
  return showDialog(
    barrierDismissible: true,
    context: context,
    builder: (context) => Center(
      child: Container(
        width: 60.0,
        height: 60.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: const Padding(
          padding: EdgeInsets.all(12.0),
          child: CircularProgressIndicator(
            backgroundColor: Colors.white,
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xff6c3eb5)),
          ),
        ),
      ),
    ),
  );
}

Future<void> showAlertDialog(BuildContext context, String? text) async {
  // set up the buttons
  Widget cancelButton = TextButton(
    onPressed: () {
      Navigator.pop(context);
    },
    child: const Text(
      'Close',
      style: TextStyle(
        color: Colors.white,
      ),
    ),
  );
  // set up the AlertDialog
  var alert = AlertDialog(
    title: const Text(
      'Alert',
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    content: Text(
      text.toString(),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 12.0,
      ),
    ),
    actions: [
      cancelButton,
    ],
  );

  // show the dialog
  return await showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
