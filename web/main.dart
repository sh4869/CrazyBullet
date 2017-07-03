import 'dart:html' as html;
import 'package:uix/uix.dart';
import 'package:minigame2017/game.dart';

void main() {
  initUix();
  injectComponent(new Game(), html.document.getElementById("app"));
}
