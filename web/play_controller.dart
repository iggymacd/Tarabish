
class PlayController {
  var numberOfPlayers;
  var model;
  var view;
  num dealer;
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
    dealer = randomPlayer.nextInt(players.length);
    //view.
  }

  
}
