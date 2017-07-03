import 'dart:html' as html;
import 'dart:math' as math;
import '../util.dart';

class Player {
  html.Point point;
  double angle;
  final size = 15;
  Player(this.point)
      : this.angle = new math.Random().nextDouble() * math.PI * 2;
  void move(html.Point diff) {
    double tmp, tmp_angle;
    double radian = math.acos((diff.x * 0 + diff.y * 1) /
        (getLength(diff) + getLength(new html.Point(0, 1))));
    if (diff.x > 0) {
      tmp = radian * 180 / math.PI;
    } else {
      tmp = 360 - (radian * 180 / math.PI);
    }
    tmp_angle = tmp + angle;
    if (tmp_angle > 360) {
      tmp_angle -= 360;
    }
    point = new html.Point(point.x + math.cos(tmp_angle) * (diff.x),
        point.y + math.sin(tmp_angle) * (diff.y));
  }
}
