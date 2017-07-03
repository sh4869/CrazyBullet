import 'dart:html' as html;
import 'dart:math' as math;
import './player.dart';

enum Direction { right, left, up, down }

class Enemy {
  int size;
  html.Point point;
  Direction dir;
  Enemy(this.point, this.dir) {
    size = new math.Random().nextInt(20) + 10;
  }
  bool touched(Player player) {
    return (player.point.x - point.x) * (player.point.x - point.x) +
            (player.point.y - point.y) * (player.point.y - point.y) <=
        (size + player.size) * (size + player.size);
  }

  static Enemy generateEnemy(int xMax, int yMax, int per) {
    html.Point p;
    Direction d;
    var r = new math.Random();

    switch (new math.Random().nextInt(3)) {
      case 0:
        p = new html.Point(0, r.nextInt(yMax));
        d = Direction.right;
        break;
      case 1:
        p = new html.Point(xMax, r.nextInt(yMax));
        d = Direction.left;
        break;
      case 2:
        p = new html.Point(r.nextInt(yMax), 0);
        d = Direction.down;
        break;
      case 3:
        p = new html.Point(r.nextInt(xMax), yMax);
        d = Direction.up;
        break;
    }
    if (r.nextInt(per) % per == 0) {
      return new Boss(p, d);
    } else {
      return new Enemy(p, d);
    }
  }

  void updateEnemyPosition() {
    int speed = this is Boss ? 3 : 1;
    switch (this.dir) {
      case Direction.right:
        point = new html.Point(point.x + speed, point.y);
        break;
      case Direction.left:
        point = new html.Point(point.x - speed, point.y);
        break;
      case Direction.down:
        point = new html.Point(point.x, point.y + speed);
        break;
      case Direction.up:
        point = new html.Point(point.x, point.y - speed);
        break;
    }
  }
}

class Boss extends Enemy {
  Boss(point, dir) : super(point, dir) {
    size = 50;
  }
}
