class Store {
  String title;
  int score;
  int life;
  bool start = false;
  bool finish = false;
  int player_num = 0;
  int enemy_num = 0;
  Store(this.title,this.score,this.life);
  static Store GenerateStore() => new Store("Game Start",0,100);
  void damage(int attack){
    life = life - attack < 0 ? 0 : life - attack;
  }
}