import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tech_comm/Admin/adminmerchant.dart';
import 'adminmainscreen.dart';
import 'adminregisterscreen.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

//import 'mainscreen.dart';

class AdminLoginScreen extends StatefulWidget {
  @override
  _AdminLoginScreenState createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final TextEditingController _emcontroller = TextEditingController();
  String _email = "";
  final TextEditingController _pscontroller = TextEditingController();
  String _password = "";
  bool _rememberMe1 = false;
  bool _passwordVisibleLogin = true;
  SharedPreferences prefs;
  double screenHeight, screenWidth;
  @override
  void initState() {
    loadpref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('Sign In'),
          ),

          //resizeToAvoidBottomPadding: false,
          body: new Container(
            padding: const EdgeInsets.only(
              left: 30.0,
              right: 30.0,
            ),
            child: SingleChildScrollView(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Welcome Back",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: (25),
                        fontWeight: FontWeight.bold)),
                Text(
                  "Sign in with your email and password",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Image.asset(
                  'assets/images/techcommmerc.png',
                  scale: 2,
                ),
                SizedBox(height: 2),
                TextFormField(
                    controller: _emcontroller,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: ('Email'),
                      hintText: ("Enter your email"),
                      hintStyle: TextStyle(fontSize: (12)),
                      labelStyle: TextStyle(color: Color(0XFF8B8B8B)),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 42,
                        vertical: 20,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide:
                            BorderSide(color: Color(0XFF8B8B8B), width: 5.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(color: Color(0XFF8B8B8B)),
                        gapPadding: 10,
                      ),
                      suffixIcon: Padding(
                        padding: EdgeInsets.only(
                          right: 20.0,
                        ),
                        child: SvgPicture.asset("assets/icons/Mail.svg",
                            height: 20),
                      ),
                    )),
                SizedBox(height: 10),
                TextFormField(
                  controller: _pscontroller,
                  decoration: InputDecoration(
                    labelText: ('Password'),
                    hintText: ("Enter your password"),
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
                      borderSide:
                          BorderSide(color: Color(0XFF8B8B8B), width: 5.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide(color: Color(0XFF8B8B8B)),
                      gapPadding: 10,
                    ),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(
                        right: 10.0,
                      ),
                      child: IconButton(
                        icon: Icon(
                          _passwordVisibleLogin
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Theme.of(context).primaryColorDark,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisibleLogin = !_passwordVisibleLogin;
                          });
                        },
                      ),
                    ),
                  ),
                  obscureText: _passwordVisibleLogin,
                ),
                SizedBox(
                  height: 10,
                ),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  minWidth: 295,
                  height: 50,
                  child: Text('Login', style: TextStyle(fontSize: (16))),
                  color: Colors.amber,
                  textColor: Colors.black,
                  elevation: 10,
                  onPressed: _onLogin,
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: <Widget>[
                    Checkbox(
                      value: _rememberMe1,
                      onChanged: (bool value1) {
                        _onChange(value1);
                      },
                    ),
                    Text('Remember Me', style: TextStyle(fontSize: 16)),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text("Interested to become a seller?",
                      style: TextStyle(fontSize: 14)),
                  GestureDetector(
                      onTap: _onRegister,
                      child: Text(' Register Now',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber[800]))),
                ]),
                SizedBox(height: 50),
              ],
            )),
          )),
    );
  }

  Future<void> _onLogin() async {
    _email = _emcontroller.text;
    _password = _pscontroller.text;
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Login...");
    await pr.show();
    http.post("https://steadybongbibi.com/techcomm/php/login_merchant.php",
        body: {
          "email": _email,
          "password": _password,
        }).then((res) {
      print(res.body);
      List userdata = res.body.split(",");
      if (userdata[0] == "success") {
        AdminMerchant merchant = new AdminMerchant(
          mercid: userdata[1],
          mercemail: _email,
          mercname: userdata[2],
          merclocation: userdata[5],
          mercphone: userdata[4],
          mercimage: userdata[6],
          mercdatereg: userdata[7],
          merclatitude: userdata[8],
          merclongitude: userdata[9],
          mercradius: userdata[10],
          mercdelivery: userdata[11],
        );
        Toast.show(
          "Login Success",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => MainScreen(
                      merc: merchant,
                    )));
      } else {
        Toast.show(
          "Login failed",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
      }
    }).catchError((err) {
      print(err);
    });
    await pr.hide();
  }

  void _onRegister() {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => RegisterScreen()));
  }

  void _onChange(bool value) {
    setState(() {
      _rememberMe1 = value;
      savepref(value);
    });
  }

  void loadpref() async {
    prefs = await SharedPreferences.getInstance();
    _email = (prefs.getString('email')) ?? '';
    _password = (prefs.getString('password')) ?? '';
    _rememberMe1 = (prefs.getBool('rememberme')) ?? false;
    if (_email.isNotEmpty) {
      setState(() {
        _emcontroller.text = _email;
        _pscontroller.text = _password;
        _rememberMe1 = _rememberMe1;
      });
    }
  }

  void savepref(bool value) async {
    prefs = await SharedPreferences.getInstance();
    _email = _emcontroller.text;
    _password = _pscontroller.text;

    if (value) {
      if (_email.length < 5 && _password.length < 3) {
        print("EMAIL/PASSWORD EMPTY");
        _rememberMe1 = false;
        Toast.show(
          "Email/password empty!!!",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
        );
        return;
      } else {
        await prefs.setString('email', _email);
        await prefs.setString('password', _password);
        await prefs.setBool('rememberme', value);
        Toast.show(
          "Preferences saved",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
        );
        print("SUCCESS");
      }
    } else {
      await prefs.setString('email', '');
      await prefs.setString('password', '');
      await prefs.setBool('rememberme', false);
      setState(() {
        _emcontroller.text = "";
        _pscontroller.text = "";
        _rememberMe1 = false;
      });
      Toast.show(
        "Preferences removed",
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.BOTTOM,
      );
    }
  }
}
