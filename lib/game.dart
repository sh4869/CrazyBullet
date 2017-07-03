import 'dart:async';
import 'package:uix/uix.dart';

import "src/component/canvas.dart";
import 'src/component/info.dart';
import 'src/env.dart';
class Game extends Component {
  final Component<dynamic> info = $Info();
  final Component<dynamic> canvas = $Canvas();
  Timer timer;
  init() {
    timer = new Timer.periodic(new Duration(milliseconds: 5), (t) {
      info.invalidate();
      canvas.invalidate();
      this.invalidate();
    });
  }

  updateView() {
    final children = [
      vComponent(() => info),
      vComponent(() => canvas, type: "Canvas")
    ];
    if (store.life <= 0) {
      print("Game Over");
      store.finish = true;
      store.start = false;
    }
    updateRoot(vRoot(type: "Game")(children));
  }
}
