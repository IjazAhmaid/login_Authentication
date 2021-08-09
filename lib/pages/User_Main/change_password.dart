import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Login.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();

  var newpassword = "";

  final newpasswordController = TextEditingController();
  @override
  void dispose() {
    newpasswordController.dispose();

    super.dispose();
  }

  final currentUser = FirebaseAuth.instance.currentUser;
  changePassword() async {
    try {
      await currentUser!.updatePassword(newpassword);
      FirebaseAuth.instance.signOut();
      Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
            pageBuilder: (context, a, b) => Login(),
            transitionDuration: Duration(seconds: 0),
          ),
          (route) => false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text(
          "Your Password has been change login Again",
          style: TextStyle(fontSize: 18.0),
        ),
      ));
    } catch (e) {}
  }

  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: ListView(
            children: [
              Container(
                margin: EdgeInsets.symmetric(
                  vertical: 10,
                ),
                child: TextFormField(
                  autofocus: false,
                  decoration: InputDecoration(
                    labelText: 'New Password:',
                    hintText: 'Enter New Password',
                    labelStyle: TextStyle(fontSize: 20.0),
                    border: OutlineInputBorder(),
                    errorStyle: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 15,
                    ),
                  ),
                  controller: newpasswordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'please  enter new password:';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 60.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              newpassword = newpasswordController.text;
                            });
                          }
                          changePassword();
                        },
                        child: Text(
                          'Change Password',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
