import 'package:flutter/material.dart';
import 'form_feild.dart';
import 'stackcon.dart';

class GetCode extends StatefulWidget {
  @override
  _GetCodeState createState() => _GetCodeState();
}

class _GetCodeState extends State<GetCode> with SingleTickerProviderStateMixin {
  AnimationController controller;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: Duration(seconds: 60), upperBound: 60);
    controller.reverse(from: 60);
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  int i = DateTime.now().second;
  final codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
          key: _formKey,
          child: Column(
            children: [
              StackCon(
                text: 'Confirm Your Phone',
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 10),
                        child: Text(
                          'Enter confirmation code sent to your number 237 654118518',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      controller.value == 0
                          ? Padding(
                              padding: EdgeInsets.symmetric(horizontal: 30),
                              child: GestureDetector(
                                child: Text(
                                  'Resend confirmation code',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: Text(
                                'Resend confirmation code in ${controller.value.toInt()}',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: InputField(
                          controller: codeController,
                          hint: '000000',
                          suffixIcon: Icons.remove_red_eye,
                          
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Cannot be empty';
                            }
                            return null;
                          },
                          // inputFormatters: [
                          //   [LengthLimitingTextInputFormatter(6)]
                          // ],
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 55, vertical: 10),
                        child: GestureDetector(
                            onTap: () {
                              if (_formKey.currentState.validate()) {
                                Navigator.pop(context, codeController.text.trim());
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.lightBlueAccent),
                              child: Center(
                                child: Text(
                                  'Confirm',
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
