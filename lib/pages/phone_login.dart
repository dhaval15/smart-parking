import 'package:flutter/material.dart';
import 'package:smart_parking/pages/home.dart';
import 'package:smart_parking/ui/back.dart';
import 'package:smart_parking/ui/reporter.dart';
import 'package:smart_parking/api/phone_auth.dart';
import 'package:smart_parking/ui/style.dart';
import '../ui/brand.dart';

class PhoneAuth extends StatefulWidget {
  static final builder = MaterialPageRoute(builder: (context) => PhoneAuth());

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
    return LoginBackGround(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Align(
          alignment: Alignment(0, 0.70),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _buildFromStatus(status),
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
          errorText: error,
        ),
        onChanged: (text) {
          if (error != null)
            setState(() {
              error = null;
            });
        },
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
          errorText: error,
        ),
        onChanged: (text) {
          if (error != null)
            setState(() {
              error = null;
            });
        },
      ),
      SizedBox(height: 12),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Button(
            text: 'EDIT',
            onPressed: () {
              error = null;
              _smsCodeController.clear();
              _api.edit();
            },
          ),
          Button(
            text: 'VERIFY',
            onPressed: () {
              _api.verifyCode(_smsCodeController.text);
            },
          ),
        ],
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
                'Welcome ${snapshot.data}',
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
          Navigator.of(context).pushReplacement(Home.builder);
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
      SizedBox(height: 24),
      LoadingSpinner(),
    ];
  }

  @override
  void dispose() {
    super.dispose();
    _api.dispose();
  }

  void _onStatusChanged(PhoneAuthStatus status) {
    error = null;
    if (status == PhoneAuthStatus.successful) {
      Navigator.of(context).pushReplacement(Home.builder);
      return;
    }
    if (status == PhoneAuthStatus.invalidPhoneNumber) error = 'Invalid PhoneNo';
    if (status == PhoneAuthStatus.invalidCode) error = 'Invalid SMS Code';
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
