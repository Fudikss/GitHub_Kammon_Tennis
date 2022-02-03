class MatchSingleKDKTable {
  int playerCnt = 0;

  List<Map<String, String>> matchTable = [];
  List<Map<String, String>> editTable = [];
  Map<String, int> table_index = Map();

  MatchSingleKDKTable(this.playerCnt) {
    playerCnt = playerCnt;
  }

  List<Map<String, String>> makeTable(playerCnt) {
    Map<String, String> game;
    if(playerCnt == 5) {      
      game = {'GAME 1':'1:2'}; matchTable.add(game);
      game = {'GAME 2':'3:4'}; matchTable.add(game);
      game = {'GAME 3':'1:3'}; matchTable.add(game);
      game = {'GAME 4':'2:5'}; matchTable.add(game);
      game = {'GAME 5':'1:4'}; matchTable.add(game);
      game = {'GAME 6':'3:5'}; matchTable.add(game);
      game = {'GAME 7':'1:5'}; matchTable.add(game);
      game = {'GAME 8':'2:4'}; matchTable.add(game);
      game = {'GAME 9':'2:3'}; matchTable.add(game);
      game = {'GAME 10':'4:5'}; matchTable.add(game);
    }
    else if(playerCnt == 6) {
      game = {'GAME 1':'1:2'}; matchTable.add(game);
      game = {'GAME 2':'3:4'}; matchTable.add(game);
      game = {'GAME 3':'1:5'}; matchTable.add(game);
      game = {'GAME 4':'4:6'}; matchTable.add(game);
      game = {'GAME 5':'2:3'}; matchTable.add(game);
      game = {'GAME 6':'5:6'}; matchTable.add(game);
      game = {'GAME 7':'1:4'}; matchTable.add(game);
      game = {'GAME 8':'2:5'}; matchTable.add(game);
      game = {'GAME 9':'2:4'}; matchTable.add(game);
      game = {'GAME 10':'3:6'}; matchTable.add(game);
      game = {'GAME 11':'1:6'}; matchTable.add(game);
      game = {'GAME 12':'3:5'}; matchTable.add(game);
    }
    else if(playerCnt == 7) {
      game = {'GAME 1':'1:2'}; matchTable.add(game);
      game = {'GAME 2':'3:4'}; matchTable.add(game);
      game = {'GAME 3':'5:6'}; matchTable.add(game);
      game = {'GAME 4':'1:7'}; matchTable.add(game);
      game = {'GAME 5':'3:5'}; matchTable.add(game);
      game = {'GAME 6':'2:4'}; matchTable.add(game);
      game = {'GAME 7':'1:4'}; matchTable.add(game);
      game = {'GAME 8':'6:7'}; matchTable.add(game);
      game = {'GAME 9':'2:3'}; matchTable.add(game);
      game = {'GAME 10':'5:7'}; matchTable.add(game);
      game = {'GAME 11':'1:6'}; matchTable.add(game);
      game = {'GAME 12':'2:5'}; matchTable.add(game);
      game = {'GAME 13':'4:6'}; matchTable.add(game);
      game = {'GAME 14':'3:7'}; matchTable.add(game);
    }
    else if(playerCnt == 8) {
      game = {'GAME 1':'1:2'}; matchTable.add(game);
      game = {'GAME 2':'3:4'}; matchTable.add(game);
      game = {'GAME 3':'5:6'}; matchTable.add(game);
      game = {'GAME 4':'7:8'}; matchTable.add(game);
      game = {'GAME 5':'1:3'}; matchTable.add(game);
      game = {'GAME 6':'5:7'}; matchTable.add(game);
      game = {'GAME 7':'2:4'}; matchTable.add(game);
      game = {'GAME 8':'6:8'}; matchTable.add(game);
      game = {'GAME 9':'1:5'}; matchTable.add(game);
      game = {'GAME 10':'2:6'}; matchTable.add(game);
      game = {'GAME 11':'3:7'}; matchTable.add(game);
      game = {'GAME 12':'4:8'}; matchTable.add(game);
      game = {'GAME 13':'1:6'}; matchTable.add(game);
      game = {'GAME 14':'3:8'}; matchTable.add(game);
      game = {'GAME 15':'2:5'}; matchTable.add(game);
      game = {'GAME 16':'4:7'}; matchTable.add(game);
    }
    else if(playerCnt == 9) {
      game = {'GAME 1':'1:2'}; matchTable.add(game);
      game = {'GAME 2':'3:4'}; matchTable.add(game);
      game = {'GAME 3':'5:6'}; matchTable.add(game);
      game = {'GAME 4':'7:8'}; matchTable.add(game);
      game = {'GAME 5':'1:9'}; matchTable.add(game);
      game = {'GAME 6':'5:7'}; matchTable.add(game);
      game = {'GAME 7':'2:3'}; matchTable.add(game);
      game = {'GAME 8':'6:8'}; matchTable.add(game);
      game = {'GAME 9':'4:9'}; matchTable.add(game);
      game = {'GAME 10':'3:8'}; matchTable.add(game);
      game = {'GAME 11':'1:5'}; matchTable.add(game);
      game = {'GAME 12':'2:6'}; matchTable.add(game);
      game = {'GAME 13':'7:9'}; matchTable.add(game);
      game = {'GAME 14':'2:4'}; matchTable.add(game);
      game = {'GAME 15':'3:6'}; matchTable.add(game);
      game = {'GAME 16':'4:5'}; matchTable.add(game);
      game = {'GAME 17':'1:7'}; matchTable.add(game);
      game = {'GAME 18':'8:9'}; matchTable.add(game);
    }
    else if(playerCnt == 10) {
      game = {'GAME 1':'1:2'}; matchTable.add(game);
      game = {'GAME 2':'3:4'}; matchTable.add(game);
      game = {'GAME 3':'5:6'}; matchTable.add(game);
      game = {'GAME 4':'7:8'}; matchTable.add(game);
      game = {'GAME 5':'2:3'}; matchTable.add(game);
      game = {'GAME 6':'6:10'}; matchTable.add(game);
      game = {'GAME 7':'1:9'}; matchTable.add(game);
      game = {'GAME 8':'5:8'}; matchTable.add(game);
      game = {'GAME 9':'3:10'}; matchTable.add(game);
      game = {'GAME 10':'4:5'}; matchTable.add(game);
      game = {'GAME 11':'2:7'}; matchTable.add(game);
      game = {'GAME 12':'8:9'}; matchTable.add(game);
      game = {'GAME 13':'4:10'}; matchTable.add(game);
      game = {'GAME 14':'6:8'}; matchTable.add(game);
      game = {'GAME 15':'1:3'}; matchTable.add(game);
      game = {'GAME 16':'7:9'}; matchTable.add(game);
      game = {'GAME 17':'4:6'}; matchTable.add(game);
      game = {'GAME 18':'5:9'}; matchTable.add(game);
      game = {'GAME 19':'1:7'}; matchTable.add(game);
      game = {'GAME 20':'2:10'}; matchTable.add(game);
    }
    else if(playerCnt == 11) {
      game = {'GAME 1':'1:2'}; matchTable.add(game);
      game = {'GAME 2':'3:4'}; matchTable.add(game);
      game = {'GAME 3':'5:6'}; matchTable.add(game);
      game = {'GAME 4':'7:8'}; matchTable.add(game);
      game = {'GAME 5':'1:11'}; matchTable.add(game);
      game = {'GAME 6':'9:10'}; matchTable.add(game);
      game = {'GAME 7':'2:3'}; matchTable.add(game);
      game = {'GAME 8':'6:8'}; matchTable.add(game);
      game = {'GAME 9':'4:10'}; matchTable.add(game);
      game = {'GAME 10':'5:7'}; matchTable.add(game);
      game = {'GAME 11':'2:6'}; matchTable.add(game);
      game = {'GAME 12':'9:11'}; matchTable.add(game);
      game = {'GAME 13':'1:3'}; matchTable.add(game);
      game = {'GAME 14':'5:11'}; matchTable.add(game);
      game = {'GAME 15':'4:9'}; matchTable.add(game);
      game = {'GAME 16':'8:10'}; matchTable.add(game);
      game = {'GAME 17':'1:7'}; matchTable.add(game);
      game = {'GAME 18':'2:8'}; matchTable.add(game);
      game = {'GAME 19':'5:10'}; matchTable.add(game);
      game = {'GAME 20':'6:11'}; matchTable.add(game);
      game = {'GAME 21':'3:9'}; matchTable.add(game);
      game = {'GAME 22':'4:7'}; matchTable.add(game);
    }
    else if(playerCnt == 12) {
      game = {'GAME 1':'1:2'}; matchTable.add(game);
      game = {'GAME 2':'3:4'}; matchTable.add(game);
      game = {'GAME 3':'5:6'}; matchTable.add(game);
      game = {'GAME 4':'7:8'}; matchTable.add(game);
      game = {'GAME 5':'9:10'}; matchTable.add(game);
      game = {'GAME 6':'11:12'}; matchTable.add(game);
      game = {'GAME 7':'1:3'}; matchTable.add(game);
      game = {'GAME 8':'5:7'}; matchTable.add(game);
      game = {'GAME 9':'2:4'}; matchTable.add(game);
      game = {'GAME 10':'6:8'}; matchTable.add(game);
      game = {'GAME 11':'9:11'}; matchTable.add(game);
      game = {'GAME 12':'1:5'}; matchTable.add(game);
      game = {'GAME 13':'10:12'}; matchTable.add(game);
      game = {'GAME 14':'2:3'}; matchTable.add(game);
      game = {'GAME 15':'4:8'}; matchTable.add(game);
      game = {'GAME 16':'7:11'}; matchTable.add(game);
      game = {'GAME 17':'6:10'}; matchTable.add(game);
      game = {'GAME 18':'1:9'}; matchTable.add(game);
      game = {'GAME 19':'2:12'}; matchTable.add(game);
      game = {'GAME 20':'5:11'}; matchTable.add(game);
      game = {'GAME 21':'3:6'}; matchTable.add(game);
      game = {'GAME 22':'8:10'}; matchTable.add(game);
      game = {'GAME 23':'9:12'}; matchTable.add(game);
      game = {'GAME 24':'4:7'}; matchTable.add(game);
    }
    else if(playerCnt == 13) {
      game = {'GAME 1':'1:2'}; matchTable.add(game);
      game = {'GAME 2':'3:4'}; matchTable.add(game);
      game = {'GAME 3':'5:6'}; matchTable.add(game);
      game = {'GAME 4':'7:8'}; matchTable.add(game);
      game = {'GAME 5':'9:10'}; matchTable.add(game);
      game = {'GAME 6':'11:12'}; matchTable.add(game);
      game = {'GAME 7':'1:13'}; matchTable.add(game);
      game = {'GAME 8':'2:3'}; matchTable.add(game);
      game = {'GAME 9':'4:5'}; matchTable.add(game);
      game = {'GAME 10':'6:7'}; matchTable.add(game);
      game = {'GAME 11':'8:9'}; matchTable.add(game);
      game = {'GAME 12':'10:11'}; matchTable.add(game);
      game = {'GAME 13':'12:13'}; matchTable.add(game);
      game = {'GAME 14':'1:7'}; matchTable.add(game);
      game = {'GAME 15':'2:8'}; matchTable.add(game);
      game = {'GAME 16':'3:9'}; matchTable.add(game);
      game = {'GAME 17':'4:10'}; matchTable.add(game);
      game = {'GAME 18':'5:11'}; matchTable.add(game);
      game = {'GAME 19':'6:12'}; matchTable.add(game);
      game = {'GAME 20':'13:2'}; matchTable.add(game);
      game = {'GAME 21':'1:4'}; matchTable.add(game);
      game = {'GAME 22':'3:5'}; matchTable.add(game);
      game = {'GAME 23':'6:8'}; matchTable.add(game);
      game = {'GAME 24':'7:9'}; matchTable.add(game);
      game = {'GAME 25':'10:12'}; matchTable.add(game);
      game = {'GAME 26':'11:13'}; matchTable.add(game);
    }
    
    return matchTable;
  }

  List<Map<String, String>> makeEditTable(playerCnt) {
    Map<String, String> game;
    if(playerCnt == 5) {      
      game = {'GAME 1':'1:1'}; editTable.add(game);
      game = {'GAME 2':'1:1'}; editTable.add(game);
      game = {'GAME 3':'2:2'}; editTable.add(game);
      game = {'GAME 4':'2:1'}; editTable.add(game);
      game = {'GAME 5':'3:2'}; editTable.add(game);
      game = {'GAME 6':'3:2'}; editTable.add(game);
      game = {'GAME 7':'4:3'}; editTable.add(game);
      game = {'GAME 8':'3:3'}; editTable.add(game);
      game = {'GAME 9':'4:4'}; editTable.add(game);
      game = {'GAME 10':'4:4'}; editTable.add(game);
    } 
    else if(playerCnt == 6) {
      game = {'GAME 1':'1:1'}; editTable.add(game);
      game = {'GAME 2':'1:1'}; editTable.add(game);
      game = {'GAME 3':'2:1'}; editTable.add(game);
      game = {'GAME 4':'2:1'}; editTable.add(game);
      game = {'GAME 5':'2:2'}; editTable.add(game);
      game = {'GAME 6':'2:2'}; editTable.add(game);
      game = {'GAME 7':'3:3'}; editTable.add(game);
      game = {'GAME 8':'3:3'}; editTable.add(game);
      game = {'GAME 9':'4:4'}; editTable.add(game);
      game = {'GAME 10':'3:3'}; editTable.add(game);
      game = {'GAME 11':'4:4'}; editTable.add(game);
      game = {'GAME 12':'4:4'}; editTable.add(game);
    }
    else if(playerCnt == 7) {
      game = {'GAME 1':'1:1'}; editTable.add(game);
      game = {'GAME 2':'1:1'}; editTable.add(game);
      game = {'GAME 3':'1:1'}; editTable.add(game);
      game = {'GAME 4':'2:1'}; editTable.add(game);
      game = {'GAME 5':'2:2'}; editTable.add(game);
      game = {'GAME 6':'2:2'}; editTable.add(game);
      game = {'GAME 7':'3:3'}; editTable.add(game);
      game = {'GAME 8':'2:2'}; editTable.add(game);
      game = {'GAME 9':'3:3'}; editTable.add(game);
      game = {'GAME 10':'3:3'}; editTable.add(game);
      game = {'GAME 11':'4:3'}; editTable.add(game);
      game = {'GAME 12':'4:4'}; editTable.add(game);
      game = {'GAME 13':'4:4'}; editTable.add(game);
      game = {'GAME 14':'4:4'}; editTable.add(game);
    }
    else if(playerCnt == 8) {
      game = {'GAME 1':'1:1'}; editTable.add(game);
      game = {'GAME 2':'1:1'}; editTable.add(game);
      game = {'GAME 3':'1:1'}; editTable.add(game);
      game = {'GAME 4':'1:1'}; editTable.add(game);
      game = {'GAME 5':'2:2'}; editTable.add(game);
      game = {'GAME 6':'2:2'}; editTable.add(game);
      game = {'GAME 7':'2:2'}; editTable.add(game);
      game = {'GAME 8':'2:2'}; editTable.add(game);
      game = {'GAME 9':'3:3'}; editTable.add(game);
      game = {'GAME 10':'3:3'}; editTable.add(game);
      game = {'GAME 11':'3:3'}; editTable.add(game);
      game = {'GAME 12':'3:3'}; editTable.add(game);
      game = {'GAME 13':'4:4'}; editTable.add(game);
      game = {'GAME 14':'4:4'}; editTable.add(game);
      game = {'GAME 15':'4:4'}; editTable.add(game);
      game = {'GAME 16':'4:4'}; editTable.add(game);
    }
    else if(playerCnt == 9) {
      game = {'GAME 1':'1:1'}; editTable.add(game);
      game = {'GAME 2':'1:1'}; editTable.add(game);
      game = {'GAME 3':'1:1'}; editTable.add(game);
      game = {'GAME 4':'1:1'}; editTable.add(game);
      game = {'GAME 5':'2:1'}; editTable.add(game);
      game = {'GAME 6':'2:2'}; editTable.add(game);
      game = {'GAME 7':'2:2'}; editTable.add(game);
      game = {'GAME 8':'2:2'}; editTable.add(game);
      game = {'GAME 9':'2:2'}; editTable.add(game);
      game = {'GAME 10':'3:3'}; editTable.add(game);
      game = {'GAME 11':'3:3'}; editTable.add(game);
      game = {'GAME 12':'3:3'}; editTable.add(game);
      game = {'GAME 13':'3:3'}; editTable.add(game);
      game = {'GAME 14':'4:3'}; editTable.add(game);
      game = {'GAME 15':'4:4'}; editTable.add(game);
      game = {'GAME 16':'4:4'}; editTable.add(game);
      game = {'GAME 17':'4:4'}; editTable.add(game);
      game = {'GAME 18':'4:4'}; editTable.add(game);
    }
    else if(playerCnt == 10) {
      game = {'GAME 1':'1:1'}; editTable.add(game);
      game = {'GAME 2':'1:1'}; editTable.add(game);
      game = {'GAME 3':'1:1'}; editTable.add(game);
      game = {'GAME 4':'1:1'}; editTable.add(game);
      game = {'GAME 5':'2:2'}; editTable.add(game);
      game = {'GAME 6':'2:1'}; editTable.add(game);
      game = {'GAME 7':'2:1'}; editTable.add(game);
      game = {'GAME 8':'2:2'}; editTable.add(game);
      game = {'GAME 9':'3:2'}; editTable.add(game);
      game = {'GAME 10':'2:3'}; editTable.add(game);
      game = {'GAME 11':'3:2'}; editTable.add(game);
      game = {'GAME 12':'3:2'}; editTable.add(game);
      game = {'GAME 13':'3:3'}; editTable.add(game);
      game = {'GAME 14':'3:4'}; editTable.add(game);
      game = {'GAME 15':'3:4'}; editTable.add(game);
      game = {'GAME 16':'3:3'}; editTable.add(game);
      game = {'GAME 17':'4:4'}; editTable.add(game);
      game = {'GAME 18':'4:4'}; editTable.add(game);
      game = {'GAME 19':'4:4'}; editTable.add(game);
      game = {'GAME 20':'4:4'}; editTable.add(game);
    }
    else if(playerCnt == 11) {
      game = {'GAME 1':'1:1'}; editTable.add(game);
      game = {'GAME 2':'1:1'}; editTable.add(game);
      game = {'GAME 3':'1:1'}; editTable.add(game);
      game = {'GAME 4':'1:1'}; editTable.add(game);
      game = {'GAME 5':'2:1'}; editTable.add(game);
      game = {'GAME 6':'1:1'}; editTable.add(game);
      game = {'GAME 7':'2:2'}; editTable.add(game);
      game = {'GAME 8':'2:2'}; editTable.add(game);
      game = {'GAME 9':'2:2'}; editTable.add(game);
      game = {'GAME 10':'2:2'}; editTable.add(game);
      game = {'GAME 11':'3:3'}; editTable.add(game);
      game = {'GAME 12':'2:2'}; editTable.add(game);
      game = {'GAME 13':'3:3'}; editTable.add(game);
      game = {'GAME 14':'3:3'}; editTable.add(game);
      game = {'GAME 15':'3:3'}; editTable.add(game);
      game = {'GAME 16':'3:3'}; editTable.add(game);
      game = {'GAME 17':'4:3'}; editTable.add(game);
      game = {'GAME 18':'4:4'}; editTable.add(game);
      game = {'GAME 19':'4:4'}; editTable.add(game);
      game = {'GAME 20':'4:4'}; editTable.add(game);
      game = {'GAME 21':'4:4'}; editTable.add(game);
      game = {'GAME 22':'4:4'}; editTable.add(game);
    }
    else if(playerCnt == 12) {
      game = {'GAME 1':'1:1'}; editTable.add(game);
      game = {'GAME 2':'1:1'}; editTable.add(game);
      game = {'GAME 3':'1:1'}; editTable.add(game);
      game = {'GAME 4':'1:1'}; editTable.add(game);
      game = {'GAME 5':'1:1'}; editTable.add(game);
      game = {'GAME 6':'1:1'}; editTable.add(game);
      game = {'GAME 7':'2:2'}; editTable.add(game);
      game = {'GAME 8':'2:2'}; editTable.add(game);
      game = {'GAME 9':'2:2'}; editTable.add(game);
      game = {'GAME 10':'2:2'}; editTable.add(game);
      game = {'GAME 11':'2:2'}; editTable.add(game);
      game = {'GAME 12':'3:3'}; editTable.add(game);
      game = {'GAME 13':'2:2'}; editTable.add(game);
      game = {'GAME 14':'3:3'}; editTable.add(game);
      game = {'GAME 15':'3:3'}; editTable.add(game);
      game = {'GAME 16':'3:3'}; editTable.add(game);
      game = {'GAME 17':'3:3'}; editTable.add(game);
      game = {'GAME 18':'4:3'}; editTable.add(game);
      game = {'GAME 19':'4:3'}; editTable.add(game);
      game = {'GAME 20':'4:4'}; editTable.add(game);
      game = {'GAME 21':'4:4'}; editTable.add(game);
      game = {'GAME 22':'4:4'}; editTable.add(game);
      game = {'GAME 23':'4:4'}; editTable.add(game);
      game = {'GAME 24':'4:4'}; editTable.add(game);
    }
    else if(playerCnt == 13) {
      game = {'GAME 1':'1:1'}; editTable.add(game);
      game = {'GAME 2':'1:1'}; editTable.add(game);
      game = {'GAME 3':'1:1'}; editTable.add(game);
      game = {'GAME 4':'1:1'}; editTable.add(game);
      game = {'GAME 5':'1:1'}; editTable.add(game);
      game = {'GAME 6':'1:1'}; editTable.add(game);
      game = {'GAME 7':'2:1'}; editTable.add(game);
      game = {'GAME 8':'2:2'}; editTable.add(game);
      game = {'GAME 9':'2:2'}; editTable.add(game);
      game = {'GAME 10':'2:2'}; editTable.add(game);
      game = {'GAME 11':'2:2'}; editTable.add(game);
      game = {'GAME 12':'2:2'}; editTable.add(game);
      game = {'GAME 13':'2:2'}; editTable.add(game);
      game = {'GAME 14':'3:3'}; editTable.add(game);
      game = {'GAME 15':'3:3'}; editTable.add(game);
      game = {'GAME 16':'3:3'}; editTable.add(game);
      game = {'GAME 17':'3:3'}; editTable.add(game);
      game = {'GAME 18':'3:3'}; editTable.add(game);
      game = {'GAME 19':'3:3'}; editTable.add(game);
      game = {'GAME 20':'3:4'}; editTable.add(game);
      game = {'GAME 21':'4:4'}; editTable.add(game);
      game = {'GAME 22':'4:4'}; editTable.add(game);
      game = {'GAME 23':'4:4'}; editTable.add(game);
      game = {'GAME 24':'4:4'}; editTable.add(game);
      game = {'GAME 25':'4:4'}; editTable.add(game);
      game = {'GAME 26':'4:4'}; editTable.add(game);
    }

    return editTable;
  }
}