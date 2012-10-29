
class PlayController {
  var numberOfPlayers;
  var model;
  var view;
  PlayerModel dealer;
  PlayerModel nextToPlay;
  List<num> dealMap = [1,3,0,2];
  List<PlayerModel> hands;
  PlayController(this.numberOfPlayers){
    model = new GameModel(numberOfPlayers);
    hands = model.deal();
    view = new TableView();
  }
  setupTable(){
    //num playerCounter = 1;
    for(final hand in hands){
      hand.sortCards();
    }
    view.renderTable(hands);
  }
  startGame(){
    selectRandomDealer();
  }

  selectRandomDealer() {
    List players = model.players;
    Random randomPlayer = new Random();
    num dealerIndex = randomPlayer.nextInt(players.length);
    num nextToPlayIndex = dealMap[dealerIndex];
    dealer = players[dealerIndex];
    nextToPlay = players[nextToPlayIndex];
    dealer.isDealer = true;
    nextToPlay.isNextToPlay = true;
  }

  
}
