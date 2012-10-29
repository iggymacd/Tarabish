
class GameView {
  //var currentWindow;
  GameView(){
    query('#play').on.click.add(playListener);
    
  }
}

playListener(Event event){
  var numOfPlayers = int.parse(query('#choose-players').text);
  var playController = new PlayController(numOfPlayers);
  playController.startGame();
  playController.setupTable();
}