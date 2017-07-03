import 'dart:math' as math;
import 'dart:html' as html;
double getLength(html.Point p){
  return math.sqrt(math.pow(p.x,2) + math.pow(p.y,2));
}
