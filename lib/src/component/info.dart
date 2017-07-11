import 'package:uix/uix.dart';
import '../env.dart';

Component $Info() => new Info();

class Info extends Component {
  init() {
    addSubscription(scheduler.onNextFrame.listen(invalidate));
  }
  updateView() {
    var str =
        "life: ${store.life.toString()} score : ${store.score.toString()} enemy:${store.enemy_num.toString()} player: ${store.player_num.toString()}";
    updateRoot(vRoot()(str));
  }
}
