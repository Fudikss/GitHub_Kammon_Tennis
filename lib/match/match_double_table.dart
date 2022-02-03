class MatchDoubleKDKTable {
  int playerCnt = 0;

  List<Map<String, String>> table = [];
  List<Map<String, String>> editTable = [];

  Map<String, int> table_index = Map();

  MatchDoubleKDKTable(this.playerCnt) {
    playerCnt = playerCnt;
    setTableIndex(playerCnt);
  }

  List<Map<String, String>> makeTable(playerCnt) {
    
    if(playerCnt == 5) {
      Map<String, String> game;
      game = {'GAME 1':'1,2:3,4'}; table.add(game);
      game = {'GAME 2':'1,3:2,5'}; table.add(game);
      game = {'GAME 3':'1,4:3,5'}; table.add(game);
      game = {'GAME 4':'1,5:2,4'}; table.add(game);
      game = {'GAME 5':'2,3:4,5'}; table.add(game);
    }
    else if(playerCnt == 6) {
      Map<String, String> game;
      game = {'GAME 1':'1,2:3,4'}; table.add(game);
      game = {'GAME 2':'1,5:4,6'}; table.add(game);
      game = {'GAME 3':'2,3:5,6'}; table.add(game);
      game = {'GAME 4':'1,4:2,5'}; table.add(game);
      game = {'GAME 5':'2,4:3,6'}; table.add(game);
      game = {'GAME 6':'1,6:3,5'}; table.add(game);
    }
    else if(playerCnt == 7) {
      Map<String, String> game;
      game = {'GAME 1':'1,2:3,4'}; table.add(game);
      game = {'GAME 2':'5,6:1,7'}; table.add(game);
      game = {'GAME 3':'3,5:2,4'}; table.add(game);
      game = {'GAME 4':'1,4:6,7'}; table.add(game);
      game = {'GAME 5':'2,3:5,7'}; table.add(game);
      game = {'GAME 6':'1,6:2,5'}; table.add(game);
      game = {'GAME 7':'4,6:3,7'}; table.add(game);
    }
    else if(playerCnt == 8) {
      Map<String, String> game;
      game = {'GAME 1':'1,2:3,4'}; table.add(game);
      game = {'GAME 2':'5,6:7,8'}; table.add(game);
      game = {'GAME 3':'1,3:5,7'}; table.add(game);
      game = {'GAME 4':'2,4:6,8'}; table.add(game);
      game = {'GAME 5':'3,7:4,8'}; table.add(game);
      game = {'GAME 6':'1,5:2,6'}; table.add(game);
      game = {'GAME 7':'1,6:3,8'}; table.add(game);
      game = {'GAME 8':'2,5:4,7'}; table.add(game);
    }
    else if(playerCnt == 9) {
      Map<String, String> game;
      game = {'GAME 1':'1,2:3,4'}; table.add(game);
      game = {'GAME 2':'5,6:7,8'}; table.add(game);
      game = {'GAME 3':'1,9:5,7'}; table.add(game);
      game = {'GAME 4':'2,3:6,8'}; table.add(game);
      game = {'GAME 5':'4,9:3,8'}; table.add(game);
      game = {'GAME 6':'1,5:2,6'}; table.add(game);
      game = {'GAME 7':'1,7:8,9'}; table.add(game);
      game = {'GAME 8':'3,6:4,5'}; table.add(game);
      game = {'GAME 9':'2,4:7,9'}; table.add(game);
    }
    else if(playerCnt == 10) {
      Map<String, String> game;
      game = {'GAME 1':'1,2:3,4'}; table.add(game);
      game = {'GAME 2':'5,6:7,8'}; table.add(game);
      game = {'GAME 3':'2,3:6,10'}; table.add(game);
      game = {'GAME 4':'1,9:5,8'}; table.add(game);
      game = {'GAME 5':'3,10:4,5'}; table.add(game);
      game = {'GAME 6':'2,7:8,9'}; table.add(game);
      game = {'GAME 7':'4,10:6,8'}; table.add(game);
      game = {'GAME 8':'1,3:7,9'}; table.add(game);
      game = {'GAME 9':'4,6:5,9'}; table.add(game);
      game = {'GAME 10':'1,7:2,10'}; table.add(game);
    }
    else if(playerCnt == 11) {
      Map<String, String> game;
      game = {'GAME 1':'1,2:3,4'}; table.add(game);
      game = {'GAME 2':'5,6:7,8'}; table.add(game);
      game = {'GAME 3':'1,11:9,10'}; table.add(game);
      game = {'GAME 4':'2,3:6,8'}; table.add(game);
      game = {'GAME 5':'4,10:5,7'}; table.add(game);
      game = {'GAME 6':'2,6:9,11'}; table.add(game);
      game = {'GAME 7':'1,3:5,11'}; table.add(game);
      game = {'GAME 8':'4,9:8,10'}; table.add(game);
      game = {'GAME 9':'1,7:2,8'}; table.add(game);
      game = {'GAME 10':'5,10:6,11'}; table.add(game);
      game = {'GAME 11':'3,9:4,7'}; table.add(game);
    }
    else if(playerCnt == 12) {
      Map<String, String> game;
      game = {'GAME 1':'1,2:3,4'}; table.add(game);
      game = {'GAME 2':'5,6:7,8'}; table.add(game);
      game = {'GAME 3':'9,10:11,12'}; table.add(game);
      game = {'GAME 4':'3,7:4,8'}; table.add(game);
      game = {'GAME 5':'2,9:5,10'}; table.add(game);
      game = {'GAME 6':'1,11:6,12'}; table.add(game);
      game = {'GAME 7':'1,3:5,7'}; table.add(game);
      game = {'GAME 8':'2,4:9,11'}; table.add(game);
      game = {'GAME 9':'6,8:10,12'}; table.add(game);
      game = {'GAME 10':'1,7:2,11'}; table.add(game);
      game = {'GAME 11':'3,5:6,10'}; table.add(game);
      game = {'GAME 12':'4,9:8,12'}; table.add(game);
    }
    else if(playerCnt == 13) {
      Map<String, String> game;
      game = {'GAME 1':'1,2:3,4'}; table.add(game);
      game = {'GAME 2':'5,6:7,8'}; table.add(game);
      game = {'GAME 3':'9,10:11,12'}; table.add(game);
      game = {'GAME 4':'1,13:2,5'}; table.add(game);
      game = {'GAME 5':'3,7:4,10'}; table.add(game);
      game = {'GAME 6':'6,8:9,11'}; table.add(game);
      game = {'GAME 7':'12,13:1,3'}; table.add(game);
      game = {'GAME 8':'2,6:5,10'}; table.add(game);
      game = {'GAME 9':'4,7:8,11'}; table.add(game);
      game = {'GAME 10':'9,12:2,13'}; table.add(game);
      game = {'GAME 11':'1,5:10,11'}; table.add(game);
      game = {'GAME 12':'3,12:6,7'}; table.add(game);
      game = {'GAME 13':'4,8:9,13'}; table.add(game);
    }
    else if(playerCnt == 14) {
      Map<String, String> game;
      game = {'GAME 1':'1,2:3,4'}; table.add(game);
      game = {'GAME 2':'5,6:7,8'}; table.add(game);
      game = {'GAME 3':'9,10:11,12'}; table.add(game);
      game = {'GAME 4':'13,14:1,3'}; table.add(game);
      game = {'GAME 5':'2,4:5,7'}; table.add(game);
      game = {'GAME 6':'6,8:9,11'}; table.add(game);
      game = {'GAME 7':'2,6:12,13'}; table.add(game);
      game = {'GAME 8':'7,9:10,14'}; table.add(game);
      game = {'GAME 9':'1,4:8,11'}; table.add(game);
      game = {'GAME 10':'5,14:6,10'}; table.add(game);
      game = {'GAME 11':'3,12:7,11'}; table.add(game);
      game = {'GAME 12':'2,13:8,9'}; table.add(game);
      game = {'GAME 13':'3,14:4,5'}; table.add(game);
      game = {'GAME 14':'10,12:1,13'}; table.add(game);
    }
    else if(playerCnt == 15) {
      Map<String, String> game;
      game = {'GAME 1':'1,2:3,4'}; table.add(game);
      game = {'GAME 2':'5,6:7,8'}; table.add(game);
      game = {'GAME 3':'9,10:11,12'}; table.add(game);
      game = {'GAME 4':'13,14:1,15'}; table.add(game);
      game = {'GAME 5':'2,3:5,7'}; table.add(game);
      game = {'GAME 6':'4,6:10,11'}; table.add(game);
      game = {'GAME 7':'8,13:9,14'}; table.add(game);
      game = {'GAME 8':'4,15:5,12'}; table.add(game);
      game = {'GAME 9':'1,3:6,11'}; table.add(game);
      game = {'GAME 10':'2,7:8,10'}; table.add(game);
      game = {'GAME 11':'9,12:5,14'}; table.add(game);
      game = {'GAME 12':'3,6:13,15'}; table.add(game);
      game = {'GAME 13':'1,11:8,12'}; table.add(game);
      game = {'GAME 14':'4,7:14,15'}; table.add(game);
      game = {'GAME 15':'2,10:9,13'}; table.add(game);
    }
    else if(playerCnt == 16) {
      Map<String, String> game;
      game = {'GAME 1':'1,2:3,4'}; table.add(game);
      game = {'GAME 2':'5,6:7,8'}; table.add(game);
      game = {'GAME 3':'9,10:11,12'}; table.add(game);
      game = {'GAME 4':'13,14:15,16'}; table.add(game);
      game = {'GAME 5':'1,3:5,7'}; table.add(game);
      game = {'GAME 6':'2,4:6,8'}; table.add(game);
      game = {'GAME 7':'9,11:13,15'}; table.add(game);
      game = {'GAME 8':'10,12:14,16'}; table.add(game);
      game = {'GAME 9':'1,5:2,6'}; table.add(game);
      game = {'GAME 10':'3,7:4,8'}; table.add(game);
      game = {'GAME 11':'9,13:10,14'}; table.add(game);
      game = {'GAME 12':'11,15:12,16'}; table.add(game);
      game = {'GAME 13':'1,9:8,16'}; table.add(game);
      game = {'GAME 14':'2,10:7,15'}; table.add(game);
      game = {'GAME 15':'3,11:6,14'}; table.add(game);
      game = {'GAME 16':'4,12:5,13'}; table.add(game);
    }

    return table;
  }

  List<Map<String, String>> makeEditTable(playerCnt) {
    Map<String, String> game;
    if(playerCnt == 5) {
      game = {'GAME 1':'1:1:1:1'}; editTable.add(game);
      game = {'GAME 2':'2:2:2:1'}; editTable.add(game);
      game = {'GAME 3':'3:2:3:2'}; editTable.add(game);
      game = {'GAME 4':'4:3:3:3'}; editTable.add(game);
      game = {'GAME 5':'4:4:4:4'}; editTable.add(game);
    }
    else if(playerCnt == 6) {
      game = {'GAME 1':'1:1:1:1'}; editTable.add(game);
      game = {'GAME 2':'2:1:2:1'}; editTable.add(game);
      game = {'GAME 3':'2:2:2:2'}; editTable.add(game);
      game = {'GAME 4':'3:3:3:3'}; editTable.add(game);
      game = {'GAME 5':'4:4:3:3'}; editTable.add(game);
      game = {'GAME 6':'4:4:4:4'}; editTable.add(game);
    }
    else if(playerCnt == 7) {
      game = {'GAME 1':'1:1:1:1'}; editTable.add(game);
      game = {'GAME 2':'1:1:2:1'}; editTable.add(game);
      game = {'GAME 3':'2:2:2:2'}; editTable.add(game);
      game = {'GAME 4':'3:3:2:2'}; editTable.add(game);
      game = {'GAME 5':'3:3:3:3'}; editTable.add(game);
      game = {'GAME 6':'4:3:4:4'}; editTable.add(game);
      game = {'GAME 7':'4:4:4:4'}; editTable.add(game);
    }
    else if(playerCnt == 8) {
      game = {'GAME 1':'1:1:1:1'}; editTable.add(game);
      game = {'GAME 2':'1:1:1:1'}; editTable.add(game);
      game = {'GAME 3':'2:2:2:2'}; editTable.add(game);
      game = {'GAME 4':'2:2:2:2'}; editTable.add(game);
      game = {'GAME 5':'3:3:3:3'}; editTable.add(game);
      game = {'GAME 6':'3:3:3:3'}; editTable.add(game);
      game = {'GAME 7':'4:4:4:4'}; editTable.add(game);
      game = {'GAME 8':'4:4:4:4'}; editTable.add(game);
    }
    else if(playerCnt == 9) {
      game = {'GAME 1':'1:1:1:1'}; editTable.add(game);
      game = {'GAME 2':'1:1:1:1'}; editTable.add(game);
      game = {'GAME 3':'2:1:2:2'}; editTable.add(game);
      game = {'GAME 4':'2:2:2:2'}; editTable.add(game);
      game = {'GAME 5':'2:2:3:3'}; editTable.add(game);
      game = {'GAME 6':'3:3:3:3'}; editTable.add(game);
      game = {'GAME 7':'4:3:4:3'}; editTable.add(game);
      game = {'GAME 8':'4:4:3:4'}; editTable.add(game);
      game = {'GAME 9':'4:4:4:4'}; editTable.add(game);
    }
    else if(playerCnt == 10) {
      game = {'GAME 1':'1:1:1:1'}; editTable.add(game);
      game = {'GAME 2':'1:1:1:1'}; editTable.add(game);
      game = {'GAME 3':'2:2:2:1'}; editTable.add(game);
      game = {'GAME 4':'2:1:2:2'}; editTable.add(game);
      game = {'GAME 5':'3:2:2:3'}; editTable.add(game);
      game = {'GAME 6':'3:2:3:2'}; editTable.add(game);
      game = {'GAME 7':'3:3:3:4'}; editTable.add(game);
      game = {'GAME 8':'3:4:3:3'}; editTable.add(game);
      game = {'GAME 9':'4:4:4:4'}; editTable.add(game);
      game = {'GAME 10':'4:4:4:4'}; editTable.add(game);
    }
    else if(playerCnt == 11) {
      game = {'GAME 1':'1:1:1:1'}; editTable.add(game);
      game = {'GAME 2':'1:1:1:1'}; editTable.add(game);
      game = {'GAME 3':'2:1:1:1'}; editTable.add(game);
      game = {'GAME 4':'2:2:2:2'}; editTable.add(game);
      game = {'GAME 5':'2:2:2:2'}; editTable.add(game);
      game = {'GAME 6':'3:3:2:2'}; editTable.add(game);
      game = {'GAME 7':'3:3:3:3'}; editTable.add(game);
      game = {'GAME 8':'3:3:3:3'}; editTable.add(game);
      game = {'GAME 9':'4:3:4:4'}; editTable.add(game);
      game = {'GAME 10':'4:4:4:4'}; editTable.add(game);
      game = {'GAME 11':'4:4:4:4'}; editTable.add(game);
    }
    else if(playerCnt == 12) {
      game = {'GAME 1':'1:1:1:1'}; editTable.add(game);
      game = {'GAME 2':'1:1:1:1'}; editTable.add(game);
      game = {'GAME 3':'1:1:1:1'}; editTable.add(game);
      game = {'GAME 4':'2:2:2:2'}; editTable.add(game);
      game = {'GAME 5':'2:2:2:2'}; editTable.add(game);
      game = {'GAME 6':'2:2:2:2'}; editTable.add(game);
      game = {'GAME 7':'3:3:3:3'}; editTable.add(game);
      game = {'GAME 8':'3:3:3:3'}; editTable.add(game);
      game = {'GAME 9':'3:3:3:3'}; editTable.add(game);
      game = {'GAME 10':'4:4:4:4'}; editTable.add(game);
      game = {'GAME 11':'4:4:4:4'}; editTable.add(game);
      game = {'GAME 12':'4:4:4:4'}; editTable.add(game);
    }
    else if(playerCnt == 13) {
      game = {'GAME 1':'1:1:1:1'}; editTable.add(game);
      game = {'GAME 2':'1:1:1:1'}; editTable.add(game);
      game = {'GAME 3':'1:1:1:1'}; editTable.add(game);
      game = {'GAME 4':'2:1:2:2'}; editTable.add(game);
      game = {'GAME 5':'2:2:2:2'}; editTable.add(game);
      game = {'GAME 6':'2:2:2:2'}; editTable.add(game);
      game = {'GAME 7':'2:2:3:3'}; editTable.add(game);
      game = {'GAME 8':'3:3:3:3'}; editTable.add(game);
      game = {'GAME 9':'3:3:3:3'}; editTable.add(game);
      game = {'GAME 10':'3:3:4:3'}; editTable.add(game);
      game = {'GAME 11':'4:4:4:4'}; editTable.add(game);
      game = {'GAME 12':'4:4:4:4'}; editTable.add(game);
      game = {'GAME 13':'4:4:4:4'}; editTable.add(game);
    }
    else if(playerCnt == 14) {
      game = {'GAME 1':'1:1:1:1'}; editTable.add(game);
      game = {'GAME 2':'1:1:1:1'}; editTable.add(game);
      game = {'GAME 3':'1:1:1:1'}; editTable.add(game);
      game = {'GAME 4':'1:1:2:2'}; editTable.add(game);
      game = {'GAME 5':'2:2:2:2'}; editTable.add(game);
      game = {'GAME 6':'2:2:2:2'}; editTable.add(game);
      game = {'GAME 7':'3:3:2:2'}; editTable.add(game);
      game = {'GAME 8':'3:3:2:2'}; editTable.add(game);
      game = {'GAME 9':'3:3:3:3'}; editTable.add(game);
      game = {'GAME 10':'3:3:4:3'}; editTable.add(game);
      game = {'GAME 11':'3:3:4:4'}; editTable.add(game);
      game = {'GAME 12':'4:3:4:4'}; editTable.add(game);
      game = {'GAME 13':'4:4:4:4'}; editTable.add(game);
      game = {'GAME 14':'4:4:4:4'}; editTable.add(game);
    }
    else if(playerCnt == 15) {
      game = {'GAME 1':'1:1:1:1'}; editTable.add(game);
      game = {'GAME 2':'1:1:1:1'}; editTable.add(game);
      game = {'GAME 3':'1:1:1:1'}; editTable.add(game);
      game = {'GAME 4':'1:1:2:1'}; editTable.add(game);
      game = {'GAME 5':'2:2:2:2'}; editTable.add(game);
      game = {'GAME 6':'2:2:2:2'}; editTable.add(game);
      game = {'GAME 7':'2:2:2:2'}; editTable.add(game);
      game = {'GAME 8':'3:2:3:2'}; editTable.add(game);
      game = {'GAME 9':'3:3:3:3'}; editTable.add(game);
      game = {'GAME 10':'3:3:3:3'}; editTable.add(game);
      game = {'GAME 11':'3:3:4:3'}; editTable.add(game);
      game = {'GAME 12':'4:4:3:3'}; editTable.add(game);
      game = {'GAME 13':'4:4:4:4'}; editTable.add(game);
      game = {'GAME 14':'4:4:4:4'}; editTable.add(game);
      game = {'GAME 15':'4:4:4:4'}; editTable.add(game);
    }
    else if(playerCnt == 16) {
      game = {'GAME 1':'1:1:1:1'}; editTable.add(game);
      game = {'GAME 2':'1:1:1:1'}; editTable.add(game);
      game = {'GAME 3':'1:1:1:1'}; editTable.add(game);
      game = {'GAME 4':'1:1:1:1'}; editTable.add(game);
      game = {'GAME 5':'2:2:2:2'}; editTable.add(game);
      game = {'GAME 6':'2:2:2:2'}; editTable.add(game);
      game = {'GAME 7':'2:2:2:2'}; editTable.add(game);
      game = {'GAME 8':'2:2:2:2'}; editTable.add(game);
      game = {'GAME 9':'3:3:3:3'}; editTable.add(game);
      game = {'GAME 10':'3:3:3:3'}; editTable.add(game);
      game = {'GAME 11':'3:3:3:3'}; editTable.add(game);
      game = {'GAME 12':'3:3:3:3'}; editTable.add(game);
      game = {'GAME 13':'4:4:4:4'}; editTable.add(game);
      game = {'GAME 14':'4:4:4:4'}; editTable.add(game);
      game = {'GAME 15':'4:4:4:4'}; editTable.add(game);
      game = {'GAME 16':'4:4:4:4'}; editTable.add(game);
    }

    return editTable;
  }

  void setTableIndex(playerCnt) {
      table_index['GAME 1'] = 1;
      table_index['GAME 2'] = 2;
      table_index['GAME 3'] = 3;
      table_index['GAME 4'] = 4;
      table_index['GAME 5'] = 5;
      table_index['GAME 6'] = 6;
      table_index['GAME 7'] = 7;
      table_index['GAME 8'] = 8;
      table_index['GAME 9'] = 9;
      table_index['GAME 10'] = 10;
      table_index['GAME 11'] = 11;
      table_index['GAME 12'] = 12;
      table_index['GAME 13'] = 13;
      table_index['GAME 14'] = 14;
      table_index['GAME 15'] = 15;
      table_index['GAME 16'] = 16;
  }

  Map<String, int> getTableIndex() {
    return table_index;
  }
}