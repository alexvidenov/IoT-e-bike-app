import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

import 'AuthAction.dart';

class Welcome extends StatelessWidget {
  final void Function(AuthAction mode) func;

  const Welcome({this.func});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WelcomeScreen(func: this.func),
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  final void Function(AuthAction mode) func;

  const WelcomeScreen({this.func});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image(
          image: AssetImage('assets/images/login_image.jpg'),
          fit: BoxFit.fill,
        ),
        Container(
          color: Colors.lightBlueAccent.withOpacity(0.6),
        ),
        SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 80,
                ),
                _buildTitle(),
                const SizedBox(
                  height: 20,
                ),
                _description(),
                const SizedBox(
                  height: 20,
                ),
                _createButtonForAction(
                    'Create account', () => widget.func(AuthAction.Register)),
                const SizedBox(
                  height: 20,
                ),
                _createButtonForAction('Already have an account?',
                    () => widget.func(AuthAction.Login)),
                const SizedBox(
                  height: 20,
                ),
                _createButtonForAction(
                  'Skip account creation',
                  () async => await AwesomeDialog(
                          context: context,
                          useRootNavigator: true,
                          buttonsBorderRadius:
                              BorderRadius.all(Radius.circular(2)),
                          headerAnimationLoop: false,
                          animType: AnimType.BOTTOMSLIDE,
                          title: 'Are you sure?',
                          desc: 'Description',
                          showCloseIcon: true,
                          btnCancelOnPress: () {},
                          btnOkOnPress: () => widget.func(AuthAction.Incognito),
                          dismissOnBackKeyPress: true)
                      .show(),
                ),
              ],
            ),
          ),
        )
      ],
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

  Widget _createButtonForAction(String action, Function onTap) => InkWell(
        onTap: () => onTap(),
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 13),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Text(
            '$action',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      );

  Widget _description() {
    return Container(
        margin: EdgeInsets.only(top: 40, bottom: 20),
        child: Column(
          children: <Widget>[
            Text(
              'Get power in your hands',
              style: TextStyle(
                  color: Colors.white, fontSize: 26, letterSpacing: 1.3),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ));
  }
}
