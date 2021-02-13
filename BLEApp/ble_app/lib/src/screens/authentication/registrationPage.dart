import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:ble_app/src/blocs/authBloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class _Credentials {
  String userName = '';
  String password = '';
  String deviceSerialNumber = '';
}

class RegisterScreen extends StatelessWidget {
  final AuthBloc _auth;
  final Function toggleView;

  RegisterScreen(this._auth, {this.toggleView});

  @override
  Widget build(BuildContext context) => Scaffold(
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
              Text('   Account'),
            ],
          ),
        ),
        actions: [
          Row(
            children: [
              RaisedButton(
                  color: Colors.lightBlue,
                  onPressed: toggleView,
                  child: Text('LOGIN',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          letterSpacing: 2,
                          fontFamily: 'Europe_Ext'))),
              const Icon(Icons.arrow_forward)
            ],
          )
        ],
      ),
      body: Container(
        color: Colors.lightBlue,
        child: StepperBody(_auth),
      ));
}

class StepperBody extends StatefulWidget {
  final AuthBloc _authBloc;

  const StepperBody(this._authBloc);

  @override
  _StepperBodyState createState() => _StepperBodyState();
}

class _StepperBodyState extends State<StepperBody> {
  int currStep = 0;

  get _focusNodeUsername => FocusNode();

  get _focusNodeLastName => FocusNode();

  final List<String> _devicesList = [];

  final data = _Credentials();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  initState() {
    super.initState();
    _focusNodeUsername.addListener(() => setState(() => {}));
    _focusNodeLastName.addListener(() => setState(() => {}));
  }

  @override
  dispose() {
    _focusNodeUsername.dispose();
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
          state: currStep == 0 ? StepState.editing : StepState.indexed,
          content: TextFormField(
              focusNode: _focusNodeUsername,
              keyboardType: TextInputType.text,
              autocorrect: false,
              onSaved: (String value) {
                data.userName = value;
              },
              // onFieldSubmitted: () => set the currStep from here for convenience ,
              maxLines: 1,
              decoration: InputDecoration(
                  labelText: 'Enter your username',
                  icon: const Icon(Icons.person, color: Colors.white),
                  labelStyle: TextStyle(
                      decorationStyle: TextDecorationStyle.solid,
                      color: Colors.white,
                      fontSize: 16.0))),
        ),
        Step(
            title: const Text('Password',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 19.0)),
            isActive: currStep >= 3,
            state: currStep == 2 ? StepState.editing : StepState.indexed,
            content: TextFormField(
              keyboardType: TextInputType.visiblePassword,
              autocorrect: false,
              onSaved: (String value) {
                data.password = value;
              },
              maxLines: 1,
              decoration: InputDecoration(
                  labelText: 'Enter your password',
                  icon: const Icon(Icons.security, color: Colors.white),
                  labelStyle: TextStyle(
                      decorationStyle: TextDecorationStyle.solid,
                      color: Colors.white,
                      fontSize: 16.0)),
            )),
        Step(
            title: const Text('Device serial number',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 19.0)),
            isActive: currStep >= 4,
            state: currStep == 3 ? StepState.editing : StepState.indexed,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [..._getDeviceSerialNumberFields()],
            )),
      ];

  List<Widget> _getDeviceSerialNumberFields() {
    List<Widget> deviceFields = [];
    for (var index = 0; index < _devicesList.length; index++) {
      deviceFields.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                  controller: TextEditingController.fromValue(
                      TextEditingValue(text: _devicesList[index])),
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.white),
                  autocorrect: false,
                  onSaved: (String value) => _devicesList[index] = value,
                  maxLines: 1,
                  decoration: new InputDecoration(
                      labelText: 'Enter device number',
                      icon: const Icon(Icons.confirmation_number,
                          color: Colors.white),
                      labelStyle: new TextStyle(
                          decorationStyle: TextDecorationStyle.solid,
                          color: Colors.white,
                          fontSize: 16.0))),
            ),
            const SizedBox(
              width: 16,
            ),
            _addRemoveButton(index == _devicesList.length - 1, index),
          ],
        ),
      ));
    }
    return deviceFields;
  }

  Widget _addRemoveButton(bool add, int index) {
    return InkWell(
      onTap: () {
        if (add) {
          _devicesList.insert(0, null);
        } else
          _devicesList.removeAt(index);
        setState(() {});
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: (add) ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          (add) ? Icons.add : Icons.remove,
          color: Colors.white,
        ),
      ),
    );
  }

  void showSnackBarMessage(String message) =>
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(message)));

  void _showDialog() => AwesomeDialog(
      context: context,
      useRootNavigator: true,
      dialogType: DialogType.ERROR,
      animType: AnimType.SCALE,
      title: 'Failed',
      desc: 'The device does not exist. Try again',
      btnOkText: 'Yes',
      btnOkOnPress: () => {},
      btnCancelText: 'Cancel',
      btnCancelOnPress: () => {}).show();

  void _submitDetails() {
    final FormState formState = _formKey.currentState;
    //if (!formState.validate()) {
    //showSnackBarMessage('Invalid credentials');
    //} else {
    formState.save();
    widget._authBloc.signUpWithEmailAndPassword(
        // await the result here and if it returns the other thing that means the user didnt input the thing properly
        email: data.userName + '@gmail.com',
        password: data.password,
        deviceId: data.deviceSerialNumber);
    //}
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
            physics: ClampingScrollPhysics(),
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
              )),
        ]),
      ));
}
