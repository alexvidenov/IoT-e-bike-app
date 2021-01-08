import 'package:ble_app/src/blocs/authBloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class _Credentials {
  String userName = '';
  String email = '';
  String password = '';
  String deviceSerialNumber = '';
}

class RegisterScreen extends StatelessWidget {
  final AuthBloc _auth;
  final Function toggleView;

  const RegisterScreen(this._auth, {this.toggleView});

  @override
  Widget build(BuildContext context) => MaterialApp(
      color: Colors.lightBlue,
      theme: ThemeData(fontFamily: 'Europe_Ext'),
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.lightBlue,
            title: Container(
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.account_circle,
                    size: 25.0,
                    color: Colors.white,
                  ),
                  Text('   Create account'),
                ],
              ),
            ),
            actions: [
              RaisedButton(
                  color: Colors.lightBlue,
                  onPressed: toggleView,
                  child: Text('LOGIN',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          letterSpacing: 2,
                          fontFamily: 'Europe_Ext')))
            ],
          ),
          body: Container(
            color: Colors.lightBlue,
            child: StepperBody(_auth),
          )));
}

class StepperBody extends StatefulWidget {
  final AuthBloc _authBloc;

  const StepperBody(this._authBloc);

  @override
  _StepperBodyState createState() => _StepperBodyState();
}

class _StepperBodyState extends State<StepperBody> {
  int currStep = 0;

  get _focusNode => FocusNode();

  get _focusNodeLastName => FocusNode();
  final data = _Credentials();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() => setState(() {}));
    _focusNodeLastName.addListener(() => setState(() {}));
  }

  @override
  dispose() {
    _focusNode.dispose();
    _focusNodeLastName.dispose();
    super.dispose();
  }

  List<Step> _steps() => [
        Step(
          title: const Text('Username',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 19.0)),
          isActive: currStep >= 1,
          state: StepState.indexed,
          content: TextFormField(
              focusNode: _focusNode,
              keyboardType: TextInputType.text,
              autocorrect: false,
              onSaved: (String value) {
                data.userName = value;
              },
              maxLines: 1,
              // ignore: missing_return
              validator: (value) {
                if (value.isEmpty || value.length < 1) {
                  return 'Please enter valid username';
                }
              },
              decoration: InputDecoration(
                  labelText: 'Enter your username',
                  icon: const Icon(Icons.person, color: Colors.white),
                  labelStyle: TextStyle(
                      decorationStyle: TextDecorationStyle.solid,
                      color: Colors.white,
                      fontSize: 16.0))),
        ),
        Step(
            title: const Text('Email',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 19.0)),
            isActive: currStep >= 2,
            state: StepState.indexed,
            content: TextFormField(
              focusNode: _focusNodeLastName,
              keyboardType: TextInputType.text,
              autocorrect: false,
              onSaved: (String value) {
                data.email = value;
              },
              maxLines: 1,
              // ignore: missing_return
              validator: (value) {
                if (value.isEmpty || !value.contains('@')) {
                  return 'Invalid email';
                }
              },
              decoration: InputDecoration(
                  labelText: 'Enter your email',
                  icon: const Icon(Icons.person, color: Colors.white),
                  labelStyle:
                      TextStyle(decorationStyle: TextDecorationStyle.solid)),
            )),
        Step(
            title: const Text('Password',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 19.0)),
            isActive: currStep >= 3,
            state: StepState.indexed,
            content: new TextFormField(
              keyboardType: TextInputType.visiblePassword,
              autocorrect: false,
              // ignore: missing_return
              validator: (value) {
                if (value.isEmpty || value.length < 10) {
                  return 'Password must be 10 or more characters';
                }
              },
              onSaved: (String value) {
                data.password = value;
              },
              maxLines: 1,
              decoration: new InputDecoration(
                  labelText: 'Enter your password',
                  icon: const Icon(Icons.phone, color: Colors.white),
                  labelStyle: new TextStyle(
                      decorationStyle: TextDecorationStyle.solid,
                      color: Colors.white,
                      fontSize: 16.0)),
            )),
        Step(
          title: const Text('Device number',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 19.0)),
          isActive: currStep >= 4,
          state: StepState.indexed,
          content: TextFormField(
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.white),
              autocorrect: false,
              validator: (value) {
                if (value.isEmpty || value.length < 3) {
                  return 'Please enter valid serial number';
                }
                return null;
              },
              onSaved: (String value) {
                data.deviceSerialNumber = value;
              },
              maxLines: 1,
              decoration: new InputDecoration(
                  labelText: 'Enter device number',
                  icon: const Icon(Icons.confirmation_number,
                      color: Colors.white),
                  labelStyle: new TextStyle(
                      decorationStyle: TextDecorationStyle.solid,
                      color: Colors.white,
                      fontSize: 16.0))),
        )
      ];

  showSnackBarMessage(String message) =>
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(message)));

  _submitDetails() {
    final FormState formState = _formKey.currentState;
    if (!formState.validate()) {
      showSnackBarMessage('Invalid credentials');
    } else {
      formState.save();
      widget._authBloc.signUpWithEmailAndPassword(
          email: data.email,
          password: data.password,
          deviceId: data.deviceSerialNumber);
    }
  }

  @override
  Widget build(BuildContext context) => Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF73AEF5),
            Color(0xFF61A4F1),
            Color(0xFF478DE0),
            Color(0xFF398AE5),
          ],
          stops: [0.1, 0.4, 0.7, 0.9],
        ),
      ),
      child: Form(
        key: _formKey,
        child: ListView(children: <Widget>[
          Stepper(
            steps: _steps(),
            type: StepperType.vertical,
            currentStep: this.currStep,
            onStepContinue: () => setState(() {
              if (currStep < _steps().length - 1) {
                currStep = currStep + 1;
              } else {
                _submitDetails();
              }
            }),
            onStepCancel: () => setState(
                () => currStep > 0 ? currStep = currStep - 1 : currStep = 0),
            onStepTapped: (step) => setState(() => currStep = step),
          ),
          Container(
              margin: EdgeInsets.all(10.0),
              child: OutlineButton(
                child: Text('Register'),
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                onPressed: _submitDetails,
              )
              //  Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new ProfileStep1()));
              ),
        ]),
      ));
}
