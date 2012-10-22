class PlayController {
  var numberOfPlayers;
  var model;
  var view;
  List hands;
  PlayController(this.numberOfPlayers){
    model = new GameModel(numberOfPlayers);
    hands = model.deal();
    view = new TableView();
  }
  setupTable(){
    //num playerCounter = 1;
    view.renderTable(hands);
  }

  
}
