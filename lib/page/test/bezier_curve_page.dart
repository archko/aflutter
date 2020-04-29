import 'package:AFlutter/widget/wave_progressbar.dart';
import 'package:flutter/material.dart';

class BezierCurvePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BezierCurvePageState();
  }

  @override
  String toStringShort() {
    return "贝塞尔曲线测试";
  }
}

class BezierCurvePageState extends State<BezierCurvePage> {
  final TextEditingController _controller = TextEditingController();

  //默认初始值为0.0
  double waterHeight = 0.0;
  WaterController waterController = WaterController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding widgetsBinding = WidgetsBinding.instance;
    widgetsBinding.addPostFrameCallback((callback) {
      //这里写你想要显示的百分比
      waterController.changeProgressRate(0.82);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("贝塞尔曲线测试"),
      ),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                "高度调整:    ",
                style: TextStyle(fontSize: 20.0),
              ),
              Container(
                width: 150.0,
                child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "请输入高度",
                    )),
              ),
              RaisedButton(
                onPressed: () {
                  print("waterHeight is ${_controller.toString()}");
                  FocusScope.of(context).requestFocus(FocusNode());
                  waterController
                      .changeProgressRate(double.parse(_controller.text));
                },
                child: Text("确定"),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 80.0),
            child: Center(
              child: WaveProgressBar(
                flowSpeed: 2.0,
                waveDistance: 45.0,
                waterColor: Color(0xFF68BEFC),
                waveHeight: 0.5,
                //strokeCircleColor: Color(0x50e16009),
                progressController: waterController,
                circleStrokeWidth: 2,
                strokeCircleColor: Colors.red,
                percentage: waterHeight,
                size: Size(300, 300),
                textStyle: TextStyle(
                    color: Color(0x15000000),
                    fontSize: 60.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
