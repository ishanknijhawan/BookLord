import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final Function(
    String userName,
    String email,
    String pass,
    bool isLogin,
  ) submitFn;
  AuthForm(this.submitFn);
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  String userName = '';
  String email = '';
  String password = '';
  String prevValue = '';
  bool hidePass = true;
  //var textController = TextEditingController();
  var counterText = 0;
  var isLogin = true;

  void trySubmit() {
    final isValidate = _formKey.currentState.validate();
    //to remove soft keyboard after submitting
    FocusScope.of(context).unfocus();
    if (isValidate) {
      _formKey.currentState.save();
      widget.submitFn(
        userName.trim(),
        email.trim(),
        password.trim(),
        isLogin,
      );
    }
  }

  Widget counter(
    BuildContext context, {
    int currentLength,
    int maxLength,
    bool isFocused,
  }) {
    return Text(
      '$currentLength/$maxLength',
      style: TextStyle(
        color: Colors.grey,
      ),
      semanticsLabel: 'character count',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    key: ValueKey('email'),
                    validator: (value) {
                      if (RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value)) {
                        return null;
                      } else {
                        return 'invalid email address';
                      }
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                    ),
                    onSaved: (newValue) {
                      email = newValue;
                    },
                  ),
                  if (!isLogin)
                    TextFormField(
                      key: ValueKey('username'),
                      onChanged: (value) {
                        if (prevValue.length > value.length) {
                          setState(() {
                            counterText--;
                          });
                        } else {
                          setState(() {
                            counterText++;
                          });
                        }
                        prevValue = value;
                      },
                      validator: (value) {
                        if (value.length > 3) {
                          return null;
                        } else {
                          return 'username must be atleast 4 characters';
                        }
                      },
                      decoration: InputDecoration(
                        counterText: '$counterText/20',
                        labelText: 'Username',
                      ),
                      onSaved: (newValue) {
                        userName = newValue;
                      },
                      maxLength: 20,
                    ),
                  TextFormField(
                    key: ValueKey('password'),
                    validator: (value) {
                      if (value.length > 7) {
                        return null;
                      } else {
                        return 'password must be atleast 8 characters';
                      }
                    },
                    decoration: InputDecoration(
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.remove_red_eye_outlined),
                          onPressed: () {
                            setState(() {
                              hidePass = !hidePass;
                            });
                          },
                        )),
                    obscureText: hidePass,
                    onSaved: (newValue) {
                      password = newValue;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RaisedButton(
                    child: isLogin ? Text('Login') : Text('Sign up'),
                    onPressed: trySubmit,
                  ),
                  FlatButton(
                    textColor: Theme.of(context).primaryColor,
                    child: isLogin
                        ? Text('Create account')
                        : Text('I already have an account'),
                    onPressed: () {
                      setState(() {
                        isLogin = !isLogin;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
