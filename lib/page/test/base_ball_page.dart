import 'package:AFlutter/utils/screen_utils.dart';
import 'package:AFlutter/widget/painter/bessel_view_painter.dart';
import 'package:flutter/material.dart';

class BaseBallPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop()),
        title: Text("波浪球"),
      ),
      body: _DemonstrateView(),
    );
  }

  @override
  String toStringShort() {
    return "波浪球";
  }
}

class _DemonstrateView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DemonstrateState();
  }
}

class _DemonstrateState extends State<_DemonstrateView>
    with SingleTickerProviderStateMixin {
  AnimationController _animatedContainer;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animatedContainer = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _animation = Tween(begin: 0.0, end: 1.0).animate(_animatedContainer)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _animatedContainer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(_animation.value.toString());

    return Container(
      width: ScreenUtils.getDeviceWidth(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            color: Colors.blueAccent,
            padding: const EdgeInsets.only(left: 30, top: 30),
            child: CustomPaint(
              size: Size(180, 90),
              painter: BesselViewPainter(
                  radius: 30,
                  percent: _animation.value,
                  isToRight: true,
                  color: Colors.deepOrange),
            ),
          ),
          Container(
            color: Colors.amber,
            padding: const EdgeInsets.only(left: 120, top: 30),
            child: CustomPaint(
              size: Size(90, 90),
              painter: BesselViewPainter(
                  radius: 30,
                  percent: _animation.value,
                  isToRight: false,
                  color: Colors.cyan),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: OutlineButton(
                child: Text(
                  "轮播图指示器",
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
                onPressed: () => _animatedContainer.forward()),
          )
        ],
      ),
    );
  }
}
