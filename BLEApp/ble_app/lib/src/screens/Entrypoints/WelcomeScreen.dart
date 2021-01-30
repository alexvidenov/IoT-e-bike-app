import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

import 'Mode.dart';

class Welcome extends StatelessWidget {
  final void Function(Mode mode) func;

  const Welcome({this.func});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WelcomeScreen(func: this.func),
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  final void Function(Mode mode) func;

  const WelcomeScreen({this.func});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xfffbb448), Color(0xffe46b10)])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTitle(),
            const SizedBox(
              height: 80,
            ),
            _createAccountButton(),
            const SizedBox(
              height: 20,
            ),
            _goOffline(),
            const SizedBox(
              height: 20,
            ),
            _description(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'Z',
          style: TextStyle(
              color: Colors.white, fontSize: 35, fontFamily: 'Europe_Ext'),
          children: [
            TextSpan(
              text: 'ec',
              style: TextStyle(
                  color: Colors.black, fontSize: 30, fontFamily: 'Europe_Ext'),
            ),
            TextSpan(
              text: 'otec',
              style: TextStyle(
                  color: Colors.black, fontSize: 30, fontFamily: 'Europe_Ext'),
            ),
          ]),
    );
  }

  Widget _createAccountButton() {
    return InkWell(
      onTap: () => widget.func(Mode.Account),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Color(0xffdf8e33).withAlpha(100),
                  offset: Offset(2, 4),
                  blurRadius: 8,
                  spreadRadius: 2)
            ],
            color: Colors.white),
        child: Text(
          'Create account',
          style: TextStyle(fontSize: 20, color: Color(0xfff7892b)),
        ),
      ),
    );
  }

  Widget _goOffline() {
    return InkWell(
      onTap: () async => await AwesomeDialog(
              context: context,
              useRootNavigator: true,
              buttonsBorderRadius: BorderRadius.all(Radius.circular(2)),
              headerAnimationLoop: false,
              animType: AnimType.BOTTOMSLIDE,
              title: 'Are you sure?',
              desc: 'Description',
              showCloseIcon: true,
              btnCancelOnPress: () {},
              btnOkOnPress: () => widget.func(Mode.Incognito),
              dismissOnBackKeyPress: true)
          .show(),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Text(
          'Skip account creation',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _description() {
    return Container(
        margin: EdgeInsets.only(top: 40, bottom: 20),
        child: Column(
          children: <Widget>[
            Text(
              'Some moto here',
              style: TextStyle(color: Colors.white, fontSize: 17),
            ),
            SizedBox(
              height: 20,
            ),
            Icon(Icons.bike_scooter, size: 90, color: Colors.white),
            // replace with our logo here
            SizedBox(
              height: 20,
            ),
            Text(
              'Learn more',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ));
  }
}
