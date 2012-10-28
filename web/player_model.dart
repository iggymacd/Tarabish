//library model;
class PlayerModel {
  var name;
  List cards;
  PlayerModel(this.name){
    cards = new List();
  }
  
  List sortCards(){
    cards.sort(compare(a,b) {
      if (a == b) {
        return 0;
      } else if (a.suit.suitValue > b.suit.suitValue) {
        return 1;
      } else if ((a.suit.suitValue == b.suit.suitValue) && (a.rank.rankValue > b.rank.rankValue)) {
        return 1;
      } else {
        return -1;
      }
    });
  }
  
}
