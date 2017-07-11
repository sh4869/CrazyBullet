import 'package:uix/uix.dart';
import '../env.dart';

Component $Ranking() => new Ranking();

class Ranking extends Component {
  Ranking();
  updateView() {
    var child = [];
    var i = 1;
    child.add(vElement("h1")("Ranking"));
    scores.forEach((score) {
      child.add(vElement('p')("${i} ${score.name} / ${score.score}"));
      i++;
    });
    updateRoot(vRoot(type: "Info")(child));  
  }
}
