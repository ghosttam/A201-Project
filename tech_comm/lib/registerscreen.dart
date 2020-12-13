import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:tech_comm/loginscreen.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

final _formKey = GlobalKey<FormState>();

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _emcontroller = TextEditingController();
  final TextEditingController _phcontroller = TextEditingController();
  final TextEditingController _pscontroller = TextEditingController();
  final TextEditingController _psconfirmcontroller = TextEditingController();

  String _email = "";
  String _pass = "";
  String _name = "";
  String _phone = "";
  bool _passwordVisible = false;
  bool _passwordVisible2 = false;
  bool _rememberMe = false;
  bool _termsCondition = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Sign Up'),
      ),
      body: Container(
          child: Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Register Account",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: (25),
                              fontWeight: FontWeight.bold)),
                      Text(
                        "Complete your details",
                      ),
                      Image.asset(
                        'assets/images/techcomm.png',
                        scale: 2,
                      ),
                      TextFormField(
                          controller: _namecontroller,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            hintText: "Enter your Name",
                            hintStyle: TextStyle(fontSize: (12)),
                            labelStyle: TextStyle(color: Color(0XFF8B8B8B)),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 42,
                              vertical: 20,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide(
                                  color: Color(0XFF8B8B8B), width: 5.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide(color: Color(0XFF8B8B8B)),
                              gapPadding: 10,
                            ),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(
                                left: 30.0,
                                right: 20.0,
                              ),
                              child: SvgPicture.asset("assets/icons/User.svg",
                                  height: 25),
                            ),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter your name';
                            }

                            return null;
                          },
                          onSaved: (String name) {
                            _name = name;
                          }),
                      SizedBox(height: 10),
                      TextFormField(
                          controller: _emcontroller,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            hintText: "Enter your email",
                            hintStyle: TextStyle(fontSize: (12)),
                            labelStyle: TextStyle(color: Color(0XFF8B8B8B)),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 42,
                              vertical: 20,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide(
                                  color: Color(0XFF8B8B8B), width: 5.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide(color: Color(0XFF8B8B8B)),
                              gapPadding: 10,
                            ),
                            suffixIcon: Padding(
                              padding: EdgeInsets.all(20),
                              child: SvgPicture.asset("assets/icons/Mail.svg",
                                  height: 20),
                            ),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter email';
                            }
                            if (!RegExp(
                                    r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value)) {
                              return "Please enter valid email";
                            }
                            return null;
                          },
                          onSaved: (String email) {
                            _email = email;
                          }),
                      SizedBox(height: 10),
                      TextFormField(
                          controller: _phcontroller,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: 'Mobile',
                            hintText: "Enter your phone",
                            hintStyle: TextStyle(fontSize: (12)),
                            labelStyle: TextStyle(color: Color(0XFF8B8B8B)),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 42,
                              vertical: 20,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide(
                                  color: Color(0XFF8B8B8B), width: 5.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide(color: Color(0XFF8B8B8B)),
                              gapPadding: 10,
                            ),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(
                                left: 30.0,
                                right: 25.0,
                              ),
                              child: SvgPicture.asset("assets/icons/Phone.svg",
                                  height: 30),
                            ),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter phone';
                            }
                            if (value.length < 10) {
                              return 'Please enter valid phone';
                            }
                            return null;
                          },
                          onSaved: (String phone) {
                            _phone = phone;
                          }),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _pscontroller,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: "Enter your password",
                          labelStyle: TextStyle(
                            color: Color(0XFF8B8B8B),
                          ),
                          hintStyle: TextStyle(fontSize: (12)),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 42,
                            vertical: 20,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide(
                                color: Color(0XFF8B8B8B), width: 5.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide(color: Color(0XFF8B8B8B)),
                            gapPadding: 10,
                          ),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(
                              left: 30.0,
                              right: 10.0,
                            ),
                            child: IconButton(
                              icon: Icon(
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Theme.of(context).primaryColorDark,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                          ),
                        ),
                        obscureText: _passwordVisible,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter password';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _psconfirmcontroller,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          hintText: "Re-enter your password",
                          labelStyle: TextStyle(
                            color: Color(0XFF8B8B8B),
                          ),
                          hintStyle: TextStyle(fontSize: (12)),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 42,
                            vertical: 20,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide(
                                color: Color(0XFF8B8B8B), width: 5.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide(color: Color(0XFF8B8B8B)),
                            gapPadding: 10,
                          ),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(
                              left: 30.0,
                              right: 10.0,
                            ),
                            child: IconButton(
                              icon: Icon(
                                _passwordVisible2
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Theme.of(context).primaryColorDark,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible2 = !_passwordVisible2;
                                });
                              },
                            ),
                          ),
                        ),
                        obscureText: _passwordVisible2,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please re-enter password';
                          }
                          if (_pscontroller.text != _psconfirmcontroller.text) {
                            return 'Password does not match';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: <Widget>[
                          Checkbox(
                            value: _rememberMe,
                            onChanged: (bool value) {
                              _onChange(value);
                            },
                          ),
                          Text('Remember Me', style: TextStyle(fontSize: 14))
                        ],
                      ),
                      FormField<bool>(
                        builder: (state) {
                          return Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Checkbox(
                                    value: _termsCondition,
                                    onChanged: (bool value) {
                                      _onTick(value);
                                      state.didChange(value);
                                    },
                                  ),
                                  Text("I agree to the ",
                                      style: TextStyle(fontSize: 14)),
                                  GestureDetector(
                                      onTap: _showEULA,
                                      child: Text('Terms and Conditions',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.amber[800]))),
                                ],
                              ),
                              Text(state.errorText ?? '',
                                  style: TextStyle(
                                      color: Theme.of(context).errorColor))
                            ],
                          );
                        },
                        validator: (value) {
                          if (!_termsCondition) {
                            return 'You need to agree the Terms and Conditions';
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(height: 10),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        minWidth: 300,
                        height: 50,
                        child:
                            Text('Register', style: TextStyle(fontSize: (16))),
                        color: Colors.amber,
                        textColor: Colors.black,
                        elevation: 10,
                        onPressed: _openDialog,
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                          onTap: _onLogin,
                          child: Text('Already register',
                              style: TextStyle(fontSize: 14))),
                      SizedBox(height: 50),
                    ],
                  ),
                ),
              ))),
    );
  }

  void _onRegister() async {
    Navigator.pop(context);
    if (_formKey.currentState.validate()) {
      _name = _namecontroller.text;
      _email = _emcontroller.text;
      _pass = _pscontroller.text;
      _phone = _phcontroller.text;

      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Registration...");
      await pr.show();
      http.post("https://steadybongbibi.com/techcomm/php/register_user.php",
          body: {
            "name": _name,
            "email": _email,
            "phone": _phone,
            "password": _pass,
          }).then((res) {
        print(res.body);

        if (res.body == "success") {
          Toast.show(
            "Registration Success, Please check your email to verify your account",
            context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.TOP,
          );
          if (_rememberMe) {
            savepref();
          }
          _onLogin();
        }
      }).catchError((err) {
        print(err);
      });
      await pr.hide();
    } else {
      Toast.show(
        "Registration Failed",
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.TOP,
      );
    }
  }

  void _onLogin() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
  }

  void _onChange(bool value) {
    setState(() {
      _rememberMe = value;
    });
  }

  void savepref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _email = _emcontroller.text;
    _pass = _pscontroller.text;
    await prefs.setString('email', _email);
    await prefs.setString('password', _pass);
    await prefs.setBool('rememberme', true);
  }

  void _openDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(
            "Confirmation Message",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          content: new Text(
            "Are you sure your information is correct? ",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onPressed: () {
                _onRegister();
              },
            ),
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _onTick(bool value) {
    setState(() {
      _termsCondition = value;
    });
  }

  void _showEULA() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(
            "End-user License Agreement",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          content: SingleChildScrollView(
            child: new Text(
              "End-User License Agreement (Agreement) Last updated: December 09, 2020 Please read this End-User License Agreement carefully before clicking the I Agree button, downloading or using TechComm. Interpretation and Definitions Interpretation The words of which the initial letter is capitalized have meanings defined under the following conditions. The following definitions shall have the same meaning regardless of whether they appear in singular or in plural. Definitions For the purposes of this End-User License Agreement: Agreement means this End-User License Agreement that forms the entire agreement between You and the Company regarding the use of the Application. This Agreement has been created with the help of the EULA Generator. Application means the software program provided by the Company downloaded by You to a Device, named TechComm Company (referred to as either the Company, We, Us or Our in this Agreement) refers to TechComm. Content refers to content such as text, images, or other information that can be posted, uploaded, linked to or otherwise made available by You, regardless of the form of that content. Country refers to: Malaysia Device means any device that can access the Application such as a computer, a cellphone or a digital tablet.",
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.black,
              ),
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text(
                "Close",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
