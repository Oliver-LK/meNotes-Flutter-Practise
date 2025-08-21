
import 'package:flutter/material.dart';

Future<void> showErrorDialog(BuildContext context, String errorMessage, String errorName) {

  return showDialog(
    context: context, 
    builder:(context) {
      
    return AlertDialog(
      title: Text('A ${errorName} Error Occurred') ,
      content: Text(errorMessage),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); 
          },
          child: Text("Ok")
        )
      ],
    );
  },
  );
}