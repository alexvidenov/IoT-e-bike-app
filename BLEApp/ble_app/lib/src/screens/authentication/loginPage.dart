import 'package:ble_app/src/blocs/authBloc.dart';
import 'package:ble_app/src/sealedStates/authState.dart';
import 'package:flutter/material.dart';

const String title = "Zecotec";
const String noAccount = "Don't have an account?";
const Color kMainColor = Color(0xffFFFFFF);
const Color kSecondaryColor = Colors.lightBlueAccent;

Padding inputWidget(
    {String hintText,
    IconData primaryIcon,
    bool endIcon = false,
    IconData sufixIconData,
    void Function(String) onChanged}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextField(
      decoration: InputDecoration(
        suffixIcon: endIcon
            ? Icon(
                sufixIconData,
                color: kMainColor,
              )
            : null,
        hintText: hintText,
        hintStyle: TextStyle(color: kMainColor),
        icon: Icon(
          primaryIcon,
          color: kMainColor,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: kMainColor.withOpacity(0.8), width: 1),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: kMainColor, width: 1.5),
        ),
      ),
      onChanged: onChanged,
    ),
  );
}

Widget mainButton(IconData iconName, Function onPressed) {
  return Padding(
    padding: const EdgeInsets.only(top: 20.0),
    child: SizedBox(
      width: 180,
      height: 45,
      child: FlatButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          color: kSecondaryColor,
          onPressed: onPressed,
          child: Icon(
            iconName,
            color: kMainColor,
          )),
    ),
  );
}

class LoginScreen extends StatefulWidget {
  final AuthBloc _auth;
  final Function toggleView;

  const LoginScreen(this._auth, {this.toggleView});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();

  String _email;
  String _password;

  bool validateAndSave() {
    final FormState form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> validateAndSubmit() async {
    if (validateAndSave()) {
      await widget._auth
          .signInWithEmailAndPassword(email: _email, password: _password)
          .then((AuthState state) => state.when(
              authenticated: (auth) => {},
              failedToAuthenticate: (notAuthenticated) => _presentDialog(
                  context,
                  message: 'Auth failed',
                  additionalInformation: notAuthenticated.toString()),
              loggedOut: () => {},
              fetchingUserInformation: () => {}));
    }
  }

  Future<void> _presentDialog(BuildContext widgetContext,
      {String message, String additionalInformation}) async {
    await showDialog(
      context: widgetContext,
      builder: (context) => AlertDialog(
        title: Text(message),
        content: Text(additionalInformation),
        actions: <Widget>[
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Login'),
          actions: [
            RaisedButton(
                color: Colors.transparent,
                onPressed: widget.toggleView,
                child: Text('Register',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        letterSpacing: 2,
                        fontFamily: 'Europe_Ext'))),
            const Icon(Icons.arrow_forward)
          ],
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        extendBodyBehindAppBar: true,
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Image.network(
              "https://cdn.mos.cms.futurecdn.net/62L9uRGHNzpjYzvMEseSYH.jpg",
              // TODO: replace with some other image, this is test
              fit: BoxFit.fill,
            ),
            Container(
              color: kSecondaryColor.withOpacity(0.6),
            ),
            SingleChildScrollView(
              child: Form(
                key: this.formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                        height: height * 0.4,
                        alignment: Alignment.center,
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              text: 'Z',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 35,
                                  fontFamily: 'Europe_Ext'),
                              children: [
                                TextSpan(
                                  text: 'ec',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 30,
                                      fontFamily: 'Europe_Ext'),
                                ),
                                TextSpan(
                                  text: 'otec',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 30,
                                      fontFamily: 'Europe_Ext'),
                                ),
                              ]),
                        )),
                    inputWidget(
                        hintText: "Email",
                        primaryIcon: Icons.person_outline,
                        onChanged: (value) => this._email = value),
                    inputWidget(
                        hintText: "Password",
                        primaryIcon: Icons.vpn_key,
                        endIcon: true,
                        sufixIconData: Icons.help_outline,
                        onChanged: (value) => this._password = value),
                    mainButton(Icons.exit_to_app, () => validateAndSubmit()),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(noAccount,
                              style:
                                  TextStyle(color: kMainColor, fontSize: 16)),
                          FlatButton(
                              onPressed: () => widget.toggleView(),
                              child: Text(
                                "SignUp",
                                style: TextStyle(color: kMainColor),
                              ))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
