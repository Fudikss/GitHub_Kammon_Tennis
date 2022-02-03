class MatchRecord {
  int idx = 0;
  int win = 0;
  int draw = 0;
  int lose = 0;
  int winPoint = 0;
  int losePoint = 0;
  String rank = '';
  int game_cnt = 0;
  int dist = 0;

  MatchRecord(this.win, this.draw, this.lose, this.winPoint, this.losePoint, this.rank, this.game_cnt, this.dist);
}