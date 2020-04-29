import 'dart:ui';

class WavePictureGenerator {
  PictureRecorder _recorder;
  final Size size;
  final double _waveDistance;
  final double _waveHeight;
  final Color _waterColor;
  int _maxCount;
  double waterHeight;
  double _targetWidth;
  double _targetHeight;

  WavePictureGenerator(
    this.size,
    this._waveDistance,
    this._waveHeight,
    this._waterColor,
  ) {
    double oneDistance = _waveDistance * 4;
    int count = (size.width / oneDistance).ceil() + 1;
    _targetWidth = count * oneDistance;
    _maxCount = count * 4 + 1;
    waterHeight = size.height / 2;
    _targetHeight = size.height + waterHeight;
  }

  Picture drawDarkWave() {
    return drawWaves(true);
  }

  Picture drawLightWave() {
    return drawWaves(false);
  }

  Picture drawWaves(bool isDarkWave) {
    _recorder = PictureRecorder();
    Canvas canvas = Canvas(_recorder);
    canvas.clipRect(new Rect.fromLTWH(0.0, 0.0, _targetWidth, _targetHeight));
    Paint paint = Paint();
    if (isDarkWave) {
      paint.color = _waterColor;
    } else {
      paint.color = _waterColor.withAlpha(0x88);
    }
    paint.style = PaintingStyle.fill;
    canvas.drawPath(createBezierPath(isDarkWave), paint);
    return _recorder.endRecording();
  }

  Path createBezierPath(bool isDarkWave) {
    Path path = Path();
    path.moveTo(0, waterHeight);

    double lastPoint = 0.0;
    int m = 0;
    double waves;
    for (int i = 0; i < _maxCount - 2; i = i + 2) {
      if (m % 2 == 0) {
        waves = waterHeight + _waveHeight;
      } else {
        waves = waterHeight - _waveHeight;
      }
      path.cubicTo(lastPoint, waterHeight, lastPoint + _waveDistance, waves,
          lastPoint + _waveDistance * 2, waterHeight);
      lastPoint = lastPoint + _waveDistance * 2;
      m++;
    }
    if (isDarkWave) {
      path.lineTo(lastPoint, _targetHeight);
      path.lineTo(0, _targetHeight);
    } else {
      double waveHeightMax = waterHeight + _waveHeight + 10.0;
      path.lineTo(lastPoint, waveHeightMax);
      path.lineTo(0, waveHeightMax);
    }
    path.close();
    return path;
  }
}
