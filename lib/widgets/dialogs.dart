import 'package:bizi/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future emptyDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Text('Fill all the fields!'),
          ),
        );
      });
}

mySnackbar(context) {
  Navigator.pop(context);
  ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text('Your request has been recieved')));
}

snackbar(context, text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}

authDialog(message, context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Authentication'),
          content: Text(message),
          // child: Container(
          //   padding: EdgeInsets.all(10),
          //   child: Text(message),
          // ),
        );
      });
}

messageDialog(title, message, context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(title, style: kDialogueTitleStyle),
          content: Container(
            // padding: EdgeInsets.all(10),
            child: Text(
              message,
              style: kDialogueContentStyle,
            ),
          ),
        );
      });
}

checkErrors(error, context) {
  print(error.code);
  switch (error.code) {
    case 'invalid-email':
      return authDialog('Invalid Email', context);
      break;
    case 'email-already-exists':
      return authDialog(
          'There is already a user registered with this email.', context);
      break;
    case 'iwrong-password':
      return authDialog('You entered a wrong password ', context);
      break;
    case 'internal-error':
      return authDialog('Server error. Please try again later ', context);
      break;
    case 'invalid-credential':
      return authDialog('Invalid credential', context);
      break;
    case 'invalid-password':
      return authDialog('Invalid password', context);
      break;
    case 'user-not-found':
      return authDialog('User not found', context);
      break;
    case 'invalid-argument':
      return authDialog('Invalid arguments', context);
      break;

    default:
      return authDialog('An error occured', context);
  }
}
