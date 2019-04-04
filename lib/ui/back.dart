import 'package:flutter/material.dart';
import 'package:smart_parking/ui/brand.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

void main() => runApp(WaveDemoApp());

class WaveDemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wave Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WaveDemoHomePage(title: 'Wave Demo'),
    );
  }
}

class WaveDemoHomePage extends StatefulWidget {
  WaveDemoHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _WaveDemoHomePageState createState() => _WaveDemoHomePageState();
}

class _WaveDemoHomePageState extends State<WaveDemoHomePage> {
  _buildCard({Config config, Color backgroundColor = Colors.transparent}) {
    return Container(
      height: 152.0,
      width: double.infinity,
      child: Card(
        elevation: 12.0,
        margin: EdgeInsets.only(right: 16.0, left: 16.0, bottom: 16.0),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0))),
        child: WaveWidget(
          config: config,
          backgroundColor: backgroundColor,
          size: Size(double.infinity, double.infinity),
          waveAmplitude: 0,
        ),
      ),
    );
  }

  MaskFilter _blur;
  final List<MaskFilter> _blurs = [
    null,
    MaskFilter.blur(BlurStyle.normal, 10.0),
    MaskFilter.blur(BlurStyle.inner, 10.0),
    MaskFilter.blur(BlurStyle.outer, 10.0),
    MaskFilter.blur(BlurStyle.solid, 16.0),
  ];
  int _blurIndex = 0;

  MaskFilter _nextBlur() {
    if (_blurIndex == _blurs.length - 1) {
      _blurIndex = 0;
    } else {
      _blurIndex = _blurIndex + 1;
    }
    _blur = _blurs[_blurIndex];
    return _blurs[_blurIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 10.0,
        backgroundColor: Colors.blueGrey[800],
        actions: <Widget>[
          IconButton(
            icon: Icon(_blur == null ? Icons.blur_off : Icons.blur_on),
            onPressed: () {
              setState(() {
                _blur = _nextBlur();
              });
            },
          )
        ],
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            SizedBox(height: 16.0),
            _buildCard(
              config: CustomConfig(
                gradients: [
                  [Colors.red, Color(0xEEF44336)],
                  [Colors.red[800], Color(0x77E57373)],
                  [Colors.orange, Color(0x66FF9800)],
                  [Colors.yellow, Color(0x55FFEB3B)]
                ],
                durations: [35000, 19440, 10800, 6000],
                heightPercentages: [0.20, 0.23, 0.25, 0.30],
                blur: _blur,
                gradientBegin: Alignment.bottomLeft,
                gradientEnd: Alignment.topRight,
              ),
            ),
            _buildCard(
              config: CustomConfig(
                colors: [
                  Colors.pink[400],
                  Colors.pink[300],
                  Colors.pink[200],
                  Colors.pink[100]
                ],
                durations: [35000, 19440, 10800, 6000],
                heightPercentages: [0.20, 0.23, 0.25, 0.30],
                blur: _blur,
              ),
            ),
            _buildCard(
                config: CustomConfig(
                  colors: [
                    Colors.white70,
                    Colors.white54,
                    Colors.white30,
                    Colors.white24,
                  ],
                  durations: [20000, 11000, 8000, 5000],
                  heightPercentages: [0.24, 0.27, 0.29, 0.31],
                  blur: _blur,
                ),
                backgroundColor: Colors.blue[600]),
          ],
        ),
      ),
    );
  }
}

class LoginBackGround extends StatelessWidget {
  final Widget child;

  const LoginBackGround({this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            WaveWidget(
              config: CustomConfig(
                colors: [
                  Colors.white70,
                  Colors.white54,
                  Colors.white30,
                  Colors.white24,
                ],
                durations: [9000, 11000, 8000, 5000],
                heightPercentages: [0.38, 0.41, 0.43, 0.45],
                blur: MaskFilter.blur(BlurStyle.solid, 0),
              ),
              backgroundColor: Colors.blue[600],
              size: Size(double.infinity, double.infinity),
              waveAmplitude: 0,
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: Center(
                      child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Logo(),
                      SizedBox(height: 12),
                      AppTitle(),
                    ],
                  )),
                ),
                Flexible(
                  flex: 1,
                  child: child,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
