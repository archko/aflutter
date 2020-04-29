import 'dart:math' as math;
import 'dart:ui';

import 'package:AFlutter/utils/screen_utils.dart';
import 'package:AFlutter/widget/painter/bessel_view_painter.dart';
import 'package:flutter/material.dart';

class TestPaintPage extends StatefulWidget {
  TestPaintPage({
    Key key,
  }) : super(key: key);

  @override
  _TestPaintPageState createState() => new _TestPaintPageState();

  @override
  String toStringShort() {
    return "TestPaint";
  }
}

class _TestPaintPageState extends State<TestPaintPage>
    with TickerProviderStateMixin {
  AnimationController _animationController1;
  AnimationController _animationController2;
  AnimationController _animationController3;

  AnimationController _animatedContainer;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController1 =
        AnimationController(duration: Duration(seconds: 2), vsync: this)
          ..addListener(() {
            setState(() {});
          })
          ..repeat();

    _animationController2 =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              //按钮过渡动画完成后启动录制视频的进度条动画
              _animationController3.forward();
            }
          });
    //第二个控制器
    _animationController3 =
        AnimationController(duration: Duration(seconds: 8), vsync: this)
          ..addListener(() {
            setState(() {});
          });

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
    _animationController1?.dispose();
    _animationController3?.dispose();
    _animationController2?.dispose();

    _animatedContainer.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(
      //  title: Text("Painter&Animation"),
      //),
      body: buildCustom(),
    );
  }

  Widget buildCustomPaint1() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 200,
            height: 200,
            color: Colors.red,
            alignment: Alignment.center,
            child: CustomPaint(
              painter: CirclePainter1(progress: _animationController1.value),
              size: Size(150, 150),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            width: 200,
            height: 200,
            color: Colors.black,
            alignment: Alignment.center,
            child: GestureDetector(
              onLongPress: () {
                _animationController2.forward();
              },
              onLongPressUp: () {
                _animationController2.reverse();

                _animationController3.value = 0;

                _animationController3.stop();
              },
              child: CustomPaint(
                painter: WeChatShotVideoBtn(
                    _animationController2.value, _animationController3.value),
                size: Size(100, 100),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCustomPaint2() {
    return Column(
      children: <Widget>[
        ClipPath(
          //路径裁切组件
          clipper: BottomClipper(), //路径
          child: Container(
            color: Colors.deepOrangeAccent,
            height: 200.0,
          ),
        ),
      ],
    );
  }

  Widget buildCustomPaint3() {
    return Column(
      children: <Widget>[
        CustomPaint(
          painter: BesselViewPainter(
              radius: 24, percent: 20, isToRight: true, color: Colors.red),
          size: Size(150, 150),
        ),
      ],
    );
  }

  Widget buildCustom() {
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

class BottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    //path.lineTo(0, 0); //第1个点
    //path.lineTo(0, size.height - 50.0); //第2个点
    //var firstControlPoint = Offset(size.width / 2, size.height);
    //var firstEdnPoint = Offset(size.width, size.height - 50.0);
    //path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
    //    firstEdnPoint.dx, firstEdnPoint.dy);
    //path.lineTo(size.width, size.height - 50.0); //第3个点
    //path.lineTo(size.width, 0); //第4个点

    //波浪曲线路径
    path.lineTo(0, 0); //第1个点
    path.lineTo(0, size.height - 40.0); //第2个点
    var firstControlPoint = Offset(size.width / 4, size.height); //第一段曲线控制点
    var firstEndPoint = Offset(size.width / 2.25, size.height - 30); //第一段曲线结束点
    path.quadraticBezierTo(
        //形成曲线
        firstControlPoint.dx,
        firstControlPoint.dy,
        firstEndPoint.dx,
        firstEndPoint.dy);

    var secondControlPoint =
        Offset(size.width / 4 * 3, size.height - 90); //第二段曲线控制点
    var secondEndPoint = Offset(size.width, size.height - 40); //第二段曲线结束点
    path.quadraticBezierTo(
        //形成曲线
        secondControlPoint.dx,
        secondControlPoint.dy,
        secondEndPoint.dx,
        secondEndPoint.dy);

    path.lineTo(size.width, size.height - 40);
    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class CirclePainter1 extends CustomPainter {
  Paint _paint = Paint()
    ..style = PaintingStyle.fill
    ..color = Colors.greenAccent;

  final double progress;

  CirclePainter1({this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final double center = size.width * 0.5;
    final double radius = size.width * 0.5;

    // 圆的中心点位置
    final Offset centerOffset = Offset(center, center);
    final Rect rect = Rect.fromCircle(center: centerOffset, radius: radius);
    final double startAngle = 0;
    final double angle = 360.0 * progress;
    final double sweepAngle = (angle * (math.pi / 180.0));

    // 画圆弧 按照角度来画圆弧，后面看效果图会发现起点从0开始画的时候是3点钟方向开始的
    canvas.drawArc(rect, startAngle, sweepAngle, true, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class WeChatShotVideoBtn extends CustomPainter {
  final double firstProgress;

  //第一段动画控制值，值范围[0,1]
  final double secondProgress;

  //第二段动画控制值，值范围[0,1]
  //主按钮的颜色
  final Color buttonColor = Colors.white;

  //进度条相关参数
  final double progressWidth = 5;

  //进度条 宽度
  final Color progressColor = Colors.green;

  //进度条颜色
  final back90 = deg2Rad(-90.0);

  //往前推90度 从12点钟方向开始
  //主按钮背后一层的颜色，也是progress绘制时的背景色
  Color progressBackgroundColor;

  //背景圆的画笔
  Paint backGroundPaint;

  //主按钮画笔
  Paint btnPaint;

  //进度条画笔
  Paint progressPaint;

  WeChatShotVideoBtn(this.firstProgress, this.secondProgress) {
    progressBackgroundColor = buttonColor.withOpacity(0.7);

    //初始化画笔
    backGroundPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = progressBackgroundColor;

    btnPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = buttonColor;

    progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = progressColor
      ..strokeWidth = progressWidth;
  }

  @override
  void paint(Canvas canvas, Size size) {
    //初始化的圆半径，就是在动画开始前的圆半径
    final double initRadius = size.width * 0.5;

    // 底部最大的圆
    final double center = size.width * 0.5;

    //圆心
    final Offset circleCenter = Offset(center, center);

    //设置背景圆半径，让背景圆的半径随着动画控制值的变化，此处变为按钮圆半径的1.5倍
    final double backGroundRadius = initRadius * (1 + (firstProgress / 2));

    //画背景圆
    canvas.drawCircle(circleCenter, backGroundRadius, backGroundPaint);

    // 按钮圆，按钮圆初始半径刚开始时应减去 进度条的宽度，在长按时按钮圆半径变小
    final double initBtnCircleRadius = initRadius - progressWidth;

    //长按时，按钮圆半径根据动画变为初始按钮圆的1/2倍
    final double circleRadius = initBtnCircleRadius * (1 / (1 + firstProgress));

    //画按钮圆
    canvas.drawCircle(circleCenter, circleRadius, btnPaint);

    // 第二阶段，进度条的绘制，表示第二阶段动画启动
    if (secondProgress > 0) {
      //secondProgress 值转化为度数
      final double angle = 360.0 * secondProgress;

      //角度转化为弧度
      final double sweepAngle = deg2Rad(angle);
      final double progressCircleRadius = backGroundRadius - progressWidth;
      final Rect arcRect =
          Rect.fromCircle(center: circleCenter, radius: progressCircleRadius);

      //这里画弧度的时候它默认起点是从3点钟方向开始
      // 所以这里的开始角度向前调整90度让它从12点钟方向开始画弧
      canvas.drawArc(arcRect, back90, sweepAngle, false, progressPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

//角度转弧度

num deg2Rad(num deg) => deg * (math.pi / 180.0);
