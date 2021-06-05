import 'package:flutter/material.dart';

import 'form_feild.dart';
import 'stackcon.dart';

class ConfirmPhone extends StatefulWidget {
  @override
  _ConfirmPhoneState createState() => _ConfirmPhoneState();
}

class _ConfirmPhoneState extends State<ConfirmPhone> {
  final _formKey = GlobalKey<FormState>();

  final _phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    isValidPhoneNumber(String phoneNumber) {
      // You may need to change this pattern to fit your requirement.
      // I just copied the pattern from here: https://regexr.com/3c53v
      final pattern = r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$';
      final regExp = RegExp(pattern);

      if (phoneNumber == null || phoneNumber.isEmpty) {
        return 'cannot be empty';
      }

      if (!regExp.hasMatch(phoneNumber)) {
        return 'invalid phone number';
      }
      return null;
    }


    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
          key: _formKey,
          child: Column(
            children: [
              StackCon(
                text: 'Confirm Phone',
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(top: 30),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          colors: [
                        Colors.grey.withOpacity(0.4),
                        Colors.blue.withOpacity(0.6)
                      ],
                          stops: [
                        0.6,
                        0.9
                      ])),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Text(
                          'Enter your phone number and we will send you a password confirmation link',
                          style: TextStyle(color: Colors.black87, fontSize: 18),
                        ),
                      ),
                      InputField(
                        controller: _phoneController,
                        hint: 'Phone Number',
                        prefixIcon: Icons.phone,
                        validator: (value) {
                          // Validators.phone(value);
                        },
                        onSaved: (value) {
                          
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 15, left: 30, right: 30),
                        child: GestureDetector(
                            onTap: () {
                              if (_formKey.currentState.validate()) {
                                Scaffold.of(context).showSnackBar(
                                    SnackBar(content: Text('Submited')));
                              }
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ConfirmPhone()));
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.lightBlueAccent),
                              child: Center(
                                child: Text(
                                  'Change Password',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17),
                                ),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
