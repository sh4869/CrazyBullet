import 'dart:html' as html;
import 'package:uix/uix.dart';
import 'package:minigame2017/game.dart';
import 'package:firebase/firebase.dart' as fb;

void main() {
  fb.initializeApp(
      apiKey: "",
      authDomain: "",
      databaseURL: "",
      storageBucket: "");
  fb.Database database = fb.database();
  fb.DatabaseReference ref = database.ref("ranking");
  initUix();
  injectComponent(new Game(ref), html.document.getElementById("app"));
}
