class Score {
  final int score;
  final String name;
  Score(this.score,this.name);

  static Map toMap(Score item){
    Map jsonMap = {
      "score": item.score,
      "name": item.name
    };
    return jsonMap;
  }
}