import 'dart:math';
import 'dart:ui';

import 'package:AFlutter/widget/painter/bezier_curve_painter.dart';
import 'package:AFlutter/widget/wave_picture_generator.dart';
import 'package:flutter/material.dart';

class WaterController {
  WaveProgressBarState bezierCurveState;

  void changeProgressRate(double h) {
    if (bezierCurveState != null) {
      bezierCurveState.changeWaterHeight(h);
    }
  }
}

class WaveProgressBar extends StatefulWidget {
  /// size	设置控件大小
  //percentage	进度条百分比，double形式的百分比， 即0.2就是20%
  //waveHeight	浪高，千万别把这个和percentage搞混了，这只是浪高，不代表进度
  //textStyle	中间显示的文字
  //waveDistance	浪的间距  这里是设置1/4浪距 
  //flowSpeed	浪的速度
  //waterColor	水的颜色
  //strokeCircleColor	外面那个空心圆的颜色
  //circleStrokeWidth	空心圆的宽度
  //heightController	进度控制器
  WaveProgressBar({
    Key key,
    this.percentage,
    this.size,
    this.waveDistance,
    this.waveHeight,
    this.waterColor,
    this.flowSpeed,
    this.textStyle,
    this.circleStrokeWidth,
    this.strokeCircleColor,
    this.progressController,
  }) : super(key: key);
  final double percentage;
  final Size size;
  final double waveDistance;
  final double waveHeight;
  final Color waterColor;
  final double flowSpeed;
  final TextStyle textStyle;
  final double circleStrokeWidth;
  final Color strokeCircleColor;
  final WaterController progressController;

  @override
  WaveProgressBarState createState() => WaveProgressBarState();
}

class WaveProgressBarState extends State<WaveProgressBar>
    with SingleTickerProviderStateMixin {
  double _moveForwardDark = 0.0;
  double _moveForwardLight = 0.0;
  double _waterHeight;
  double _percentage;
  Animation<double> animation;
  AnimationController animationController;
  VoidCallback _voidCallback;
  Random _random = Random();
  Picture _lightWavePic;
  Picture _darkWavePic;

  @override
  void dispose() {
    animationController.stop();
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _percentage = widget.percentage;
    _waterHeight = (1 - _percentage) * widget.size.height;
    widget.progressController.bezierCurveState = this;
    WavePictureGenerator generator = WavePictureGenerator(
        widget.size, widget.waveDistance, widget.waveHeight, widget.waterColor);
    _lightWavePic = generator.drawLightWave();
    _darkWavePic = generator.drawDarkWave();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 3000), vsync: this);

    WidgetsBinding widgetsBinding = WidgetsBinding.instance;
    widgetsBinding.addPostFrameCallback((callback) {
      widgetsBinding.addPersistentFrameCallback((callback) {
        if (mounted) {
          setState(() {
            _moveForwardDark =
                _moveForwardDark - widget.flowSpeed - _random.nextDouble() - 1;
            if (_moveForwardDark <= -widget.waveDistance * 4) {
              _moveForwardDark = _moveForwardDark + widget.waveDistance * 4;
            }

            _moveForwardLight =
                _moveForwardLight - widget.flowSpeed - _random.nextDouble();
            if (_moveForwardLight <= -widget.waveDistance * 4) {
              _moveForwardLight = _moveForwardLight + widget.waveDistance * 4;
            }
          });
          widgetsBinding.scheduleFrame();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: widget.size,
      painter: BezierCurvePainter(
        moveForward: _moveForwardDark,
        textStyle: widget.textStyle,
        circleStrokeWidth: widget.circleStrokeWidth,
        strokeCircleColor: widget.strokeCircleColor,
        percentage: _percentage,
        moveForwardLight: _moveForwardLight,
        lightWavePic: _lightWavePic,
        darkWavePic: _darkWavePic,
        waterHeight: _waterHeight,
      ),
    );
  }

  void changeWaterHeight(double h) {
    initAnimation(_percentage, h);
    animationController.forward();
  }

  void initAnimation(double old, double newPercentage) {
    animation =
        Tween(begin: old, end: newPercentage).animate(animationController);

    animation.addListener(_voidCallback = () {
      setState(() {
        double value = animation.value;
        _percentage = value;
        double newHeight = (1 - _percentage) * widget.size.height;
        _waterHeight = newHeight;
      });
    });

    animation.addStatusListener((animationStatus) {
      if (animationStatus == AnimationStatus.completed) {
        animation.removeListener(_voidCallback);
        animationController.reset();
      } else if (animationStatus == AnimationStatus.forward) {}
    });
  }
}
