import 'package:flutter/material.dart';
import 'package:smart_parking/pages/home.dart';
import 'package:smart_parking/ui/brand.dart';
import 'package:smart_parking/ui/reporter.dart';
import 'package:smart_parking/api/phone_auth.dart';
import 'package:smart_parking/ui/style.dart';

class PhoneAuth extends StatefulWidget {
  @override
  PhoneAuthState createState() => PhoneAuthState();
}

class PhoneAuthState extends State<PhoneAuth> {
  final _phoneNumberController = TextEditingController();
  final _smsCodeController = TextEditingController();
  final _displayController = TextEditingController();

  final _api = PhoneAuthAPI();

  PhoneAuthStatus status = PhoneAuthStatus.initial;
  String error;

  @override
  void initState() {
    super.initState();
    _api.stream.listen(_onStatusChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: EdgeInsets.all(12),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Hero(
                  tag: 'icon',
                  child:
                      Icon(Icons.directions_car, size: 96, color: Colors.white),
                ),
                Card(
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: _buildFromStatus(status),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFromStatus(PhoneAuthStatus status) {
    switch (status) {
      case PhoneAuthStatus.initial:
      case PhoneAuthStatus.invalidPhoneNumber:
        return _phoneBody();
      case PhoneAuthStatus.sendingCode:
        return _loadingIndicatorBody('Sending OTP To');
      case PhoneAuthStatus.codeSent:
      case PhoneAuthStatus.invalidCode:
        return _smsCodeBody();
      case PhoneAuthStatus.verifyingCode:
        return _loadingIndicatorBody('Verifying OTP');
      case PhoneAuthStatus.displayName:
        return _displayNameBody();
      case PhoneAuthStatus.updatingDisplayName:
        return _loadingIndicatorBody('Just A Minute');
      case PhoneAuthStatus.welcome:
        return _welcomeBody();
      default:
        return [BugReporter()];
    }
  }

  List<Widget> _phoneBody() {
    return [
      TextField(
        controller: _phoneNumberController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Phone No',
        ),
      ),
      SizedBox(height: 12),
      Button(
        text: 'Send Code',
        onPressed: () {
          _api.sendCode('+91${_phoneNumberController.text}');
        },
      ),
    ];
  }

  List<Widget> _smsCodeBody() {
    return [
      TextField(
        controller: _smsCodeController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'SMS Code',
        ),
      ),
      SizedBox(height: 12),
      Button(
        text: 'Verify',
        onPressed: () {
          _api.verifyCode(_smsCodeController.text);
        },
      ),
    ];
  }

  List<Widget> _displayNameBody() {
    return [
      TextField(
        controller: _displayController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Display Name',
        ),
      ),
      SizedBox(height: 12),
      Button(
        text: 'Submit',
        onPressed: () {
          _api.updateDisplayName(_displayController.text);
        },
      ),
    ];
  }

  List<Widget> _welcomeBody() {
    return [
      FutureBuilder<String>(
        future: _api.displayName,
        builder: (context, snapshot) => snapshot.hasData
            ? Text(
                'Welcome ${_api.user.displayName}',
                style: TextStyle(
                  fontSize: 18,
                  color: colors[1],
                  fontWeight: FontWeight.w600,
                ),
              )
            : SizedBox(height: 20),
      ),
      SizedBox(height: 24),
      IconButton(
        icon: Icon(
          Icons.navigate_next,
          size: 48,
          color: colors[1],
        ),
        onPressed: () {
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) => Home()));
        },
      ),
    ];
  }

  List<Widget> _loadingIndicatorBody(String message) {
    return [
      Text(
        message,
        style: TextStyle(fontSize: 18, color: colors[1]),
      ),
      SizedBox(height: 12),
      LoadingSpinner(),
    ];
  }

  @override
  void dispose() {
    super.dispose();
    _api.dispose();
  }

  void _onStatusChanged(PhoneAuthStatus status) {
    if (status == PhoneAuthStatus.successful) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => Home()));
    }
    setState(() {
      this.status = status;
    });
  }
}

class Button extends StatelessWidget {
  final GestureTapCallback onPressed;

  final String text;

  const Button({this.onPressed, this.text});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(
        text,
        style: TextStyle(color: colors[1]),
      ),
      onPressed: onPressed,
    );
  }
}
