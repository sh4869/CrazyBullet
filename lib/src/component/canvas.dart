import 'dart:html' as html;
import 'dart:math' as math;
import 'package:uix/uix.dart';
import '../env.dart';
import '../util.dart';
import '../data/player.dart';
import '../data/enemy.dart';
import '../store.dart';

Component<dynamic> $Canvas() => new Canvas();

class Canvas extends Component {
  final tag = 'canvas';
  html.CanvasRenderingContext2D ctx;
  int width = -1;
  int height = -1;
  int radius = 15;
  int oldclock, per = 10;
  bool moveMouse = false;
  int count = 0;
  int interval = 200;
  html.Point newPoint = const html.Point(0, 0);
  html.Point oldPoint = const html.Point(0, 0);
  List<Player> players = new List<Player>();
  List<Enemy> enemies = new List<Enemy>();

  Canvas();

  init() {
    ctx = (element as html.CanvasElement).context2D;
    element.onClick.listen((e) {
      if (!store.finish && !store.start) {
        store.start = true;
      } else if (store.finish && !store.start) {
        players.clear();
        enemies.clear();
        store = Store.GenerateStore();
        store.start = true;
      }
    });
    element.onMouseMove.listen(_handleMove);

    addSubscription(html.window.onResize.listen(_handleResize));
  }

  void _handleMove(html.MouseEvent e) {
    oldPoint = newPoint;
    newPoint = e.offset;
    invalidate();
    moveMouse = true;
  }

  void _handleResize(html.Event e) {
    width = -1;
    height = -1;
    invalidate();
  }

  void _generatePlayer() {
    int x = newPoint.x + new math.Random().nextInt(300) - 150;
    int y = newPoint.y + new math.Random().nextInt(300) - 150;
    players.add(new Player(new html.Point(x, y)));
  }

  void _updatePlayer(html.Point diff, bool move) {
    var delete_list = [];
    var dead_list = [];
    players.forEach((player) {
      // 外に言ってしまったPlayerは消す
      if (player.point.x + radius < 0 ||
          player.point.x - radius > element.clientWidth ||
          player.point.y + radius < 0 ||
          player.point.y - radius > element.clientHeight) {
        delete_list.add(player);
      } else {
        enemies.forEach((e) {
          if (e.touched(player)) {
            dead_list.add({"target": player, "isboss": e is Boss});
          }
        });
        if (move) {
          player.move(diff);
        }
      }
    });
    dead_list.forEach((p) {
      players.remove(p["target"]);
      if (p["isboss"]) {
        store.damage(7);
      } else {
        store.damage(3);
      }
    });
    delete_list.forEach(players.remove);
  }

  void _generateEnemy() {
    per = 10 - (store.score ~/ 100) < 3 ? 3 : 10 - (store.score ~/ 100);
    enemies.add(
        Enemy.generateEnemy(element.clientWidth, element.clientHeight, per));
  }

  void _updateEnemies() {
    var delete_list = [];
    enemies.forEach((e) {
      if ((e.dir == Direction.right && e.point.x > element.clientWidth) ||
          (e.dir == Direction.left && e.point.x < 0) ||
          (e.dir == Direction.up && e.point.y < 0) ||
          (e.dir == Direction.down && e.point.y > element.clientHeight)) {
        delete_list.add(e);
      } else {
        e.updateEnemyPosition();
      }
    });
    delete_list.forEach((e) {
      enemies.remove(e);
      if (e is Boss) {
        store.score += 30 * players.length;
      } else {
        store.score += 20 * players.length;
      }
    });
  }

  void _drawBackground() {
    ctx.globalCompositeOperation = 'source-over';
    ctx.fillStyle = 'rgba(150, 150, 200, 1)';
    ctx.fillRect(0, 0, width, height);
  }

  void _drawString(String str) {
    ctx.font = "50px 'Arial'";
    ctx.fillStyle = "blue";
    ctx.fillText(str, 100, 200);
  }

  void _drawPlayerAndEnemy() {
    ctx.globalCompositeOperation = 'lighter';
    ctx.fillStyle = 'rgba(255,255,255, 1)';
    players.forEach((p) {
      ctx.beginPath();
      ctx.arc(p.point.x, p.point.y, p.size, 0, math.PI * 2, false);
      ctx.fill();
    });
    enemies.forEach((e) {
      if (e is Boss) {
        ctx.fillStyle = "rgb(118,0,0)";
      } else {
        ctx.fillStyle = "rgba(255,0,0,1)";
      }
      ctx.beginPath();
      ctx.arc(e.point.x, e.point.y, e.size, 0, math.PI * 2, false);
      ctx.fill();
    });
  }

  updateView() async {
    if (width == -1) {
      await scheduler.currentFrame.read();
      width = element.client.width;
      height = element.client.height;
      await scheduler.currentFrame.write();
      element.setAttribute('width', width.toString());
      element.setAttribute('height', height.toString());
    }
    _drawBackground();
    if (!store.start && !store.finish) {
      _drawString("Ready?");
    } else if (store.finish) {
      _drawString("Score: ${store.score.toString()}");
    } else {
      if (!moveMouse) {
        count++;
        if (count % 200 == 0) {
          store.damage(5);
        }
      } else {
        count = 0;
      }
      _updatePlayer(oldPoint - newPoint, moveMouse);
      _updateEnemies();

      // 一定時間ごとの生成
      if (scheduler.clock % 100 == 0 && oldclock != scheduler.clock && moveMouse) {
        _generatePlayer();
      }
      interval = 200 - (store.score ~/ 100) * 10 < 100 ? 100 : 200 - (store.score ~/ 100) * 10;
      if (scheduler.clock % interval  == 0 && oldclock != scheduler.clock) {
        _generateEnemy();
      }
      // Write Players
      _drawPlayerAndEnemy();
      oldclock = scheduler.clock;
      store.player_num = players.length;
      store.enemy_num = enemies.length;
      moveMouse = false;
    }
  }
}
