import 'dart:async';
import 'package:uix/uix.dart';
import "src/component/canvas.dart";
import 'src/component/info.dart';
import 'src/component/ranking.dart';
import 'src/env.dart';
import 'src/data/score.dart';
import 'package:firebase/firebase.dart' as fb;

class Game extends Component {
  final Component<dynamic> info = $Info();
  final Component<dynamic> canvas = $Canvas();
  final Component<dynamic> ranking = $Ranking();
  fb.DatabaseReference ref;
  Timer timer;

  Game(this.ref);
  init() {
    // 最初の値を取得
    ref.onChildAdded.listen((e) {
      var data = e.snapshot.val();
      print(data);
      scores.add(new Score(data["score"], data["name"]));
      scores.sort((a, b) => b.score.compareTo(a.score));
      ranking.invalidate();
    });
  }

  updateView() {
    if (store.life <= 0 && !store.finish) {
      print("Game Over");
      store.finish = true;
      store.start = false;
      var result = Score.toMap(new Score(store.score, ""));
      ref.push(result);
    }
    final children = [
      vComponent(() => info),
      vComponent(() => canvas, type: "Canvas"),
      vComponent(() => ranking, type: "Ranking"),
    ];
    if (timer == null) {
      timer = new Timer.periodic(new Duration(milliseconds: 5), (t) {
        this.invalidate();
      });
    }
    updateRoot(vRoot(type: "Game")(children));
  }
}
